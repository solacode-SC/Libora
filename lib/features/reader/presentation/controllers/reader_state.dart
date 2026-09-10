import 'dart:typed_data';

import '../../../bookmarks/domain/models/bookmark_item.dart';

/// Status of the PDF reader.
enum ReaderStatus { loading, ready, error }

/// Immutable state for the PDF reader.
///
/// Progress is computed from [currentPage] and [totalPages] — not stored.
class ReaderState {
  final ReaderStatus status;
  final String? pdfId;
  final String? title;
  final String? fileName;
  final String? localPath;
  final Uint8List? pdfBytes;
  final String? coverPath;
  final String? folderId;
  final int? fileSize;
  final int currentPage; // 1-indexed for display
  final int totalPages;
  final bool isToolbarVisible;
  final bool isFavorite;
  final List<BookmarkItem> bookmarks;
  final String? errorMessage;
  final bool isFileAvailable;
  final DateTime? createdAt;
  final DateTime? lastReadAt;

  const ReaderState({
    this.status = ReaderStatus.loading,
    this.pdfId,
    this.title,
    this.fileName,
    this.localPath,
    this.pdfBytes,
    this.coverPath,
    this.folderId,
    this.fileSize,
    this.currentPage = 1,
    this.totalPages = 0,
    this.isToolbarVisible = true,
    this.isFavorite = false,
    this.bookmarks = const [],
    this.errorMessage,
    this.isFileAvailable = true,
    this.createdAt,
    this.lastReadAt,
  });

  /// Set of bookmarked page numbers for O(1) in-memory lookup.
  Set<int> get bookmarkedPages => bookmarks.map((b) => b.pageNumber).toSet();

  /// Whether the active page is currently bookmarked.
  bool get isCurrentPageBookmarked => bookmarkedPages.contains(currentPage);

  /// The bookmark entity for the active page, if present.
  BookmarkItem? get currentBookmark {
    for (final b in bookmarks) {
      if (b.pageNumber == currentPage) return b;
    }
    return null;
  }

  /// Reading progress as a fraction between 0.0 and 1.0.
  double get progress {
    if (totalPages <= 0) return 0.0;
    return (currentPage / totalPages).clamp(0.0, 1.0);
  }

  /// Reading progress as an integer percentage (0–100).
  int get progressPercent => (progress * 100).round();

  /// Formatted page indicator string, e.g. "12 / 464".
  String get pageIndicator {
    if (totalPages <= 0) return '$currentPage';
    return '$currentPage / $totalPages';
  }

  ReaderState copyWith({
    ReaderStatus? status,
    String? pdfId,
    String? title,
    String? fileName,
    String? localPath,
    Uint8List? pdfBytes,
    String? coverPath,
    String? folderId,
    int? fileSize,
    int? currentPage,
    int? totalPages,
    bool? isToolbarVisible,
    bool? isFavorite,
    List<BookmarkItem>? bookmarks,
    String? Function()? errorMessage,
    bool? isFileAvailable,
    DateTime? createdAt,
    DateTime? Function()? lastReadAt,
  }) {
    return ReaderState(
      status: status ?? this.status,
      pdfId: pdfId ?? this.pdfId,
      title: title ?? this.title,
      fileName: fileName ?? this.fileName,
      localPath: localPath ?? this.localPath,
      pdfBytes: pdfBytes ?? this.pdfBytes,
      coverPath: coverPath ?? this.coverPath,
      folderId: folderId ?? this.folderId,
      fileSize: fileSize ?? this.fileSize,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isToolbarVisible: isToolbarVisible ?? this.isToolbarVisible,
      isFavorite: isFavorite ?? this.isFavorite,
      bookmarks: bookmarks ?? this.bookmarks,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      isFileAvailable: isFileAvailable ?? this.isFileAvailable,
      createdAt: createdAt ?? this.createdAt,
      lastReadAt: lastReadAt != null ? lastReadAt() : this.lastReadAt,
    );
  }
}
