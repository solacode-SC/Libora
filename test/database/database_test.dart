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
  });
}
