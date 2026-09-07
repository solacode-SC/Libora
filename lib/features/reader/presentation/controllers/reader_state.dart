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
  final String? coverPath;
  final String? folderId;
  final int? fileSize;
  final int currentPage; // 1-indexed for display
  final int totalPages;
  final bool isToolbarVisible;
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
    this.coverPath,
    this.folderId,
    this.fileSize,
    this.currentPage = 1,
    this.totalPages = 0,
    this.isToolbarVisible = true,
    this.errorMessage,
    this.isFileAvailable = true,
    this.createdAt,
    this.lastReadAt,
  });

  /// Reading progress as a fraction between 0.0 and 1.0.
  double get progress {
    if (totalPages <= 0) return 0.0;
    return currentPage / totalPages;
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
    String? coverPath,
    String? folderId,
    int? fileSize,
    int? currentPage,
    int? totalPages,
    bool? isToolbarVisible,
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
      coverPath: coverPath ?? this.coverPath,
      folderId: folderId ?? this.folderId,
      fileSize: fileSize ?? this.fileSize,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isToolbarVisible: isToolbarVisible ?? this.isToolbarVisible,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      isFileAvailable: isFileAvailable ?? this.isFileAvailable,
      createdAt: createdAt ?? this.createdAt,
      lastReadAt: lastReadAt != null ? lastReadAt() : this.lastReadAt,
    );
  }
}
