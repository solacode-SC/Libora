/// Base sealed class for all application-level exceptions.
sealed class AppException implements Exception {
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  const AppException(this.message, {this.cause, this.stackTrace});

  @override
  String toString() =>
      '$runtimeType: $message${cause != null ? ' (Cause: $cause)' : ''}';
}

/// Thrown when a PDF or target file cannot be located on disk.
class FileNotFoundException extends AppException {
  final String path;
  const FileNotFoundException(this.path, {super.cause, super.stackTrace})
    : super('File not found at path: $path');
}

/// Thrown when a PDF is corrupted, password-protected, or unreadable.
class InvalidPdfException extends AppException {
  const InvalidPdfException(super.message, {super.cause, super.stackTrace});
}

/// Thrown when SQLite or Drift encounters an execution error.
class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.cause, super.stackTrace});
}

/// Thrown when network connectivity fails.
class NetworkException extends AppException {
  final int? statusCode;
  const NetworkException(
    super.message, {
    this.statusCode,
    super.cause,
    super.stackTrace,
  });
}

/// Thrown when GitHub authentication fails (e.g. invalid token).
class GitHubAuthenticationException extends AppException {
  const GitHubAuthenticationException(
    super.message, {
    super.cause,
    super.stackTrace,
  });
}

/// Thrown when GitHub rate limit (60/hr unauthenticated or 5000/hr PAT) is exceeded.
class GitHubRateLimitException extends AppException {
  final DateTime? resetAt;
  const GitHubRateLimitException(
    super.message, {
    this.resetAt,
    super.cause,
    super.stackTrace,
  });
}

/// Thrown when a remote file download fails or is interrupted.
class DownloadFailedException extends AppException {
  const DownloadFailedException(super.message, {super.cause, super.stackTrace});
}

/// Thrown when the target storage volume or directory is inaccessible or out of space.
class StorageUnavailableException extends AppException {
  const StorageUnavailableException(
    super.message, {
    super.cause,
    super.stackTrace,
  });
}
