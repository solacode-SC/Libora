import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libora/core/services/default_pdf_file_service.dart';
import 'package:libora/core/services/default_pdf_thumbnail_service.dart';
import 'package:libora/core/services/local_storage_service.dart';
import 'package:libora/database/app_database.dart';
import 'package:libora/features/bookmarks/data/repositories/bookmark_repository.dart';
import 'package:libora/features/folders/data/repositories/folder_repository.dart';
import 'package:libora/features/library/data/repositories/pdf_repository.dart';
import 'package:libora/features/library/presentation/controllers/library_controller.dart';
import 'package:libora/features/library/presentation/controllers/library_state.dart';
import 'package:libora/features/reader/presentation/controllers/reader_controller.dart';
import 'package:libora/features/reader/presentation/controllers/reader_state.dart';

import '../helpers/test_database.dart';

class LifecycleMockFileService extends DefaultPdfFileService {
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
  late BookmarkRepository bookmarkRepo;
  late FolderRepository folderRepo;
  late LocalStorageService storageService;
  late LifecycleMockFileService mockFileService;
  late DefaultPdfThumbnailService thumbnailService;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('libora_lifecycle_test_');
    db = createTestDatabase();
    pdfRepo = DriftPdfRepository(db.pdfsDao, db.bookmarksDao);
    bookmarkRepo = DriftBookmarkRepository(db.bookmarksDao);
    folderRepo = DriftFolderRepository(db.foldersDao, db.pdfsDao);
    storageService = LocalStorageService(
      baseDirectory: Directory('${tempDir.path}/managed_libora'),
    );
    mockFileService = LifecycleMockFileService();
    thumbnailService = DefaultPdfThumbnailService();
  });

  tearDown(() async {
    await db.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        pdfRepositoryProvider.overrideWithValue(pdfRepo),
        bookmarkRepositoryProvider.overrideWithValue(bookmarkRepo),
        folderRepositoryProvider.overrideWithValue(folderRepo),
        storageServiceProvider.overrideWithValue(storageService),
        pdfFileServiceProvider.overrideWithValue(mockFileService),
        pdfThumbnailServiceProvider.overrideWithValue(thumbnailService),
      ],
    );
    return container;
  }

  test('Full Local PDF Lifecycle: Import -> SQLite -> Library -> Search -> Reader -> Progress -> Bookmarks -> Favorites -> Continue Reading -> Source Independence -> Safe Deletion', () async {
    final container = createContainer();
    addTearDown(container.dispose);

    // 1. Prepare external user document (e.g. in ~/Downloads)
    final downloadsDir = Directory('${tempDir.path}/downloads');
    await downloadsDir.create();
    final originalFile = File(
      '${downloadsDir.path}/Clean_Architecture_Guide.pdf',
    );
    await originalFile.writeAsString(
      '%PDF-1.5\n% Test PDF Content for complete lifecycle verification\n%%EOF',
    );

    mockFileService.filesToReturn = [originalFile];

    final libController = container.read(libraryControllerProvider.notifier);
    await Future<void>.delayed(const Duration(milliseconds: 30));

    // 2. TRIGGER IMPORT
    await libController.importPdfs();
    await Future<void>.delayed(const Duration(milliseconds: 60));

    // 3. VERIFY SQLite & MANAGED STORAGE
    final libraryState = container.read(libraryControllerProvider);
    expect(libraryState.allPdfs.length, equals(1));
    final importedPdf = libraryState.allPdfs.first;

    expect(importedPdf.title, equals('Clean Architecture Guide'));
    expect(importedPdf.fileName, equals('Clean_Architecture_Guide.pdf'));
    expect(importedPdf.localPath, isNotNull);
    expect(File(importedPdf.localPath!).existsSync(), isTrue);
    expect(importedPdf.localPath!, contains('managed_libora'));
    expect(importedPdf.fileHash, isNotNull);

    // 4. VERIFY LIBRARY DISPLAY & FILTERING / SEARCH
    libController.setSearchQuery('Architecture');
    final searchResults = container.read(libraryControllerProvider).visiblePdfs;
    expect(searchResults.length, equals(1));
    expect(searchResults.first.id, equals(importedPdf.id));

    libController.setSearchQuery('NonExistent');
    expect(container.read(libraryControllerProvider).visiblePdfs, isEmpty);

    libController.setSearchQuery(''); // Reset search

    // 5. OPEN IN READER
    final reader = container.read(
      readerControllerProvider(importedPdf.id).notifier,
    );
    await Future<void>.delayed(const Duration(milliseconds: 60));

    var rState = container.read(readerControllerProvider(importedPdf.id));
    expect(rState.status, equals(ReaderStatus.ready));
    expect(rState.title, equals('Clean Architecture Guide'));
    expect(rState.currentPage, equals(1));
    expect(rState.isFileAvailable, isTrue);

    // 6. READ & UPDATE READING PROGRESS
    reader.setTotalPages(120);
    reader.onPageChanged(14);
    await reader.persistPosition();
    await Future<void>.delayed(const Duration(milliseconds: 60));

    // Verify DB updated
    final updatedDbPdf = await pdfRepo.getPdfById(importedPdf.id);
    expect(updatedDbPdf?.currentPage, equals(14));
    expect(updatedDbPdf?.lastReadAt, isNotNull);

    // 7. ADD BOOKMARKS
    final addedBm = await reader.addBookmark(
      page: 14,
      label: 'Design Principles',
      note: 'Key takeaway on dependency inversion',
    );
    expect(addedBm, isTrue);
    await Future<void>.delayed(const Duration(milliseconds: 60));

    rState = container.read(readerControllerProvider(importedPdf.id));
    expect(rState.bookmarks.length, equals(1));
    expect(rState.bookmarks.first.label, equals('Design Principles'));
    expect(rState.bookmarks.first.pageNumber, equals(14));

    // 8. TOGGLE FAVORITE
    await reader.toggleFavorite();
    await Future<void>.delayed(const Duration(milliseconds: 60));

    rState = container.read(readerControllerProvider(importedPdf.id));
    expect(rState.isFavorite, isTrue);

    final favDbPdf = await pdfRepo.getPdfById(importedPdf.id);
    expect(favDbPdf?.isFavorite, isTrue);

    // Verify Favorites in Library Filter
    libController.setFilter(LibraryFilter.favorites);
    expect(
      container.read(libraryControllerProvider).visiblePdfs.length,
      equals(1),
    );
    libController.setFilter(LibraryFilter.all);

    // 9. VERIFY CONTINUE READING STREAM (HOME WORKFLOW)
    final continueReadingList = await pdfRepo.watchContinueReading().first;
    expect(continueReadingList.length, equals(1));
    expect(continueReadingList.first.id, equals(importedPdf.id));
    expect(continueReadingList.first.currentPage, equals(14));

    // 10. VERIFY SOURCE FILE INDEPENDENCE
    // Simulate user deleting the original downloaded file from ~/Downloads
    await originalFile.delete();
    expect(originalFile.existsSync(), isFalse);

    // Managed file is completely unaffected
    expect(File(importedPdf.localPath!).existsSync(), isTrue);

    // Reopening the reader in a new container/session still works seamlessly
    final session2Container = createContainer();
    addTearDown(session2Container.dispose);
    session2Container.read(readerControllerProvider(importedPdf.id).notifier);
    await Future<void>.delayed(const Duration(milliseconds: 60));

    final r2State = session2Container.read(
      readerControllerProvider(importedPdf.id),
    );
    expect(r2State.status, equals(ReaderStatus.ready));
    expect(r2State.currentPage, equals(14));
    expect(r2State.isFavorite, isTrue);
    expect(r2State.bookmarks.length, equals(1));

    // 11. VERIFY SAFE DELETION
    final deleteLibController = session2Container.read(
      libraryControllerProvider.notifier,
    );
    await Future<void>.delayed(const Duration(milliseconds: 40));

    await deleteLibController.deletePdf(importedPdf.id);
    await Future<void>.delayed(const Duration(milliseconds: 60));

    // Database record gone
    expect(await pdfRepo.getPdfById(importedPdf.id), isNull);
    // Managed file deleted from disk
    expect(File(importedPdf.localPath!).existsSync(), isFalse);
    // Bookmarks cascaded/cleaned up
    final remainingBookmarks = await bookmarkRepo.getBookmarksForPdf(
      importedPdf.id,
    );
    expect(remainingBookmarks, isEmpty);
    // Continue reading list empty
    final crAfterDelete = await pdfRepo.watchContinueReading().first;
    expect(crAfterDelete, isEmpty);
  });
}
