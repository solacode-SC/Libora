import 'sync_status.dart';

class SyncMetadataItem {
  final String id;
  final String pdfId;
  final String repositoryId;
  final String remotePath;
  final String? remoteSha;
  final int? remoteSize;
  final String? localHash;
  final DateTime? lastSyncedAt;
  final SyncStatus syncStatus;
  final String? lastError;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SyncMetadataItem({
    required this.id,
    required this.pdfId,
    required this.repositoryId,
    required this.remotePath,
    this.remoteSha,
    this.remoteSize,
    this.localHash,
    this.lastSyncedAt,
    this.syncStatus = SyncStatus.synced,
    this.lastError,
    required this.createdAt,
    required this.updatedAt,
  });

  SyncMetadataItem copyWith({
    String? id,
    String? pdfId,
    String? repositoryId,
    String? remotePath,
    String? remoteSha,
    int? remoteSize,
    String? localHash,
    DateTime? lastSyncedAt,
    SyncStatus? syncStatus,
    String? lastError,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SyncMetadataItem(
      id: id ?? this.id,
      pdfId: pdfId ?? this.pdfId,
      repositoryId: repositoryId ?? this.repositoryId,
      remotePath: remotePath ?? this.remotePath,
      remoteSha: remoteSha ?? this.remoteSha,
      remoteSize: remoteSize ?? this.remoteSize,
      localHash: localHash ?? this.localHash,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

