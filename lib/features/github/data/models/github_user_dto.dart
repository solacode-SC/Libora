class GitHubUserDto {
  final int id;
  final String login;
  final String? name;
  final String? avatarUrl;
  final String? email;

  const GitHubUserDto({
    required this.id,
    required this.login,
    this.name,
    this.avatarUrl,
    this.email,
  });

  factory GitHubUserDto.fromJson(Map<String, dynamic> json) {
    return GitHubUserDto(
      id: json['id'] as int,
      login: json['login'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'login': login,
        'name': name,
        'avatar_url': avatarUrl,
        'email': email,
      };
}

