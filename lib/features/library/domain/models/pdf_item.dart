/// Domain entity representing a local or imported PDF on the device.
class PdfItem {
  final String id;
  final String title;
  final String fileName;
  final String? localPath;
  final String? remotePath;
  final String? coverPath;
  final int? pageCount;
  final int? fileSize;
  final String? folderId;
  final String source; // 'local' | 'github'
  final bool isFavorite;
  final int currentPage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastReadAt;

  const PdfItem({
    required this.id,
    required this.title,
    required this.fileName,
    this.localPath,
    this.remotePath,
    this.coverPath,
    this.pageCount,
    this.fileSize,
    this.folderId,
    this.source = 'local',
    this.isFavorite = false,
    this.currentPage = 0,
    required this.createdAt,
    required this.updatedAt,
    this.lastReadAt,
  });

  PdfItem copyWith({
    String? id,
    String? title,
    String? fileName,
    String? localPath,
    String? remotePath,
    String? coverPath,
    int? pageCount,
    int? fileSize,
    String? folderId,
    String? source,
    bool? isFavorite,
    int? currentPage,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastReadAt,
  }) {
    return PdfItem(
      id: id ?? this.id,
      title: title ?? this.title,
      fileName: fileName ?? this.fileName,
      localPath: localPath ?? this.localPath,
      remotePath: remotePath ?? this.remotePath,
      coverPath: coverPath ?? this.coverPath,
      pageCount: pageCount ?? this.pageCount,
      fileSize: fileSize ?? this.fileSize,
      folderId: folderId ?? this.folderId,
      source: source ?? this.source,
      isFavorite: isFavorite ?? this.isFavorite,
      currentPage: currentPage ?? this.currentPage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastReadAt: lastReadAt ?? this.lastReadAt,
    );
  }
}
