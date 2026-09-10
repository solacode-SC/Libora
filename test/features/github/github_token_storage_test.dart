import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libora/features/github/data/datasources/github_token_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GitHubTokenStorage Tests', () {
    late GitHubTokenStorage storage;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      storage = GitHubTokenStorage();
    });

    test('initial state has no token', () async {
      expect(await storage.hasToken(), isFalse);
      expect(await storage.getToken(), isNull);
    });

    test('saves, retrieves, and trims token securely', () async {
      await storage.saveToken('  ghp_secretToken1234567890abcdef  ');

      expect(await storage.hasToken(), isTrue);
      expect(await storage.getToken(), equals('ghp_secretToken1234567890abcdef'));
    });

    test('deletes token cleanly', () async {
      await storage.saveToken('ghp_testToken');
      expect(await storage.hasToken(), isTrue);

      await storage.deleteToken();
      expect(await storage.hasToken(), isFalse);
      expect(await storage.getToken(), isNull);
    });
  });
}

