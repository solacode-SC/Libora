/// Domain entity representing a user-defined folder collection.
class FolderItem {
  final String id;
  final String name;
  final String? parentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int pdfCount;

  const FolderItem({
    required this.id,
    required this.name,
    this.parentId,
    required this.createdAt,
    required this.updatedAt,
    this.pdfCount = 0,
  });

  FolderItem copyWith({
    String? id,
    String? name,
    String? parentId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? pdfCount,
  }) {
    return FolderItem(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pdfCount: pdfCount ?? this.pdfCount,
    );
  }
}
