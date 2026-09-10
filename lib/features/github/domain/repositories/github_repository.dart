import '../models/github_account.dart';
import '../models/github_repository_item.dart';
import '../models/sync_metadata_item.dart';
import '../models/sync_status.dart';

abstract class GitHubRepository {
  // Account
  Future<GitHubAccount?> getAccount();
  Stream<GitHubAccount?> watchAccount();
  Future<void> saveAccount(GitHubAccount account);
  Future<void> deleteAccount();

  // Repositories
  Future<List<GitHubRepositoryItem>> getAllRepositories();
  Stream<List<GitHubRepositoryItem>> watchAllRepositories();
  Future<GitHubRepositoryItem?> getSelectedRepository();
  Stream<GitHubRepositoryItem?> watchSelectedRepository();
  Future<void> saveRepository(GitHubRepositoryItem repo);
  Future<void> selectRepository(String repoId);
  Future<void> updateRepositorySyncTime(String repoId, DateTime syncTime, {String? headSha});
  Future<void> deleteRepository(String repoId);
  Future<void> clearAllRepositories();

  // Sync Metadata
  Future<SyncMetadataItem?> getSyncMetadataForPdf(String pdfId);
  Stream<SyncMetadataItem?> watchSyncMetadataForPdf(String pdfId);
  Future<SyncMetadataItem?> getSyncMetadataByRemotePath(String repoId, String remotePath);
  Future<List<SyncMetadataItem>> getAllSyncMetadata(String repoId);
  Stream<List<SyncMetadataItem>> watchAllSyncMetadata(String repoId);
  Future<List<SyncMetadataItem>> getPendingSyncMetadata(String repoId);
  Future<void> saveSyncMetadata(SyncMetadataItem item);
  Future<void> updateSyncStatus(
    String id,
    SyncStatus status, {
    String? remoteSha,
    int? remoteSize,
    String? localHash,
    String? lastError,
    DateTime? lastSyncedAt,
  });
  Future<void> deleteSyncMetadataForPdf(String pdfId);
  Future<void> clearAllSyncMetadata();
}

