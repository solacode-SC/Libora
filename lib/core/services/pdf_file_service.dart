import 'dart:io';

/// Abstract service contract for PDF file operations (importing, validating, reading info).
abstract class PdfFileService {
  /// Prompts user to pick one or more PDF files from the local filesystem.
  Future<List<File>> pickPdfFiles();

  /// Validates whether a file is a non-corrupted readable PDF.
  Future<bool> validatePdf(File file);

  /// Extracts basic metadata (page count, title, file size) from a PDF file.
  Future<PdfMetadata> extractMetadata(File file);
}

class PdfMetadata {
  final String title;
  final int pageCount;
  final int fileSize;

  const PdfMetadata({
    required this.title,
    required this.pageCount,
    required this.fileSize,
  });
}
