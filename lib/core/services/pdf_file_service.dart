import 'dart:io';
import 'dart:typed_data';

/// Represents a picked PDF document, holding its name, raw bytes, and optional disk path.
class PickedPdfDocument {
  final String name;
  final Uint8List bytes;
  final String? path;

  const PickedPdfDocument({
    required this.name,
    required this.bytes,
    this.path,
  });
}

/// Abstract service contract for PDF file operations (importing, validating, reading info).
abstract class PdfFileService {
  /// Prompts user to pick one or more PDF files. Works across Web and Desktop.
  Future<List<PickedPdfDocument>> pickPdfs();

  /// Prompts user to pick one or more PDF files from the local filesystem.
  Future<List<File>> pickPdfFiles();

  /// Validates whether a file is a non-corrupted readable PDF.
  Future<bool> validatePdf(File file);

  /// Synchronously checks if raw bytes contain a valid %PDF- header.
  bool validateBytes(Uint8List bytes);

  /// Extracts basic metadata (page count, title, file size) from a PDF file.
  Future<PdfMetadata> extractMetadata(File file, {String? originalFileName});

  /// Extracts basic metadata from raw PDF bytes.
  Future<PdfMetadata> extractMetadataFromBytes(
    Uint8List bytes, {
    String? originalFileName,
  });

  /// Computes a SHA-256 hash of the PDF file contents for duplicate detection.
  Future<String> computeFileHash(File file);

  /// Computes a SHA-256 hash of raw bytes.
  String computeBytesHash(Uint8List bytes);
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
