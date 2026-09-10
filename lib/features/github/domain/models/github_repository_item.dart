class GitHubRepositoryItem {
  final String id;
  final String? githubRepoId;
  final String owner;
  final String name;
  final String fullName;
  final String defaultBranch;
  final bool isPrivate;
  final bool isSelected;
  final DateTime? lastSyncedAt;
  final String? remoteHeadSha;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GitHubRepositoryItem({
    required this.id,
    this.githubRepoId,
    required this.owner,
    required this.name,
    required this.fullName,
    this.defaultBranch = 'main',
    this.isPrivate = false,
    this.isSelected = false,
    this.lastSyncedAt,
    this.remoteHeadSha,
    required this.createdAt,
    required this.updatedAt,
  });

  String get repositoryUrl => 'https://github.com/$fullName';

  GitHubRepositoryItem copyWith({
    String? id,
    String? githubRepoId,
    String? owner,
    String? name,
    String? fullName,
    String? defaultBranch,
    bool? isPrivate,
    bool? isSelected,
    DateTime? lastSyncedAt,
    String? remoteHeadSha,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GitHubRepositoryItem(
      id: id ?? this.id,
      githubRepoId: githubRepoId ?? this.githubRepoId,
      owner: owner ?? this.owner,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      defaultBranch: defaultBranch ?? this.defaultBranch,
      isPrivate: isPrivate ?? this.isPrivate,
      isSelected: isSelected ?? this.isSelected,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      remoteHeadSha: remoteHeadSha ?? this.remoteHeadSha,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GitHubRepositoryItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fullName == other.fullName;

  @override
  int get hashCode => id.hashCode ^ fullName.hashCode;
}

