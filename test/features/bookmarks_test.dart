import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libora/database/app_database.dart';
import 'package:libora/features/bookmarks/data/repositories/bookmark_repository.dart';
import 'package:libora/features/bookmarks/domain/models/bookmark_item.dart';
import 'package:libora/features/library/data/repositories/pdf_repository.dart';
import 'package:libora/features/library/domain/models/pdf_item.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late PdfRepository pdfRepo;
  late BookmarkRepository bookmarkRepo;

  setUp(() {
    db = createTestDatabase();
    pdfRepo = DriftPdfRepository(db.pdfsDao);
    bookmarkRepo = DriftBookmarkRepository(db.bookmarksDao);
  });

  tearDown(() async {
    await db.close();
  });

  group('Bookmark Repository & DAO Tests', () {
    test('creates and retrieves bookmarks for a PDF', () async {
      final now = DateTime.now();
      await pdfRepo.savePdf(
        PdfItem(
          id: 'pdf-b1',
          title: 'Clean Architecture',
          fileName: 'clean_architecture.pdf',
          createdAt: now,
          updatedAt: now,
        ),
      );

      final b1 = BookmarkItem(
        id: 'bm-1',
        pdfId: 'pdf-b1',
        pageNumber: 42,
        label: 'Entities layer',
        note: 'Core domain business rules',
        createdAt: now,
        updatedAt: now,
      );

      await bookmarkRepo.addBookmark(b1);

      final bookmarks = await bookmarkRepo.getBookmarksForPdf('pdf-b1');
      expect(bookmarks.length, equals(1));
      expect(bookmarks.first.id, equals('bm-1'));
      expect(bookmarks.first.pageNumber, equals(42));
      expect(bookmarks.first.label, equals('Entities layer'));
      expect(bookmarks.first.note, equals('Core domain business rules'));

      final byPage = await bookmarkRepo.getBookmarkByPage('pdf-b1', 42);
      expect(byPage, isNotNull);
      expect(byPage?.id, equals('bm-1'));

      final count = await bookmarkRepo.getBookmarkCountForPdf('pdf-b1');
      expect(count, equals(1));
    });

    test('updates bookmark label and note', () async {
      final now = DateTime.now();
      await pdfRepo.savePdf(
        PdfItem(
          id: 'pdf-b2',
          title: 'Design Patterns',
          fileName: 'design_patterns.pdf',
          createdAt: now,
          updatedAt: now,
        ),
      );

      final b = BookmarkItem(
        id: 'bm-2',
        pdfId: 'pdf-b2',
        pageNumber: 10,
        label: 'Initial note',
        createdAt: now,
        updatedAt: now,
      );
      await bookmarkRepo.addBookmark(b);

      final updated = b.copyWith(
        label: 'Observer Pattern',
        note: 'Publisher and subscriber mechanics',
        updatedAt: DateTime.now(),
      );
      await bookmarkRepo.updateBookmark(updated);

      final retrieved = await bookmarkRepo.getBookmarkByPage('pdf-b2', 10);
      expect(retrieved?.label, equals('Observer Pattern'));
      expect(retrieved?.note, equals('Publisher and subscriber mechanics'));
    });

    test('deletes bookmark by ID and by page', () async {
      final now = DateTime.now();
      await pdfRepo.savePdf(
        PdfItem(
          id: 'pdf-b3',
          title: 'Refactoring',
          fileName: 'refactoring.pdf',
          createdAt: now,
          updatedAt: now,
        ),
      );

      await bookmarkRepo.addBookmark(
        BookmarkItem(
          id: 'bm-3a',
          pdfId: 'pdf-b3',
          pageNumber: 15,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await bookmarkRepo.addBookmark(
        BookmarkItem(
          id: 'bm-3b',
          pdfId: 'pdf-b3',
          pageNumber: 30,
          createdAt: now,
          updatedAt: now,
        ),
      );

      expect(
        (await bookmarkRepo.getBookmarksForPdf('pdf-b3')).length,
        equals(2),
      );

      await bookmarkRepo.deleteBookmark('bm-3a');
      expect(
        (await bookmarkRepo.getBookmarksForPdf('pdf-b3')).length,
        equals(1),
      );
      expect(await bookmarkRepo.getBookmarkByPage('pdf-b3', 15), isNull);
      expect(await bookmarkRepo.getBookmarkByPage('pdf-b3', 30), isNotNull);
    });

    test('enforces unique constraint: 1 bookmark per page per PDF', () async {
      final now = DateTime.now();
      await pdfRepo.savePdf(
        PdfItem(
          id: 'pdf-b4',
          title: 'Algorithms',
          fileName: 'algorithms.pdf',
          createdAt: now,
          updatedAt: now,
        ),
      );

      await bookmarkRepo.addBookmark(
        BookmarkItem(
          id: 'bm-4a',
          pdfId: 'pdf-b4',
          pageNumber: 50,
          label: 'First bookmark',
          createdAt: now,
          updatedAt: now,
        ),
      );

      // Attempting to insert another bookmark on the exact same page should throw SQLite constraint error
      expect(
        () async => await bookmarkRepo.addBookmark(
          BookmarkItem(
            id: 'bm-4b',
            pdfId: 'pdf-b4',
            pageNumber: 50,
            label: 'Duplicate page bookmark',
            createdAt: now,
            updatedAt: now,
          ),
        ),
        throwsA(isA<SqliteException>()),
      );
    });

    test(
      'cascade deletion: deleting a PDF deletes all its bookmarks',
      () async {
        final now = DateTime.now();
        await pdfRepo.savePdf(
          PdfItem(
            id: 'pdf-b5',
            title: 'Operating Systems',
            fileName: 'os.pdf',
            createdAt: now,
            updatedAt: now,
          ),
        );

        await bookmarkRepo.addBookmark(
          BookmarkItem(
            id: 'bm-5a',
            pdfId: 'pdf-b5',
            pageNumber: 10,
            createdAt: now,
            updatedAt: now,
          ),
        );
        await bookmarkRepo.addBookmark(
          BookmarkItem(
            id: 'bm-5b',
            pdfId: 'pdf-b5',
            pageNumber: 20,
            createdAt: now,
            updatedAt: now,
          ),
        );

        var allBookmarks = await bookmarkRepo.watchAllBookmarks().first;
        expect(allBookmarks.length, equals(2));

        // Delete the PDF via repository
        await pdfRepo.deletePdf('pdf-b5');

        allBookmarks = await bookmarkRepo.watchAllBookmarks().first;
        expect(allBookmarks, isEmpty);
      },
    );
  });
}
