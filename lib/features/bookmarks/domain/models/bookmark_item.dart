/// Domain entity representing a marked page inside a PDF.
class BookmarkItem {
  final String id;
  final String pdfId;
  final int pageNumber;
  final String? label;
  final String? note;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const BookmarkItem({
    required this.id,
    required this.pdfId,
    required this.pageNumber,
    this.label,
    this.note,
    required this.createdAt,
    this.updatedAt,
  });

  BookmarkItem copyWith({
    String? id,
    String? pdfId,
    int? pageNumber,
    String? label,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookmarkItem(
      id: id ?? this.id,
      pdfId: pdfId ?? this.pdfId,
      pageNumber: pageNumber ?? this.pageNumber,
      label: label ?? this.label,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          pdfId == other.pdfId &&
          pageNumber == other.pageNumber &&
          label == other.label &&
          note == other.note &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      pdfId.hashCode ^
      pageNumber.hashCode ^
      label.hashCode ^
      note.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
