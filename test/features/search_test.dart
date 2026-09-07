import 'package:flutter_test/flutter_test.dart';
import 'package:libora/database/app_database.dart';
import 'package:libora/features/library/data/repositories/pdf_repository.dart';
import 'package:libora/features/library/domain/models/pdf_item.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late PdfRepository pdfRepo;

  setUp(() async {
    db = createTestDatabase();
    pdfRepo = DriftPdfRepository(db.pdfsDao);

    final now = DateTime.now();
    await pdfRepo.savePdf(
      PdfItem(
        id: 's-1',
        title: 'Design Patterns Elements of Reusable Object-Oriented Software',
        fileName: 'gof_design_patterns.pdf',
        folderId: 'folder-patterns',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await pdfRepo.savePdf(
      PdfItem(
        id: 's-2',
        title: 'Patterns of Enterprise Application Architecture',
        fileName: 'poeaa_fowler.pdf',
        folderId: 'folder-patterns',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await pdfRepo.savePdf(
      PdfItem(
        id: 's-3',
        title: 'Structure and Interpretation of Computer Programs',
        fileName: 'sicp_mit.pdf',
        folderId: 'folder-classics',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await pdfRepo.savePdf(
      PdfItem(
        id: 's-4',
        title: 'Rust Programming Language',
        fileName: 'trpl_rust.pdf',
        folderId: null, // Root
        createdAt: now,
        updatedAt: now,
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('SQLite Search Query Tests', () {
    test('searches by title substring (case-insensitive)', () async {
      final results = await pdfRepo.searchPdfs('patterns');
      expect(results.length, equals(2));
      expect(results.map((p) => p.id), containsAll(['s-1', 's-2']));

      final upperResults = await pdfRepo.searchPdfs('ENTERPRISE');
      expect(upperResults.length, equals(1));
      expect(upperResults.first.id, equals('s-2'));
    });

    test('searches by fileName substring', () async {
      final results = await pdfRepo.searchPdfs('sicp');
      expect(results.length, equals(1));
      expect(results.first.id, equals('s-3'));
      expect(results.first.title, contains('Structure and Interpretation'));
    });

    test('filters search results by folderId', () async {
      // Both s-1 and s-2 match 'patterns', but in folder-patterns
      final inFolder = await pdfRepo.searchPdfs(
        'patterns',
        folderId: 'folder-patterns',
      );
      expect(inFolder.length, equals(2));

      // In folder-classics, no patterns books
      final classics = await pdfRepo.searchPdfs(
        'patterns',
        folderId: 'folder-classics',
      );
      expect(classics, isEmpty);
    });

    test('returns empty list for non-matching queries', () async {
      final empty = await pdfRepo.searchPdfs('quantum computing astrophysics');
      expect(empty, isEmpty);
    });

    test('handles whitespace in query safely', () async {
      final result = await pdfRepo.searchPdfs('  rust  ');
      expect(result.length, equals(1));
      expect(result.first.id, equals('s-4'));
    });
  });
}
