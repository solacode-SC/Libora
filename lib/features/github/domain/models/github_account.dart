class GitHubAccount {
  final String id;
  final String githubUserId;
  final String login;
  final String? name;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GitHubAccount({
    required this.id,
    required this.githubUserId,
    required this.login,
    this.name,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  String get displayName => (name != null && name!.isNotEmpty) ? name! : login;

  GitHubAccount copyWith({
    String? id,
    String? githubUserId,
    String? login,
    String? name,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GitHubAccount(
      id: id ?? this.id,
      githubUserId: githubUserId ?? this.githubUserId,
      login: login ?? this.login,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GitHubAccount &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          githubUserId == other.githubUserId &&
          login == other.login;

  @override
  int get hashCode => id.hashCode ^ githubUserId.hashCode ^ login.hashCode;
}

