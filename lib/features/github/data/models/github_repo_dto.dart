class GitHubRepoDto {
  final int id;
  final String name;
  final String fullName;
  final String owner;
  final bool isPrivate;
  final String defaultBranch;
  final String? description;
  final String? htmlUrl;

  const GitHubRepoDto({
    required this.id,
    required this.name,
    required this.fullName,
    required this.owner,
    required this.isPrivate,
    this.defaultBranch = 'main',
    this.description,
    this.htmlUrl,
  });

  factory GitHubRepoDto.fromJson(Map<String, dynamic> json) {
    final ownerMap = json['owner'];
    final ownerName = ownerMap is Map<String, dynamic>
        ? (ownerMap['login'] as String? ?? '')
        : (json['owner'] as String? ?? '');

    return GitHubRepoDto(
      id: json['id'] as int,
      name: json['name'] as String,
      fullName: json['full_name'] as String,
      owner: ownerName,
      isPrivate: json['private'] as bool? ?? false,
      defaultBranch: json['default_branch'] as String? ?? 'main',
      description: json['description'] as String?,
      htmlUrl: json['html_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'full_name': fullName,
        'owner': owner,
        'private': isPrivate,
        'default_branch': defaultBranch,
        'description': description,
        'html_url': htmlUrl,
      };
}

