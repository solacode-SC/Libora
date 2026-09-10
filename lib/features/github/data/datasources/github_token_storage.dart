import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/utils/app_logger.dart';

abstract class IGitHubTokenStorage {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<bool> hasToken();
}

class GitHubTokenStorage implements IGitHubTokenStorage {
  static const String _keyPatToken = 'github_pat_token';

  final FlutterSecureStorage _storage;

  GitHubTokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _keyPatToken, value: token.trim());
      AppLogger.info('GitHub token securely saved', tag: 'GitHubTokenStorage');
    } catch (e, stack) {
      AppLogger.error('Failed to save GitHub token securely: $e', error: e, stackTrace: stack, tag: 'GitHubTokenStorage');
      rethrow;
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      final token = await _storage.read(key: _keyPatToken);
      return token?.trim();
    } catch (e, stack) {
      AppLogger.error('Failed to read GitHub token: $e', error: e, stackTrace: stack, tag: 'GitHubTokenStorage');
      return null;
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _keyPatToken);
      AppLogger.info('GitHub token deleted', tag: 'GitHubTokenStorage');
    } catch (e, stack) {
      AppLogger.error('Failed to delete GitHub token: $e', error: e, stackTrace: stack, tag: 'GitHubTokenStorage');
      rethrow;
    }
  }

  @override
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

