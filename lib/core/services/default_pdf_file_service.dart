import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart';

import '../utils/app_logger.dart';
import 'pdf_file_service.dart';

/// Concrete implementation of [PdfFileService] handling file picking, validation, and metadata extraction.
class DefaultPdfFileService implements PdfFileService {
  @override
  Future<List<PickedPdfDocument>> pickPdfs() async {
    // Check if subclass or mock overrode legacy pickPdfFiles
    final legacyFiles = await pickPdfFiles();
    if (legacyFiles.isNotEmpty) {
      final list = <PickedPdfDocument>[];
      for (final f in legacyFiles) {
        final bytes = await f.readAsBytes();
        list.add(
          PickedPdfDocument(
            name: p.basename(f.path),
            bytes: bytes,
            path: f.path,
          ),
        );
      }
      return list;
    }

    final docs = <PickedPdfDocument>[];
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'PDF'],
      );

      for (final picked in result) {
        final bytes = await picked.readAsBytes();
        if (bytes.isNotEmpty) {
          docs.add(
            PickedPdfDocument(
              name: picked.name,
              bytes: bytes,
              path: picked.path,
            ),
          );
        }
      }
    } catch (e, stack) {
      AppLogger.warning(
        'FilePicker.pickFiles failed: $e. Checking desktop fallback...',
        error: e,
        stackTrace: stack,
      );
      if (!kIsWeb && Platform.isLinux) {
        final fallbackFiles = await _pickFilesLinuxFallback();
        for (final file in fallbackFiles) {
          final bytes = await file.readAsBytes();
          docs.add(
            PickedPdfDocument(
              name: p.basename(file.path),
              bytes: bytes,
              path: file.path,
            ),
          );
        }
      }
    }
    return docs;
  }

  @override
  Future<List<File>> pickPdfFiles() async {
    // Default implementation returns empty; overridden by test mocks or legacy callers
    return [];
  }

  Future<List<File>> _pickFilesLinuxFallback() async {
    if (kIsWeb) return [];
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
  bool validateBytes(Uint8List bytes) {
    if (bytes.length < 5) return false;
    // Search for '%PDF-' (0x25, 0x50, 0x44, 0x46, 0x2D) in the first 1024 bytes per PDF standard
    const magic = [0x25, 0x50, 0x44, 0x46, 0x2D];
    final limit = bytes.length < 1024 ? bytes.length : 1024;
    for (int i = 0; i <= limit - magic.length; i++) {
      var match = true;
      for (int j = 0; j < magic.length; j++) {
        if (bytes[i + j] != magic[j]) {
          match = false;
          break;
        }
      }
      if (match) return true;
    }
    return false;
  }

  @override
  Future<bool> validatePdf(File file) async {
    try {
      if (!await file.exists()) return false;
      final length = await file.length();
      if (length < 5) return false;

      final raf = await file.open(mode: FileMode.read);
      try {
        final bytesToRead = length < 1024 ? length : 1024;
        final header = await raf.read(bytesToRead);
        final valid = validateBytes(header);
        if (!valid) {
          AppLogger.warning(
            'File is not a valid PDF (%PDF- header missing): ${file.path}',
          );
        }
        return valid;
      } finally {
        await raf.close();
      }
    } catch (e, stack) {
      AppLogger.warning(
        'PDF validation failed: $e',
        error: e,
        stackTrace: stack,
      );
      return false;
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
      pageCount = 0;
    }

    return PdfMetadata(
      title: derivedTitle,
      pageCount: pageCount,
      fileSize: fileSize,
    );
  }

  @override
  Future<PdfMetadata> extractMetadataFromBytes(
    Uint8List bytes, {
    String? originalFileName,
  }) async {
    final derivedTitle = cleanTitleFromFileName(originalFileName ?? 'Untitled');
    final fileSize = bytes.length;

    int pageCount = 0;
    if (bytes.isNotEmpty) {
      try {
        final doc = await PdfDocument.openData(bytes);
        pageCount = doc.pages.length;
        doc.dispose();
      } catch (_) {
        pageCount = 0;
      }
    }

    return PdfMetadata(
      title: derivedTitle,
      pageCount: pageCount,
      fileSize: fileSize,
    );
  }

  @override
  Future<String> computeFileHash(File file) async {
    final digest = await sha256.bind(file.openRead()).first;
    return digest.toString();
  }

  @override
  String computeBytesHash(Uint8List bytes) {
    return sha256.convert(bytes).toString();
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
