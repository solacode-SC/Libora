import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:pdfrx/pdfrx.dart';

import 'pdf_thumbnail_service.dart';

/// Concrete implementation of [PdfThumbnailService] rendering page 0 to a cached JPEG image.
class DefaultPdfThumbnailService implements PdfThumbnailService {
  @override
  Future<Uint8List?> generateCoverBytes({
    required Uint8List pdfBytes,
    int pageIndex = 0,
    int targetWidth = 400,
  }) async {
    try {
      if (pdfBytes.isEmpty) return null;
      final doc = await PdfDocument.openData(pdfBytes);
      if (doc.pages.isEmpty || pageIndex >= doc.pages.length) {
        doc.dispose();
        return null;
      }

      final page = doc.pages[pageIndex];
      final scale = targetWidth / page.width;
      final pageImage = await page.render(
        fullWidth: page.width * scale,
        fullHeight: page.height * scale,
      );

      if (pageImage == null) {
        doc.dispose();
        return null;
      }

      final image = img.Image.fromBytes(
        width: pageImage.width,
        height: pageImage.height,
        bytes: pageImage.pixels.buffer,
        order: img.ChannelOrder.bgra,
        numChannels: 4,
      );
      pageImage.dispose();
      doc.dispose();

      return img.encodeJpg(image, quality: 85);
    } catch (_) {
      // Graceful fallback if rendering fails or pdfium is not available
      return null;
    }
  }

  @override
  Future<File?> generateCoverImage({
    required File pdfFile,
    required String destinationPath,
    int pageIndex = 0,
    int targetWidth = 400,
  }) async {
    try {
      if (kIsWeb) return null;
      if (!await pdfFile.exists()) return null;
      final bytes = await pdfFile.readAsBytes();
      final jpgBytes = await generateCoverBytes(
        pdfBytes: bytes,
        pageIndex: pageIndex,
        targetWidth: targetWidth,
      );
      if (jpgBytes == null) return null;

      final coverFile = File(destinationPath);
      await coverFile.writeAsBytes(jpgBytes);
      return coverFile;
    } catch (_) {
      // Graceful fallback if rendering fails or pdfium is not available
      return null;
    }
  }
}

final pdfThumbnailServiceProvider = Provider<DefaultPdfThumbnailService>((ref) {
  return DefaultPdfThumbnailService();
});
