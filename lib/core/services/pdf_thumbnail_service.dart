import 'dart:io';
import 'dart:typed_data';

/// Abstract service contract for generating cover and thumbnail images from PDFs.
abstract class PdfThumbnailService {
  /// Renders page [pageIndex] of the PDF bytes to a JPEG image and returns the bytes.
  Future<Uint8List?> generateCoverBytes({
    required Uint8List pdfBytes,
    int pageIndex = 0,
    int targetWidth = 400,
  });

  /// Renders page 1 of the PDF file to a JPEG/PNG image cache and returns the cover File.
  Future<File?> generateCoverImage({
    required File pdfFile,
    required String destinationPath,
    int pageIndex = 0,
    int targetWidth = 400,
  });
}
