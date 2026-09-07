/// Configuration for a connected GitHub repository.
/// Tokens are never stored in this model or in database; they reside exclusively in FlutterSecureStorage.
class GitHubRepoConfig {
  final String id;
  final String owner;
  final String repo;
  final String branch;
  final String? customName;
  final DateTime connectedAt;
  final DateTime? lastSyncedAt;

  const GitHubRepoConfig({
    required this.id,
    required this.owner,
    required this.repo,
    this.branch = 'main',
    this.customName,
    required this.connectedAt,
    this.lastSyncedAt,
  });

  String get displayName => customName ?? '$owner/$repo';
  String get repositoryUrl => 'https://github.com/$owner/$repo';

  GitHubRepoConfig copyWith({
    String? id,
    String? owner,
    String? repo,
    String? branch,
    String? customName,
    DateTime? connectedAt,
    DateTime? lastSyncedAt,
  }) {
    return GitHubRepoConfig(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      repo: repo ?? this.repo,
      branch: branch ?? this.branch,
      customName: customName ?? this.customName,
      connectedAt: connectedAt ?? this.connectedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }
}
