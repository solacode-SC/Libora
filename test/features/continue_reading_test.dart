import 'package:flutter_test/flutter_test.dart';
import 'package:libora/database/app_database.dart';
import 'package:libora/features/library/data/repositories/pdf_repository.dart';
import 'package:libora/features/library/domain/models/pdf_item.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late PdfRepository pdfRepo;

  setUp(() {
    db = createTestDatabase();
    pdfRepo = DriftPdfRepository(db.pdfsDao);
  });

  tearDown(() async {
    await db.close();
  });

  group('Continue Reading & Recently Added Query Tests', () {
    test(
      'watchContinueReading filters out unread or unopened documents',
      () async {
        final t1 = DateTime(2026, 1, 1, 10, 0);
        final t2 = DateTime(2026, 1, 2, 10, 0);
        final t3 = DateTime(2026, 1, 3, 10, 0);

        // 1. In progress: page > 0, lastReadAt != null
        await pdfRepo.savePdf(
          PdfItem(
            id: 'pdf-cr-1',
            title: 'Clean Architecture',
            fileName: 'clean_architecture.pdf',
            currentPage: 45,
            pageCount: 300,
            createdAt: t1,
            updatedAt: t1,
          ),
        );
        await pdfRepo.updateReadingProgress('pdf-cr-1', 45, readAt: t1);

        // 2. Unopened: page == 0, lastReadAt == null
        await pdfRepo.savePdf(
          PdfItem(
            id: 'pdf-cr-2',
            title: 'Domain-Driven Design',
            fileName: 'ddd.pdf',
            currentPage: 0,
            pageCount: 500,
            createdAt: t2,
            updatedAt: t2,
          ),
        );

        // 3. Opened to page 1, then progressed to page 120
        await pdfRepo.savePdf(
          PdfItem(
            id: 'pdf-cr-3',
            title: 'Refactoring to Patterns',
            fileName: 'refactoring_patterns.pdf',
            currentPage: 1,
            pageCount: 400,
            createdAt: t3,
            updatedAt: t3,
          ),
        );
        await pdfRepo.updateReadingProgress('pdf-cr-3', 120, readAt: t3);

        final continueReading = await pdfRepo.watchContinueReading().first;
        expect(continueReading.length, equals(2));

        // Most recently read should be first (pdf-cr-3 read at t3 after pdf-cr-1 at t1)
        expect(continueReading[0].id, equals('pdf-cr-3'));
        expect(continueReading[0].currentPage, equals(120));
        expect(continueReading[1].id, equals('pdf-cr-1'));
        expect(continueReading[1].currentPage, equals(45));

        // Unopened ddd.pdf must NOT be in continue reading
        expect(continueReading.any((p) => p.id == 'pdf-cr-2'), isFalse);
      },
    );

    test('watchContinueReading respects limit parameter', () async {
      for (int i = 1; i <= 10; i++) {
        final id = 'pdf-limit-$i';
        await pdfRepo.savePdf(
          PdfItem(
            id: id,
            title: 'Book $i',
            fileName: 'book_$i.pdf',
            currentPage: i,
            pageCount: 100,
            createdAt: DateTime(2026, 1, i),
            updatedAt: DateTime(2026, 1, i),
          ),
        );
        await pdfRepo.updateReadingProgress(
          id,
          i,
          readAt: DateTime(2026, 1, i),
        );
      }

      final top3 = await pdfRepo.watchContinueReading(limit: 3).first;
      expect(top3.length, equals(3));
      expect(top3[0].id, equals('pdf-limit-10'));
      expect(top3[1].id, equals('pdf-limit-9'));
      expect(top3[2].id, equals('pdf-limit-8'));
    });

    test(
      'watchRecentlyAdded returns items ordered by createdAt DESC',
      () async {
        final t1 = DateTime(2026, 1, 1);
        final t2 = DateTime(2026, 1, 5);
        final t3 = DateTime(2026, 1, 10);

        await pdfRepo.savePdf(
          PdfItem(
            id: 'rec-1',
            title: 'Old Book',
            fileName: 'old.pdf',
            createdAt: t1,
            updatedAt: t1,
          ),
        );
        await pdfRepo.savePdf(
          PdfItem(
            id: 'rec-2',
            title: 'Newest Book',
            fileName: 'newest.pdf',
            createdAt: t3,
            updatedAt: t3,
          ),
        );
        await pdfRepo.savePdf(
          PdfItem(
            id: 'rec-3',
            title: 'Middle Book',
            fileName: 'middle.pdf',
            createdAt: t2,
            updatedAt: t2,
          ),
        );

        final recents = await pdfRepo.watchRecentlyAdded(limit: 2).first;
        expect(recents.length, equals(2));
        expect(recents[0].id, equals('rec-2'));
        expect(recents[1].id, equals('rec-3'));
      },
    );
  });
}
