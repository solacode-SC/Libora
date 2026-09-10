sealed class GitHubException implements Exception {
  final String message;
  final int? statusCode;

  const GitHubException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class GitHubAuthException extends GitHubException {
  const GitHubAuthException([String message = 'Invalid or expired GitHub Personal Access Token. Please verify your token and permissions.'])
      : super(message, 401);
}

class GitHubPermissionException extends GitHubException {
  const GitHubPermissionException([String message = 'Personal Access Token does not have permission to write to this repository. Ensure your token has "Contents: Read and write" (or "repo" scope).'])
      : super(message, 403);
}

class GitHubRateLimitException extends GitHubException {
  final DateTime? resetTime;
  const GitHubRateLimitException({
    String message = 'GitHub API rate limit exceeded. Please try again later.',
    this.resetTime,
  }) : super(message, 403);
}

class GitHubNotFoundException extends GitHubException {
  const GitHubNotFoundException([String message = 'Resource not found on GitHub.'])
      : super(message, 404);
}

class GitHubConflictException extends GitHubException {
  const GitHubConflictException([String message = 'Conflict occurred on GitHub repository (SHA mismatch or concurrent edit).'])
      : super(message, 409);
}

class GitHubFileSizeLimitException extends GitHubException {
  final int fileSize;
  final int limitBytes;

  const GitHubFileSizeLimitException({
    required this.fileSize,
    this.limitBytes = 100 * 1024 * 1024,
    String message = 'File exceeds GitHub Contents API 100MB limit.',
  }) : super(message, 422);
}

class GitHubNetworkException extends GitHubException {
  const GitHubNetworkException([super.message = 'Network error or connection failed. Local changes saved.']);
}

class GitHubUnknownException extends GitHubException {
  final dynamic originalError;
  const GitHubUnknownException(String message, [this.originalError, int? statusCode])
      : super(message, statusCode);
}
