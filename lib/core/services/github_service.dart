/// Abstract service contract for GitHub REST API integration.
abstract class GitHubService {
  /// Validates a GitHub Personal Access Token and returns owner username.
  Future<String> validateToken(String token);

  /// Lists the repository tree (files, folders, commit sha) for a given owner/repo.
  Future<List<GitHubRepoFile>> fetchRepositoryTree({
    required String owner,
    required String repo,
    String branch = 'main',
    String? token,
  });

  /// Downloads or reads file content (e.g. library.json or raw PDF) from GitHub.
  Future<List<int>> fetchRawFile({
    required String owner,
    required String repo,
    required String filePath,
    String? token,
  });
}

class GitHubRepoFile {
  final String path;
  final String sha;
  final int? size;
  final String type; // 'blob' or 'tree'

  const GitHubRepoFile({
    required this.path,
    required this.sha,
    this.size,
    required this.type,
  });
}
