enum SyncStatus {
  synced('synced'),
  uploadPending('upload_pending'),
  downloadPending('download_pending'),
  deletePending('delete_pending'),
  syncing('syncing'),
  conflict('conflict'),
  error('error');

  final String value;
  const SyncStatus(this.value);

  static SyncStatus fromString(String? value) {
    if (value == null) return SyncStatus.synced;
    for (final status in SyncStatus.values) {
      if (status.value == value) return status;
    }
    return SyncStatus.synced;
  }

  bool get isPending =>
      this == SyncStatus.uploadPending ||
      this == SyncStatus.downloadPending ||
      this == SyncStatus.deletePending;

  bool get isError => this == SyncStatus.error;
  bool get isConflict => this == SyncStatus.conflict;
  bool get isSynced => this == SyncStatus.synced;
  bool get isSyncing => this == SyncStatus.syncing;
}

