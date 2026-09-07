/// Domain entity representing a marked page inside a PDF.
class BookmarkItem {
  final String id;
  final String pdfId;
  final int pageNumber;
  final String? label;
  final DateTime createdAt;

  const BookmarkItem({
    required this.id,
    required this.pdfId,
    required this.pageNumber,
    this.label,
    required this.createdAt,
  });

  BookmarkItem copyWith({
    String? id,
    String? pdfId,
    int? pageNumber,
    String? label,
    DateTime? createdAt,
  }) {
    return BookmarkItem(
      id: id ?? this.id,
      pdfId: pdfId ?? this.pdfId,
      pageNumber: pageNumber ?? this.pageNumber,
      label: label ?? this.label,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
