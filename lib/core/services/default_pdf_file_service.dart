import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart';

import 'pdf_file_service.dart';

/// Concrete implementation of [PdfFileService] handling file picking, validation, and metadata extraction.
class DefaultPdfFileService implements PdfFileService {
  @override
  Future<List<File>> pickPdfFiles() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result.isEmpty) {
      return [];
    }

    final files = <File>[];
    for (final picked in result) {
      if (picked.path != null) {
        final file = File(picked.path!);
        if (await file.exists() && file.path.toLowerCase().endsWith('.pdf')) {
          files.add(file);
        }
      }
    }
    return files;
  }

  @override
  Future<bool> validatePdf(File file) async {
    try {
      if (!await file.exists()) return false;
      final length = await file.length();
      if (length < 5) return false;

      // Check PDF magic header '%PDF-'
      final raf = await file.open(mode: FileMode.read);
      final header = await raf.read(5);
      await raf.close();

      // Bytes for '%PDF-': 0x25, 0x50, 0x44, 0x46, 0x2D
      return header.length == 5 &&
          header[0] == 0x25 &&
          header[1] == 0x50 &&
          header[2] == 0x44 &&
          header[3] == 0x46 &&
          header[4] == 0x2D;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<PdfMetadata> extractMetadata(File file) async {
    final fileName = p.basename(file.path);
    final derivedTitle = cleanTitleFromFileName(fileName);
    final fileSize = await file.length();

    int pageCount = 0;
    try {
      final doc = await PdfDocument.openFile(file.path);
      pageCount = doc.pages.length;
      doc.dispose();
    } catch (_) {
      // Fallback to 0 if pdfrx cannot parse page count
      pageCount = 0;
    }

    return PdfMetadata(
      title: derivedTitle,
      pageCount: pageCount,
      fileSize: fileSize,
    );
  }

  /// Computes a SHA-256 hash of the PDF file contents for duplicate detection.
  Future<String> computeFileHash(File file) async {
    final digest = await sha256.bind(file.openRead()).first;
    return digest.toString();
  }

  /// Derives a clean human-readable title from a filename (e.g. `clean-code_2nd.pdf` -> `Clean Code 2nd`).
  static String cleanTitleFromFileName(String fileName) {
    var name = fileName;
    if (name.toLowerCase().endsWith('.pdf')) {
      name = name.substring(0, name.length - 4);
    }
    // Replace underscores, dashes with spaces
    name = name.replaceAll(RegExp(r'[-_]+'), ' ').trim();
    if (name.isEmpty) return 'Untitled';

    // Capitalize words
    return name
        .split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() +
              (word.length > 1 ? word.substring(1) : '');
        })
        .join(' ');
  }
}

final pdfFileServiceProvider = Provider<DefaultPdfFileService>((ref) {
  return DefaultPdfFileService();
});
