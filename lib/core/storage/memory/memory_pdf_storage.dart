import 'dart:typed_data';

import '../pdf_storage_service.dart';

/// In-memory implementation of [PdfStorageService] for fast unit and widget testing.
class MemoryPdfStorage implements PdfStorageService {
  final Map<String, Uint8List> _pdfs = {};
  final Map<String, Uint8List> _covers = {};
  final Map<String, String> _fileNames = {};

  @override
  Future<void> savePdf({
    required String id,
    required Uint8List bytes,
    required String fileName,
  }) async {
    _pdfs[id] = bytes;
    _fileNames[id] = fileName;
  }

  @override
  Future<Uint8List?> readPdf(String id) async => _pdfs[id];

  @override
  Future<bool> exists(String id) async => _pdfs.containsKey(id);

  @override
  Future<void> deletePdf(String id) async {
    _pdfs.remove(id);
    _fileNames.remove(id);
  }

  @override
  Future<void> movePdf({
    required String id,
    required String newPath,
  }) async {
    // In-memory mapping is keyed by ID
  }

  @override
  Future<int?> getFileSize(String id) async => _pdfs[id]?.length;

  @override
  Future<String?> getFilePath(String id) async => null;

  @override
  String? getFilePathOrNull(String id) => null;

  @override
  Future<void> saveCover({
    required String id,
    required Uint8List bytes,
  }) async {
    _covers[id] = bytes;
  }

  @override
  Future<Uint8List?> readCover(String id) async => _covers[id];

  @override
  Future<void> deleteCover(String id) async {
    _covers.remove(id);
  }

  @override
  Future<String?> getCoverPath(String id) async => null;

  @override
  String? getCoverPathOrNull(String id) => null;

  /// Helper to clear all in-memory data during test teardown.
  void clear() {
    _pdfs.clear();
    _covers.clear();
    _fileNames.clear();
  }
}
