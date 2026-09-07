import 'dart:io';

/// Abstract service contract for local app directory and file path management.
abstract class StorageService {
  /// Base documents directory for Libora app data.
  Future<Directory> getAppDocumentsDirectory();

  /// Directory dedicated for local PDF storage.
  Future<Directory> getPdfsDirectory();

  /// Directory dedicated for cached covers and thumbnails.
  Future<Directory> getCoversDirectory();

  /// Securely retrieves a stored credential (e.g. GitHub PAT).
  Future<String?> getSecureToken(String key);

  /// Securely stores a credential.
  Future<void> saveSecureToken(String key, String value);

  /// Securely deletes a stored credential.
  Future<void> deleteSecureToken(String key);
}
