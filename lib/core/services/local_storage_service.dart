import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'storage_service.dart';

/// Concrete implementation of [StorageService] managing Libora's local filesystem structure.
class LocalStorageService implements StorageService {
  final FlutterSecureStorage _secureStorage;
  Directory? _baseDir;

  LocalStorageService({
    FlutterSecureStorage? secureStorage,
    Directory? baseDirectory,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
       _baseDir = baseDirectory;

  @override
  Future<Directory> getAppDocumentsDirectory() async {
    if (_baseDir != null) return _baseDir!;
    final docs = await getApplicationDocumentsDirectory();
    final appDir = Directory(p.join(docs.path, 'libora'));
    if (!await appDir.exists()) {
      await appDir.create(recursive: true);
    }
    _baseDir = appDir;
    return appDir;
  }

  @override
  Future<Directory> getPdfsDirectory() async {
    final base = await getAppDocumentsDirectory();
    final pdfsDir = Directory(p.join(base.path, 'library', 'pdfs'));
    if (!await pdfsDir.exists()) {
      await pdfsDir.create(recursive: true);
    }
    return pdfsDir;
  }

  @override
  Future<Directory> getCoversDirectory() async {
    final base = await getAppDocumentsDirectory();
    final coversDir = Directory(p.join(base.path, 'library', 'covers'));
    if (!await coversDir.exists()) {
      await coversDir.create(recursive: true);
    }
    return coversDir;
  }

  /// Copies a user-picked PDF into Libora's managed storage directory.
  Future<File> copyToManagedStorage(File sourceFile, String targetId) async {
    final pdfsDir = await getPdfsDirectory();
    final targetPath = p.join(pdfsDir.path, '$targetId.pdf');
    return await sourceFile.copy(targetPath);
  }

  /// Safely deletes a file from the managed storage if it exists.
  Future<void> deleteManagedFile(String? path) async {
    if (path == null || path.isEmpty) return;
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Gracefully ignore deletion failures
    }
  }

  /// Synchronously checks if a file exists on the local filesystem.
  bool fileExists(String? path) {
    if (path == null || path.isEmpty) return false;
    return File(path).existsSync();
  }

  @override
  Future<String?> getSecureToken(String key) => _secureStorage.read(key: key);

  @override
  Future<void> saveSecureToken(String key, String value) =>
      _secureStorage.write(key: key, value: value);

  @override
  Future<void> deleteSecureToken(String key) => _secureStorage.delete(key: key);
}

final storageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});
