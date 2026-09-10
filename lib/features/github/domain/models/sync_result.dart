class SyncProgress {
  final String message;
  final int completedItems;
  final int totalItems;
  final double? percentage;

  const SyncProgress({
    required this.message,
    this.completedItems = 0,
    this.totalItems = 0,
    this.percentage,
  });
}

class SyncResult {
  final int uploadedCount;
  final int downloadedCount;
  final int deletedCount;
  final int conflictCount;
  final int errorCount;
  final List<String> errors;

  const SyncResult({
    this.uploadedCount = 0,
    this.downloadedCount = 0,
    this.deletedCount = 0,
    this.conflictCount = 0,
    this.errorCount = 0,
    this.errors = const [],
  });

  bool get isSuccess => errorCount == 0 && conflictCount == 0;
  bool get hasChanges => (uploadedCount + downloadedCount + deletedCount) > 0;

  SyncResult copyWith({
    int? uploadedCount,
    int? downloadedCount,
    int? deletedCount,
    int? conflictCount,
    int? errorCount,
    List<String>? errors,
  }) {
    return SyncResult(
      uploadedCount: uploadedCount ?? this.uploadedCount,
      downloadedCount: downloadedCount ?? this.downloadedCount,
      deletedCount: deletedCount ?? this.deletedCount,
      conflictCount: conflictCount ?? this.conflictCount,
      errorCount: errorCount ?? this.errorCount,
      errors: errors ?? this.errors,
    );
  }
}

