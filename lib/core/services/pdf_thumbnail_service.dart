import 'dart:io';

/// Abstract service contract for generating cover and thumbnail images from PDFs.
abstract class PdfThumbnailService {
  /// Renders page 1 of the PDF file to a JPEG/PNG image cache and returns the cover File.
  Future<File?> generateCoverImage({
    required File pdfFile,
    required String destinationPath,
    int pageIndex = 0,
    int targetWidth = 400,
  });
}
