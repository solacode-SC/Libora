import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:libora/database/app_database.dart';
import 'package:libora/features/bookmarks/data/repositories/bookmark_repository.dart';
import 'package:libora/features/folders/data/repositories/folder_repository.dart';
import 'package:libora/features/library/data/repositories/pdf_repository.dart';
import 'package:libora/features/library/domain/models/pdf_item.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late PdfRepository pdfRepo;
  late FolderRepository folderRepo;
  late BookmarkRepository bookmarkRepo;

  setUp(() {
    db = createTestDatabase();
    pdfRepo = DriftPdfRepository(db.pdfsDao);
    folderRepo = DriftFolderRepository(db.foldersDao);
    bookmarkRepo = DriftBookmarkRepository(db.bookmarksDao);
  });

  tearDown(() async {
    await db.close();
  });

  group('Database & DAO Initialization Tests', () {
    test('database initializes and creates tables cleanly', () async {
      final pdfs = await db.pdfsDao.getAllPdfs();
      expect(pdfs, isEmpty);

      final folders = await db.foldersDao.getAllFolders();
      expect(folders, isEmpty);

      final bookmarks = await db.bookmarksDao.watchAllBookmarks().first;
      expect(bookmarks, isEmpty);
    });

    test('inserts and retrieves a PDF entry through DAO', () async {
      final now = DateTime.now();
      await db.pdfsDao.insertPdf(
        PdfsCompanion.insert(
          id: 'test-1',
          title: 'Clean Architecture',
          fileName: 'clean_architecture.pdf',
          createdAt: now,
          updatedAt: now,
        ),
      );

      final pdf = await db.pdfsDao.getPdfById('test-1');
      expect(pdf, isNotNull);
      expect(pdf?.title, equals('Clean Architecture'));
      expect(pdf?.isFavorite, isFalse);
    });

    test('PdfRepository saves, queries, and toggles favorite', () async {
      final now = DateTime.now();
      final item = PdfItem(
        id: 'repo-pdf-1',
        title: 'Flutter in Action',
        fileName: 'flutter_in_action.pdf',
        createdAt: now,
        updatedAt: now,
      );

      await pdfRepo.savePdf(item);

      final queried = await pdfRepo.getPdfById('repo-pdf-1');
      expect(queried, isNotNull);
      expect(queried?.title, equals('Flutter in Action'));
      expect(queried?.isFavorite, isFalse);

      await pdfRepo.toggleFavorite('repo-pdf-1', true);
      final updated = await pdfRepo.getPdfById('repo-pdf-1');
      expect(updated?.isFavorite, isTrue);

      final favorites = await pdfRepo.watchFavorites().first;
      expect(favorites.length, equals(1));
      expect(favorites.first.id, equals('repo-pdf-1'));
    });

    test(
      'FolderRepository and BookmarkRepository can be instantiated and queried',
      () async {
        final folders = await folderRepo.getAllFolders();
        expect(folders, isEmpty);

        final bookmarks = await bookmarkRepo.getBookmarksForPdf('non-existent');
        expect(bookmarks, isEmpty);
      },
    );

    test('updates reading progress and lastReadAt via DAO', () async {
      final now = DateTime(2026, 1, 1);
      await db.pdfsDao.insertPdf(
        PdfsCompanion.insert(
          id: 'read-test-1',
          title: 'Clean Code',
          fileName: 'clean_code.pdf',
          currentPage: const Value(1),
          createdAt: now,
          updatedAt: now,
        ),
      );

      var pdf = await db.pdfsDao.getPdfById('read-test-1');
      expect(pdf?.currentPage, equals(1));
      expect(pdf?.lastReadAt, isNull);

      await db.pdfsDao.updateReadingProgress('read-test-1', 127);
      pdf = await db.pdfsDao.getPdfById('read-test-1');
      expect(pdf?.currentPage, equals(127));
      expect(pdf?.lastReadAt, isNotNull);

      // Verify updating to 128
      await db.pdfsDao.updateReadingProgress('read-test-1', 128);
      pdf = await db.pdfsDao.getPdfById('read-test-1');
      expect(pdf?.currentPage, equals(128));
    });

    test(
      'PdfRepository saves, updates reading progress and restores page',
      () async {
        final now = DateTime.now();
        final item = PdfItem(
          id: 'repo-read-1',
          title: 'Design Patterns',
          fileName: 'design_patterns.pdf',
          currentPage: 42,
          pageCount: 395,
          createdAt: now,
          updatedAt: now,
        );

        await pdfRepo.savePdf(item);

        var queried = await pdfRepo.getPdfById('repo-read-1');
        expect(queried?.currentPage, equals(42));
        expect(queried?.pageCount, equals(395));

        // Advance reading position
        await pdfRepo.updateReadingProgress('repo-read-1', 127);
        queried = await pdfRepo.getPdfById('repo-read-1');
        expect(queried?.currentPage, equals(127));
        expect(queried?.lastReadAt, isNotNull);
      },
    );

    test('schema version is 3', () {
      expect(db.schemaVersion, equals(3));
    });

    test(
      'BookmarksDao supports note, updatedAt, and getBookmarkByPage',
      () async {
        final now = DateTime.now();
        await db.pdfsDao.insertPdf(
          PdfsCompanion.insert(
            id: 'pdf-bm-dao-1',
            title: 'Testing Bookmarks',
            fileName: 'bookmarks.pdf',
            createdAt: now,
            updatedAt: now,
          ),
        );

        await db.bookmarksDao.insertBookmark(
          BookmarksCompanion.insert(
            id: 'bm-dao-1',
            pdfId: 'pdf-bm-dao-1',
            pageNumber: 5,
            label: const Value('Chapter 1'),
            note: const Value('Crucial concept here'),
            createdAt: now,
            updatedAt: Value(now),
          ),
        );

        final bm = await db.bookmarksDao.getBookmarkByPage('pdf-bm-dao-1', 5);
        expect(bm, isNotNull);
        expect(bm?.label, equals('Chapter 1'));
        expect(bm?.note, equals('Crucial concept here'));

        final count = await db.bookmarksDao.getBookmarkCountForPdf(
          'pdf-bm-dao-1',
        );
        expect(count, equals(1));
      },
    );
  });
}
