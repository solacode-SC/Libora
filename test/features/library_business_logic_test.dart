import 'package:flutter_test/flutter_test.dart';
import 'package:libora/core/services/default_pdf_file_service.dart';
import 'package:libora/database/app_database.dart';
import 'package:libora/features/folders/data/repositories/folder_repository.dart';
import 'package:libora/features/folders/domain/models/folder_item.dart';
import 'package:libora/features/library/data/repositories/pdf_repository.dart';
import 'package:libora/features/library/domain/models/pdf_item.dart';
import 'package:libora/features/library/presentation/controllers/library_state.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late PdfRepository pdfRepo;
  late FolderRepository folderRepo;

  setUp(() {
    db = createTestDatabase();
    pdfRepo = DriftPdfRepository(db.pdfsDao);
    folderRepo = DriftFolderRepository(db.foldersDao, db.pdfsDao);
  });

  tearDown(() async {
    await db.close();
  });

  group('Database & DAO Operations Tests', () {
    test('inserts and retrieves PDF with fileHash and metadata', () async {
      final now = DateTime.now();
      await db.pdfsDao.insertPdf(
        PdfsCompanion.insert(
          id: 'pdf-1',
          title: 'Clean Code',
          fileName: 'clean_code.pdf',
          createdAt: now,
          updatedAt: now,
        ),
      );

      final fetched = await db.pdfsDao.getPdfById('pdf-1');
      expect(fetched, isNotNull);
      expect(fetched?.title, equals('Clean Code'));
      expect(fetched?.fileName, equals('clean_code.pdf'));
    });

    test('updateTitle updates document title in database', () async {
      final now = DateTime.now();
      await db.pdfsDao.insertPdf(
        PdfsCompanion.insert(
          id: 'pdf-title-test',
          title: 'Original Title',
          fileName: 'doc.pdf',
          createdAt: now,
          updatedAt: now,
        ),
      );

      await db.pdfsDao.updateTitle('pdf-title-test', 'Renamed Title');
      final updated = await db.pdfsDao.getPdfById('pdf-title-test');
      expect(updated?.title, equals('Renamed Title'));
    });

    test('moveToFolder moves document to a folder', () async {
      final now = DateTime.now();
      await db.pdfsDao.insertPdf(
        PdfsCompanion.insert(
          id: 'pdf-folder-test',
          title: 'Folder Test',
          fileName: 'folder_test.pdf',
          createdAt: now,
          updatedAt: now,
        ),
      );

      await db.pdfsDao.moveToFolder('pdf-folder-test', 'folder-alpha');
      final updated = await db.pdfsDao.getPdfById('pdf-folder-test');
      expect(updated?.folderId, equals('folder-alpha'));

      // Move back to root (null)
      await db.pdfsDao.moveToFolder('pdf-folder-test', null);
      final rootDoc = await db.pdfsDao.getPdfById('pdf-folder-test');
      expect(rootDoc?.folderId, isNull);
    });

    test('deletePdf removes document from database', () async {
      final now = DateTime.now();
      await db.pdfsDao.insertPdf(
        PdfsCompanion.insert(
          id: 'pdf-delete-test',
          title: 'To Delete',
          fileName: 'delete.pdf',
          createdAt: now,
          updatedAt: now,
        ),
      );

      expect(await db.pdfsDao.getPdfById('pdf-delete-test'), isNotNull);
      await db.pdfsDao.deletePdf('pdf-delete-test');
      expect(await db.pdfsDao.getPdfById('pdf-delete-test'), isNull);
    });

    test('createFolder and renameFolder work through DAO', () async {
      final now = DateTime.now();
      await db.foldersDao.insertFolder(
        FoldersCompanion.insert(
          id: 'f-1',
          name: 'Computer Science',
          createdAt: now,
          updatedAt: now,
        ),
      );

      var folder = await db.foldersDao.getFolderById('f-1');
      expect(folder?.name, equals('Computer Science'));

      await db.foldersDao.renameFolder('f-1', 'Programming');
      folder = await db.foldersDao.getFolderById('f-1');
      expect(folder?.name, equals('Programming'));
    });
  });

  group('Repository & Duplicate Detection Tests', () {
    test('saves PDF and detects duplicates via SHA-256 hash', () async {
      final now = DateTime.now();
      final item = PdfItem(
        id: 'dup-1',
        title: 'Design Patterns',
        fileName: 'design_patterns.pdf',
        fileSize: 4096,
        fileHash: 'sha256_hash_123456789',
        createdAt: now,
        updatedAt: now,
      );

      await pdfRepo.savePdf(item);

      // Duplicate match by hash
      final matchByHash = await pdfRepo.findDuplicate(
        hash: 'sha256_hash_123456789',
        fileSize: 9999, // even with different size, hash matches
        fileName: 'different_name.pdf',
      );
      expect(matchByHash, isNotNull);
      expect(matchByHash?.id, equals('dup-1'));

      // Duplicate match by fileName + fileSize
      final matchBySizeName = await pdfRepo.findDuplicate(
        hash: null,
        fileSize: 4096,
        fileName: 'design_patterns.pdf',
      );
      expect(matchBySizeName, isNotNull);
      expect(matchBySizeName?.id, equals('dup-1'));

      // No match for new file
      final noMatch = await pdfRepo.findDuplicate(
        hash: 'unknown_hash',
        fileSize: 1024,
        fileName: 'unrelated.pdf',
      );
      expect(noMatch, isNull);
    });

    test('deleting folder detaches PDFs to root (folderId = null)', () async {
      final now = DateTime.now();
      await folderRepo.createFolder(
        FolderItem(
          id: 'folder-beta',
          name: 'Beta Folder',
          createdAt: now,
          updatedAt: now,
        ),
      );

      final item = PdfItem(
        id: 'pdf-in-beta',
        title: 'Beta Book',
        fileName: 'beta.pdf',
        folderId: 'folder-beta',
        createdAt: now,
        updatedAt: now,
      );
      await pdfRepo.savePdf(item);

      var doc = await pdfRepo.getPdfById('pdf-in-beta');
      expect(doc?.folderId, equals('folder-beta'));

      // Delete folder
      await folderRepo.deleteFolder('folder-beta');

      final folders = await folderRepo.getAllFolders();
      expect(folders.any((f) => f.id == 'folder-beta'), isFalse);

      // Verify PDF is not deleted, but detached
      doc = await pdfRepo.getPdfById('pdf-in-beta');
      expect(doc, isNotNull);
      expect(doc?.folderId, isNull);
    });
  });

  group('Search Logic Tests', () {
    final now = DateTime.now();
    final samplePdfs = [
      PdfItem(
        id: '1',
        title: 'Clean Code',
        fileName: 'clean_code.pdf',
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now,
      ),
      PdfItem(
        id: '2',
        title: 'Clean Architecture',
        fileName: 'clean_architecture.pdf',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now,
      ),
      PdfItem(
        id: '3',
        title: 'Flutter Cookbook',
        fileName: 'flutter_cookbook.pdf',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
      ),
    ];

    test('searching "clean" matches Clean Code and Clean Architecture', () {
      final state = LibraryState(allPdfs: samplePdfs, searchQuery: 'clean');
      final visible = state.visiblePdfs;

      expect(visible.length, equals(2));
      expect(
        visible.map((p) => p.title),
        containsAll(['Clean Code', 'Clean Architecture']),
      );
      expect(visible.map((p) => p.title), isNot(contains('Flutter Cookbook')));
    });

    test('searching "cookbook" matches Flutter Cookbook', () {
      final state = LibraryState(allPdfs: samplePdfs, searchQuery: 'cookbook');
      final visible = state.visiblePdfs;

      expect(visible.length, equals(1));
      expect(visible.first.title, equals('Flutter Cookbook'));
    });

    test('search is case-insensitive and trims surrounding whitespace', () {
      final state = LibraryState(allPdfs: samplePdfs, searchQuery: '  CLEAN  ');
      final visible = state.visiblePdfs;

      expect(visible.length, equals(2));
    });

    test('empty search returns all items', () {
      final state = LibraryState(allPdfs: samplePdfs, searchQuery: '');
      final visible = state.visiblePdfs;

      expect(visible.length, equals(3));
    });
  });

  group('Sorting Logic Tests', () {
    final t1 = DateTime(2026, 1, 1);
    final t2 = DateTime(2026, 2, 1);
    final t3 = DateTime(2026, 3, 1);

    final sortPdfs = [
      PdfItem(
        id: 'a',
        title: 'Refactoring',
        fileName: 'refactoring.pdf',
        fileSize: 5000,
        createdAt: t1,
        updatedAt: t1,
      ),
      PdfItem(
        id: 'b',
        title: 'Algorithms',
        fileName: 'algorithms.pdf',
        fileSize: 2000,
        createdAt: t2,
        updatedAt: t2,
      ),
      PdfItem(
        id: 'c',
        title: 'Design Patterns',
        fileName: 'design_patterns.pdf',
        fileSize: 9000,
        createdAt: t3,
        updatedAt: t3,
      ),
    ];

    test('sorts by Recently Added (newest first)', () {
      final state = LibraryState(
        allPdfs: sortPdfs,
        selectedSort: LibrarySort.recentlyAdded,
      );
      final titles = state.visiblePdfs.map((p) => p.title).toList();
      expect(titles, equals(['Design Patterns', 'Algorithms', 'Refactoring']));
    });

    test('sorts by Name A–Z', () {
      final state = LibraryState(
        allPdfs: sortPdfs,
        selectedSort: LibrarySort.nameAsc,
      );
      final titles = state.visiblePdfs.map((p) => p.title).toList();
      expect(titles, equals(['Algorithms', 'Design Patterns', 'Refactoring']));
    });

    test('sorts by Name Z–A', () {
      final state = LibraryState(
        allPdfs: sortPdfs,
        selectedSort: LibrarySort.nameDesc,
      );
      final titles = state.visiblePdfs.map((p) => p.title).toList();
      expect(titles, equals(['Refactoring', 'Design Patterns', 'Algorithms']));
    });

    test('sorts by Largest file size', () {
      final state = LibraryState(
        allPdfs: sortPdfs,
        selectedSort: LibrarySort.largest,
      );
      final titles = state.visiblePdfs.map((p) => p.title).toList();
      expect(titles, equals(['Design Patterns', 'Refactoring', 'Algorithms']));
    });

    test('sorts by Smallest file size', () {
      final state = LibraryState(
        allPdfs: sortPdfs,
        selectedSort: LibrarySort.smallest,
      );
      final titles = state.visiblePdfs.map((p) => p.title).toList();
      expect(titles, equals(['Algorithms', 'Refactoring', 'Design Patterns']));
    });
  });

  group('cleanTitleFromFileName Helper Tests', () {
    test('cleans dashes and underscores and capitalizes words', () {
      expect(
        DefaultPdfFileService.cleanTitleFromFileName('clean-code.pdf'),
        equals('Clean Code'),
      );
      expect(
        DefaultPdfFileService.cleanTitleFromFileName(
          'refactoring_2nd_edition.pdf',
        ),
        equals('Refactoring 2nd Edition'),
      );
      expect(
        DefaultPdfFileService.cleanTitleFromFileName('my-study-guide.PDF'),
        equals('My Study Guide'),
      );
      expect(
        DefaultPdfFileService.cleanTitleFromFileName('untitled'),
        equals('Untitled'),
      );
    });
  });
}
