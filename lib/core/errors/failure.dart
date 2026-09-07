import 'app_exception.dart';

/// Presentation-friendly representation of an error or failure.
class Failure {
  final String title;
  final String message;
  final String? code;
  final Object? originalError;

  const Failure({
    required this.title,
    required this.message,
    this.code,
    this.originalError,
  });

  factory Failure.fromException(AppException exception) {
    return switch (exception) {
      FileNotFoundException() => Failure(
        title: 'File Not Found',
        message: 'The requested PDF could not be found on your device.',
        code: 'FILE_NOT_FOUND',
        originalError: exception,
      ),
      InvalidPdfException(:final message) => Failure(
        title: 'Invalid PDF',
        message: message.isNotEmpty
            ? message
            : 'The selected document is not a valid or readable PDF.',
        code: 'INVALID_PDF',
        originalError: exception,
      ),
      DatabaseException(:final message) => Failure(
        title: 'Storage Error',
        message: 'Failed to access local database: $message',
        code: 'DB_ERROR',
        originalError: exception,
      ),
      NetworkException(:final message) => Failure(
        title: 'Network Error',
        message: 'Please check your internet connection: $message',
        code: 'NETWORK_ERROR',
        originalError: exception,
      ),
      GitHubAuthenticationException(:final message) => Failure(
        title: 'GitHub Auth Failed',
        message:
            'Authentication failed. Please verify your Personal Access Token: $message',
        code: 'GITHUB_AUTH_FAILED',
        originalError: exception,
      ),
      GitHubRateLimitException(:final resetAt) => Failure(
        title: 'Rate Limit Reached',
        message: resetAt != null
            ? 'GitHub API rate limit reached. Resets at ${resetAt.toLocal()}.'
            : 'GitHub API rate limit exceeded. Please try again later.',
        code: 'GITHUB_RATE_LIMIT',
        originalError: exception,
      ),
      DownloadFailedException(:final message) => Failure(
        title: 'Download Failed',
        message: 'Could not download the file: $message',
        code: 'DOWNLOAD_FAILED',
        originalError: exception,
      ),
      StorageUnavailableException(:final message) => Failure(
        title: 'Storage Unavailable',
        message: 'Device storage is not accessible: $message',
        code: 'STORAGE_UNAVAILABLE',
        originalError: exception,
      ),
    };
  }

  @override
  String toString() => 'Failure(title: $title, message: $message, code: $code)';
}
