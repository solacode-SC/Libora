import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;

import '../../services/local_storage_service.dart';
import '../pdf_storage_service.dart';

PdfStorageService createPdfStorage({dynamic localStorage}) =>
    DesktopPdfStorage(
      storageService: localStorage is LocalStorageService ? localStorage : null,
    );

/// Concrete desktop implementation of [PdfStorageService] using local files.
class DesktopPdfStorage implements PdfStorageService {
  final LocalStorageService _storageService;
  Directory? _cachedPdfsDir;
  Directory? _cachedCoversDir;

  DesktopPdfStorage({LocalStorageService? storageService})
      : _storageService = storageService ?? LocalStorageService();

  Future<File> _getPdfFile(String id) async {
    _cachedPdfsDir ??= await _storageService.getPdfsDirectory();
    return File(p.join(_cachedPdfsDir!.path, '$id.pdf'));
  }

  Future<File> _getCoverFile(String id) async {
    _cachedCoversDir ??= await _storageService.getCoversDirectory();
    return File(p.join(_cachedCoversDir!.path, '$id.jpg'));
  }

  @override
  Future<void> savePdf({
    required String id,
    required Uint8List bytes,
    required String fileName,
  }) async {
    final file = await _getPdfFile(id);
    await file.writeAsBytes(bytes);
  }

  @override
  Future<Uint8List?> readPdf(String id) async {
    final file = await _getPdfFile(id);
    if (!await file.exists()) return null;
    return await file.readAsBytes();
  }

  @override
  Future<bool> exists(String id) async {
    final file = await _getPdfFile(id);
    return await file.exists();
  }

  @override
  Future<void> deletePdf(String id) async {
    final file = await _getPdfFile(id);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<void> movePdf({
    required String id,
    required String newPath,
  }) async {
    // Physical files stay identified by $id.pdf
  }

  @override
  Future<int?> getFileSize(String id) async {
    final file = await _getPdfFile(id);
    if (!await file.exists()) return null;
    return await file.length();
  }

  @override
  Future<String?> getFilePath(String id) async {
    final file = await _getPdfFile(id);
    return file.path;
  }

  @override
  String? getFilePathOrNull(String id) {
    if (_cachedPdfsDir != null) {
      return p.join(_cachedPdfsDir!.path, '$id.pdf');
    }
    return null;
  }

  @override
  Future<void> saveCover({
    required String id,
    required Uint8List bytes,
  }) async {
    final file = await _getCoverFile(id);
    await file.writeAsBytes(bytes);
  }

  @override
  Future<Uint8List?> readCover(String id) async {
    final file = await _getCoverFile(id);
    if (!await file.exists()) return null;
    return await file.readAsBytes();
  }

  @override
  Future<void> deleteCover(String id) async {
    final file = await _getCoverFile(id);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<String?> getCoverPath(String id) async {
    final file = await _getCoverFile(id);
    return file.path;
  }

  @override
  String? getCoverPathOrNull(String id) {
    if (_cachedCoversDir != null) {
      return p.join(_cachedCoversDir!.path, '$id.jpg');
    }
    return null;
  }
}
