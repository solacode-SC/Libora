import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:libora/core/storage/memory/memory_pdf_storage.dart';

void main() {
  group('MemoryPdfStorage Tests', () {
    late MemoryPdfStorage storage;

    setUp(() {
      storage = MemoryPdfStorage();
    });

    test('savePdf, readPdf, exists, deletePdf work correctly', () async {
      const docId = 'doc-123';
      final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);

      expect(await storage.exists(docId), isFalse);
      expect(await storage.readPdf(docId), isNull);
      expect(await storage.getFileSize(docId), isNull);

      await storage.savePdf(id: docId, bytes: bytes, fileName: 'test.pdf');

      expect(await storage.exists(docId), isTrue);
      expect(await storage.readPdf(docId), equals(bytes));
      expect(await storage.getFileSize(docId), equals(5));

      await storage.deletePdf(docId);
      expect(await storage.exists(docId), isFalse);
      expect(await storage.readPdf(docId), isNull);
      expect(await storage.getFileSize(docId), isNull);
    });

    test('saveCover, readCover, deleteCover work correctly', () async {
      const docId = 'doc-123';
      final coverBytes = Uint8List.fromList([10, 20, 30]);

      expect(await storage.readCover(docId), isNull);

      await storage.saveCover(id: docId, bytes: coverBytes);

      expect(await storage.readCover(docId), equals(coverBytes));

      await storage.deleteCover(docId);
      expect(await storage.readCover(docId), isNull);
    });

    test('getFilePath returns null on memory/web storage', () async {
      const docId = 'doc-123';
      expect(await storage.getFilePath(docId), isNull);
      expect(storage.getFilePathOrNull(docId), isNull);
      expect(await storage.getCoverPath(docId), isNull);
      expect(storage.getCoverPathOrNull(docId), isNull);
    });
  });
}
