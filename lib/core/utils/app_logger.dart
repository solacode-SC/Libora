import 'dart:developer' as developer;

/// Development logging utility that masks tokens and sensitive patterns.
class AppLogger {
  AppLogger._();

  static const String _name = 'Libora';

  // Patterns to redact: GitHub PATs (ghp_..., gho_..., github_pat_...) and Bearer tokens
  static final RegExp _tokenRegex = RegExp(
    r'(ghp_[a-zA-Z0-9]{36,255}|gho_[a-zA-Z0-9]{36,255}|github_pat_[a-zA-Z0-9_]{36,255}|Bearer\s+[a-zA-Z0-9\-_.]+)',
    caseSensitive: false,
  );

  static final RegExp _urlSecretRegex = RegExp(
    r'(https?://[^:@\s]+:[^:@\s]+@)',
    caseSensitive: false,
  );

  /// Redacts sensitive strings from message
  static String sanitize(String message) {
    var sanitized = message.replaceAllMapped(
      _tokenRegex,
      (match) => '[REDACTED_TOKEN]',
    );
    sanitized = sanitized.replaceAllMapped(
      _urlSecretRegex,
      (match) => 'https://[REDACTED_CREDENTIALS]@',
    );
    return sanitized;
  }

  static void debug(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      sanitize(message),
      name: tag != null ? '$_name:$tag' : _name,
      level: 500, // FINE
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void info(String message, {String? tag}) {
    developer.log(
      sanitize(message),
      name: tag != null ? '$_name:$tag' : _name,
      level: 800, // INFO
    );
  }

  static void warning(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      sanitize(message),
      name: tag != null ? '$_name:$tag' : _name,
      level: 900, // WARNING
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      sanitize(message),
      name: tag != null ? '$_name:$tag' : _name,
      level: 1000, // SEVERE
      error: error,
      stackTrace: stackTrace,
    );
  }
}
