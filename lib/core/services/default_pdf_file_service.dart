import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart';

import '../utils/app_logger.dart';
import 'pdf_file_service.dart';

/// Concrete implementation of [PdfFileService] handling file picking, validation, and metadata extraction.
class DefaultPdfFileService implements PdfFileService {
  @override
  Future<List<File>> pickPdfFiles() async {
    final files = <File>[];
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'PDF'],
      );

      for (final picked in result) {
        final filePath =
            picked.path ??
            (picked.uri.scheme == 'file' ? picked.uri.toFilePath() : null);
        if (filePath != null && filePath.isNotEmpty) {
          final file = File(filePath);
          if (await file.exists() && file.path.toLowerCase().endsWith('.pdf')) {
            files.add(file);
          }
        }
      }
    } catch (e, stack) {
      AppLogger.warning(
        'FilePicker.platform.pickFiles failed: $e. Trying Linux desktop fallback...',
        error: e,
        stackTrace: stack,
      );
      if (Platform.isLinux) {
        final fallbackFiles = await _pickFilesLinuxFallback();
        files.addAll(fallbackFiles);
      }
    }
    return files;
  }

  Future<List<File>> _pickFilesLinuxFallback() async {
    try {
      const zenityPath = '/usr/bin/zenity';
      if (File(zenityPath).existsSync()) {
        final res = await Process.run(zenityPath, [
          '--file-selection',
          '--multiple',
          '--separator=|',
          '--file-filter=PDF Documents (*.pdf) | *.pdf *.PDF',
          '--title=Import PDF Documents',
        ]);
        if (res.exitCode == 0) {
          final raw = res.stdout.toString().trim();
          if (raw.isNotEmpty) {
            final paths = raw.split('|');
            final list = <File>[];
            for (final path in paths) {
              final trimmed = path.trim();
              if (trimmed.isNotEmpty) {
                final file = File(trimmed);
                if (await file.exists() &&
                    file.path.toLowerCase().endsWith('.pdf')) {
                  list.add(file);
                }
              }
            }
            return list;
          }
        }
      }
    } catch (e, stack) {
      AppLogger.error(
        'Linux file picker fallback failed: $e',
        error: e,
        stackTrace: stack,
      );
    }
    return [];
  }

  @override
  Future<bool> validatePdf(File file) async {
    RandomAccessFile? raf;
    try {
      if (!await file.exists()) return false;
      final length = await file.length();
      if (length < 5) return false;

      raf = await file.open(mode: FileMode.read);
      final bytesToRead = length < 1024 ? length : 1024;
      final header = await raf.read(bytesToRead);

      // Search for '%PDF-' (0x25, 0x50, 0x44, 0x46, 0x2D) in the first 1024 bytes per PDF standard
      const magic = [0x25, 0x50, 0x44, 0x46, 0x2D];
      for (int i = 0; i <= header.length - magic.length; i++) {
        var match = true;
        for (int j = 0; j < magic.length; j++) {
          if (header[i + j] != magic[j]) {
            match = false;
            break;
          }
        }
        if (match) return true;
      }
      AppLogger.warning(
        'File is not a valid PDF (%PDF- header missing): ${file.path}',
      );
      return false;
    } catch (e, stack) {
      AppLogger.warning(
        'PDF validation failed for ${file.path}: $e',
        error: e,
        stackTrace: stack,
      );
      return false;
    } finally {
      await raf?.close();
    }
  }

  @override
  Future<PdfMetadata> extractMetadata(
    File file, {
    String? originalFileName,
  }) async {
    final fileName = originalFileName ?? p.basename(file.path);
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
