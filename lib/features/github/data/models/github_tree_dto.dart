class GitHubTreeItemDto {
  final String path;
  final String mode;
  final String type; // 'blob' or 'tree'
  final String sha;
  final int? size;
  final String? url;

  const GitHubTreeItemDto({
    required this.path,
    required this.mode,
    required this.type,
    required this.sha,
    this.size,
    this.url,
  });

  bool get isBlob => type == 'blob';
  bool get isTree => type == 'tree';
  bool get isPdf => path.toLowerCase().endsWith('.pdf');

  factory GitHubTreeItemDto.fromJson(Map<String, dynamic> json) {
    return GitHubTreeItemDto(
      path: json['path'] as String,
      mode: json['mode'] as String,
      type: json['type'] as String,
      sha: json['sha'] as String,
      size: json['size'] as int?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'path': path,
        'mode': mode,
        'type': type,
        'sha': sha,
        'size': size,
        'url': url,
      };
}

class GitHubTreeDto {
  final String sha;
  final String? url;
  final List<GitHubTreeItemDto> tree;
  final bool truncated;

  const GitHubTreeDto({
    required this.sha,
    this.url,
    required this.tree,
    this.truncated = false,
  });

  List<GitHubTreeItemDto> get pdfBlobs =>
      tree.where((item) => item.isBlob && item.isPdf).toList();

  factory GitHubTreeDto.fromJson(Map<String, dynamic> json) {
    final rawTree = json['tree'] as List<dynamic>? ?? [];
    final items = rawTree
        .map((item) => GitHubTreeItemDto.fromJson(item as Map<String, dynamic>))
        .toList();

    return GitHubTreeDto(
      sha: json['sha'] as String? ?? '',
      url: json['url'] as String?,
      tree: items,
      truncated: json['truncated'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'sha': sha,
        'url': url,
        'tree': tree.map((e) => e.toJson()).toList(),
        'truncated': truncated,
      };
}

