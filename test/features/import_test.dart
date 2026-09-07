import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libora/core/services/default_pdf_file_service.dart';
import 'package:libora/core/services/default_pdf_thumbnail_service.dart';
import 'package:libora/core/services/local_storage_service.dart';
import 'package:libora/database/app_database.dart';
import 'package:libora/features/folders/data/repositories/folder_repository.dart';
import 'package:libora/features/library/data/repositories/pdf_repository.dart';
import 'package:libora/features/library/presentation/controllers/library_controller.dart';

import '../helpers/test_database.dart';

class MockPdfFileService extends DefaultPdfFileService {
  List<File> filesToReturn = [];

  @override
  Future<List<File>> pickPdfFiles() async {
    return filesToReturn;
  }
}

void main() {
  late Directory tempDir;
  late AppDatabase db;
  late PdfRepository pdfRepo;
  late FolderRepository folderRepo;
  late LocalStorageService storageService;
  late MockPdfFileService mockFileService;
  late DefaultPdfThumbnailService thumbnailService;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('libora_import_test_');
    db = createTestDatabase();
    pdfRepo = DriftPdfRepository(db.pdfsDao);
    folderRepo = DriftFolderRepository(db.foldersDao, db.pdfsDao);
    storageService = LocalStorageService(
      baseDirectory: Directory('${tempDir.path}/managed_libora'),
    );
    mockFileService = MockPdfFileService();
    thumbnailService = DefaultPdfThumbnailService();
  });

  tearDown(() async {
    await db.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('PDF Validation & Header Tests', () {
    test('validatePdf accepts valid %PDF- header', () async {
      final file = File('${tempDir.path}/valid.pdf');
      await file.writeAsString(
        '%PDF-1.4\n1 0 obj\n<<>>\nendobj\ntrailer\n<<>>\n%%EOF',
      );

      final service = DefaultPdfFileService();
      final isValid = await service.validatePdf(file);
      expect(isValid, isTrue);
    });

    test(
      'validatePdf accepts PDF with leading comment or whitespace',
      () async {
        final file = File('${tempDir.path}/bom.pdf');
        final bytes = [
          0xEF, 0xBB, 0xBF, // UTF-8 BOM
          0x25, 0x50, 0x44, 0x46, 0x2D, 0x31, 0x2E, 0x34, // %PDF-1.4
        ];
        await file.writeAsBytes(bytes);

        final service = DefaultPdfFileService();
        final isValid = await service.validatePdf(file);
        expect(isValid, isTrue);
      },
    );

    test('validatePdf rejects non-PDF files', () async {
      final txtFile = File('${tempDir.path}/notes.txt');
      await txtFile.writeAsString(
        'This is just plain text, not a PDF document.',
      );

      final service = DefaultPdfFileService();
      expect(await service.validatePdf(txtFile), isFalse);

      final emptyFile = File('${tempDir.path}/empty.pdf');
      await emptyFile.writeAsBytes([]);
      expect(await service.validatePdf(emptyFile), isFalse);

      final nonExistent = File('${tempDir.path}/ghost.pdf');
      expect(await service.validatePdf(nonExistent), isFalse);
    });
  });

  group('Filename Cleaning & Metadata Extraction Tests', () {
    test('cleans complex filenames and preserves titles', () {
      expect(
        DefaultPdfFileService.cleanTitleFromFileName(
          'Clean_Code-2nd_Edition.pdf',
        ),
        equals('Clean Code 2nd Edition'),
      );
      expect(
        DefaultPdfFileService.cleanTitleFromFileName('my book (2026).pdf'),
        equals('My Book (2026)'),
      );
      expect(
        DefaultPdfFileService.cleanTitleFromFileName('كتاب.pdf'),
        equals('كتاب'),
      );
      expect(
        DefaultPdfFileService.cleanTitleFromFileName('book.with.dots.pdf'),
        equals('Book.with.dots'),
      );
      expect(
        DefaultPdfFileService.cleanTitleFromFileName('.pdf'),
        equals('Untitled'),
      );
    });

    test('extracts metadata and computes SHA-256 hash', () async {
      final file = File('${tempDir.path}/sample.pdf');
      await file.writeAsString('%PDF-1.7 sample test file for hashing');

      final service = DefaultPdfFileService();
      final metadata = await service.extractMetadata(file);
      expect(metadata.title, equals('Sample'));
      expect(metadata.fileSize, greaterThan(0));

      final hash1 = await service.computeFileHash(file);
      expect(hash1, isNotEmpty);

      // Identical content has identical hash
      final file2 = File('${tempDir.path}/sample_copy.pdf');
      await file2.writeAsString('%PDF-1.7 sample test file for hashing');
      final hash2 = await service.computeFileHash(file2);
      expect(hash1, equals(hash2));
    });
  });

  group('Managed Storage & Source Independence Tests', () {
    test(
      'copies to managed storage and remains independent of original source',
      () async {
        final userDownloadsDir = Directory('${tempDir.path}/downloads');
        await userDownloadsDir.create();
        final sourceFile = File('${userDownloadsDir.path}/original.pdf');
        await sourceFile.writeAsString(
          '%PDF-1.4 user original document content',
        );

        // Copy to managed storage
        final managed = await storageService.copyToManagedStorage(
          sourceFile,
          'test-uuid-1',
        );
        expect(managed.existsSync(), isTrue);
        expect(managed.path, contains('managed_libora'));
        expect(managed.path, endsWith('test-uuid-1.pdf'));

        // Delete the original source file (simulating user deleting it from Downloads)
        await sourceFile.delete();
        expect(sourceFile.existsSync(), isFalse);

        // Managed copy MUST still exist and remain readable
        expect(managed.existsSync(), isTrue);
        final content = await managed.readAsString();
        expect(content, contains('%PDF-1.4 user original'));
      },
    );

    test('deleteManagedFile removes file cleanly', () async {
      final source = File('${tempDir.path}/to_delete.pdf');
      await source.writeAsString('%PDF-1.4 delete test');
      final managed = await storageService.copyToManagedStorage(
        source,
        'delete-uuid',
      );
      expect(managed.existsSync(), isTrue);

      await storageService.deleteManagedFile(managed.path);
      expect(managed.existsSync(), isFalse);
    });
  });

  group('End-to-End LibraryController Import Flow Tests', () {
    test(
      'imports single PDF, persists in SQLite, and updates library state',
      () async {
        final sourceFile = File('${tempDir.path}/clean_architecture.pdf');
        await sourceFile.writeAsString(
          '%PDF-1.4 clean architecture principles',
        );

        mockFileService.filesToReturn = [sourceFile];

        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            pdfRepositoryProvider.overrideWithValue(pdfRepo),
            folderRepositoryProvider.overrideWithValue(folderRepo),
            storageServiceProvider.overrideWithValue(storageService),
            pdfFileServiceProvider.overrideWithValue(mockFileService),
            pdfThumbnailServiceProvider.overrideWithValue(thumbnailService),
          ],
        );
        addTearDown(container.dispose);

        final controller = container.read(libraryControllerProvider.notifier);
        await Future<void>.delayed(const Duration(milliseconds: 30));

        // Trigger import
        await controller.importPdfs();
        await Future<void>.delayed(const Duration(milliseconds: 50));

        final state = container.read(libraryControllerProvider);
        expect(state.allPdfs.length, equals(1));
        expect(state.allPdfs.first.title, equals('Clean Architecture'));
        expect(state.allPdfs.first.fileName, equals('clean_architecture.pdf'));
        expect(state.userNotice, contains('Imported 1 document'));

        // Verify physical file exists in managed storage
        final managedFile = File(state.allPdfs.first.localPath!);
        expect(managedFile.existsSync(), isTrue);
        expect(managedFile.path, contains('managed_libora'));

        // Verify SQLite record
        final dbEntry = await pdfRepo.getPdfById(state.allPdfs.first.id);
        expect(dbEntry, isNotNull);
        expect(dbEntry?.title, equals('Clean Architecture'));
      },
    );

    test('imports multiple PDFs and skips duplicates gracefully', () async {
      final file1 = File('${tempDir.path}/book_one.pdf');
      await file1.writeAsString('%PDF-1.4 book one contents');
      final file2 = File('${tempDir.path}/book_two.pdf');
      await file2.writeAsString('%PDF-1.4 book two contents');

      mockFileService.filesToReturn = [file1, file2];

      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          pdfRepositoryProvider.overrideWithValue(pdfRepo),
          folderRepositoryProvider.overrideWithValue(folderRepo),
          storageServiceProvider.overrideWithValue(storageService),
          pdfFileServiceProvider.overrideWithValue(mockFileService),
          pdfThumbnailServiceProvider.overrideWithValue(thumbnailService),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(libraryControllerProvider.notifier);
      await Future<void>.delayed(const Duration(milliseconds: 30));

      // First batch import
      await controller.importPdfs();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      var state = container.read(libraryControllerProvider);
      expect(state.allPdfs.length, equals(2));

      // Attempt duplicate import of file1 + new file3
      final file3 = File('${tempDir.path}/book_three.pdf');
      await file3.writeAsString('%PDF-1.4 book three contents');
      mockFileService.filesToReturn = [file1, file3];

      await controller.importPdfs();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      state = container.read(libraryControllerProvider);
      expect(state.allPdfs.length, equals(3));
      expect(state.userNotice, contains('book_one.pdf'));
    });

    test('canceling file picker produces no state changes or errors', () async {
      mockFileService.filesToReturn = []; // User clicked cancel

      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          pdfRepositoryProvider.overrideWithValue(pdfRepo),
          folderRepositoryProvider.overrideWithValue(folderRepo),
          storageServiceProvider.overrideWithValue(storageService),
          pdfFileServiceProvider.overrideWithValue(mockFileService),
          pdfThumbnailServiceProvider.overrideWithValue(thumbnailService),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(libraryControllerProvider.notifier);
      await Future<void>.delayed(const Duration(milliseconds: 30));

      await controller.importPdfs();

      final state = container.read(libraryControllerProvider);
      expect(state.allPdfs, isEmpty);
      expect(state.errorMessage, isNull);
      expect(state.isImporting, isFalse);
    });

    test(
      'deleting imported PDF cleans managed file and database entry',
      () async {
        final source = File('${tempDir.path}/to_remove.pdf');
        await source.writeAsString('%PDF-1.4 remove me');
        mockFileService.filesToReturn = [source];

        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            pdfRepositoryProvider.overrideWithValue(pdfRepo),
            folderRepositoryProvider.overrideWithValue(folderRepo),
            storageServiceProvider.overrideWithValue(storageService),
            pdfFileServiceProvider.overrideWithValue(mockFileService),
            pdfThumbnailServiceProvider.overrideWithValue(thumbnailService),
          ],
        );
        addTearDown(container.dispose);

        final controller = container.read(libraryControllerProvider.notifier);
        await Future<void>.delayed(const Duration(milliseconds: 30));

        await controller.importPdfs();
        await Future<void>.delayed(const Duration(milliseconds: 50));

        var state = container.read(libraryControllerProvider);
        final pdfId = state.allPdfs.first.id;
        final localPath = state.allPdfs.first.localPath!;
        expect(File(localPath).existsSync(), isTrue);

        // Delete the PDF
        await controller.deletePdf(pdfId);
        await Future<void>.delayed(const Duration(milliseconds: 50));

        state = container.read(libraryControllerProvider);
        expect(state.allPdfs, isEmpty);
        expect(File(localPath).existsSync(), isFalse);
        expect(await pdfRepo.getPdfById(pdfId), isNull);
      },
    );
  });
}
