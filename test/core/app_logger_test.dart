import 'package:flutter_test/flutter_test.dart';
import 'package:libora/core/utils/app_logger.dart';

void main() {
  group('AppLogger Security Sanitization Tests', () {
    test('redacts classic GitHub personal access tokens', () {
      const input =
          'Connecting with token ghp_1234567890abcdefghijklmnopqrstuvwxyzAB';
      final sanitized = AppLogger.sanitize(input);
      expect(sanitized, contains('[REDACTED_TOKEN]'));
      expect(
        sanitized,
        isNot(contains('ghp_1234567890abcdefghijklmnopqrstuvwxyzAB')),
      );
    });

    test('redacts fine-grained GitHub personal access tokens', () {
      const input =
          'Auth token github_pat_11ABCD1234567890abcdefghijklmnopqrstuvwxyz';
      final sanitized = AppLogger.sanitize(input);
      expect(sanitized, contains('[REDACTED_TOKEN]'));
      expect(
        sanitized,
        isNot(
          contains('github_pat_11ABCD1234567890abcdefghijklmnopqrstuvwxyz'),
        ),
      );
    });

    test('redacts embedded basic auth credentials in repository URLs', () {
      const input =
          'Cloning from https://solacode:secret_pass123@github.com/repo.git';
      final sanitized = AppLogger.sanitize(input);
      expect(
        sanitized,
        contains('https://[REDACTED_CREDENTIALS]@github.com/repo.git'),
      );
      expect(sanitized, isNot(contains('secret_pass123')));
    });

    test('leaves normal log messages untouched', () {
      const input = 'Database initialized successfully with 3 tables.';
      final sanitized = AppLogger.sanitize(input);
      expect(sanitized, equals(input));
    });
  });
}
