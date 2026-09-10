import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/github_accounts_table.dart';
import '../tables/github_repositories_table.dart';
import '../tables/sync_metadata_table.dart';

part 'github_dao.g.dart';

@DriftAccessor(tables: [GitHubAccounts, GitHubRepositories, SyncMetadata])
class GitHubDao extends DatabaseAccessor<AppDatabase> with _$GitHubDaoMixin {
  GitHubDao(super.db);

  // --- Account operations ---

  Future<GitHubAccountEntry?> getAccount() =>
      select(gitHubAccounts).getSingleOrNull();

  Stream<GitHubAccountEntry?> watchAccount() =>
      select(gitHubAccounts).watchSingleOrNull();

  Future<void> setAccount(GitHubAccountsCompanion account) async {
    await delete(gitHubAccounts).go();
    await into(gitHubAccounts).insert(account);
  }

  Future<void> deleteAccount() async {
    await delete(gitHubAccounts).go();
  }

  // --- Repository operations ---

  Future<GitHubRepositoryEntry?> getSelectedRepository() =>
      (select(gitHubRepositories)
            ..where((t) => t.isSelected.equals(true))
            ..limit(1))
          .getSingleOrNull();

  Stream<GitHubRepositoryEntry?> watchSelectedRepository() =>
      (select(gitHubRepositories)
            ..where((t) => t.isSelected.equals(true))
            ..limit(1))
          .watchSingleOrNull();

  Future<List<GitHubRepositoryEntry>> getAllRepositories() =>
      select(gitHubRepositories).get();

  Stream<List<GitHubRepositoryEntry>> watchAllRepositories() =>
      select(gitHubRepositories).watch();

  Future<void> saveRepository(GitHubRepositoriesCompanion repo) =>
      into(gitHubRepositories).insertOnConflictUpdate(repo);

  Future<void> setSelectedRepository(String repoId) async {
    await update(gitHubRepositories).write(
      const GitHubRepositoriesCompanion(isSelected: Value(false)),
    );
    await (update(gitHubRepositories)..where((t) => t.id.equals(repoId))).write(
      const GitHubRepositoriesCompanion(isSelected: Value(true)),
    );
  }

  Future<void> updateRepositorySyncTime(
    String repoId,
    DateTime syncTime, {
    String? headSha,
  }) async {
    await (update(gitHubRepositories)..where((t) => t.id.equals(repoId))).write(
      GitHubRepositoriesCompanion(
        lastSyncedAt: Value(syncTime),
        remoteHeadSha: headSha != null ? Value(headSha) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteRepository(String repoId) async {
    await (delete(gitHubRepositories)..where((t) => t.id.equals(repoId))).go();
  }

  Future<void> clearAllRepositories() async {
    await delete(gitHubRepositories).go();
  }

  // --- SyncMetadata operations ---

  Future<SyncMetadataEntry?> getSyncMetadataForPdf(String pdfId) =>
      (select(syncMetadata)..where((t) => t.pdfId.equals(pdfId)))
          .getSingleOrNull();

  Stream<SyncMetadataEntry?> watchSyncMetadataForPdf(String pdfId) =>
      (select(syncMetadata)..where((t) => t.pdfId.equals(pdfId)))
          .watchSingleOrNull();

  Future<SyncMetadataEntry?> getSyncMetadataByRemotePath(
    String repositoryId,
    String remotePath,
  ) =>
      (select(syncMetadata)..where(
            (t) =>
                t.repositoryId.equals(repositoryId) &
                t.remotePath.equals(remotePath),
          ))
          .getSingleOrNull();

  Future<List<SyncMetadataEntry>> getAllSyncMetadata(String repositoryId) =>
      (select(syncMetadata)..where((t) => t.repositoryId.equals(repositoryId)))
          .get();

  Stream<List<SyncMetadataEntry>> watchAllSyncMetadata(String repositoryId) =>
      (select(syncMetadata)..where((t) => t.repositoryId.equals(repositoryId)))
          .watch();

  Future<List<SyncMetadataEntry>> getPendingSyncMetadata(
    String repositoryId,
  ) =>
      (select(syncMetadata)..where(
            (t) =>
                t.repositoryId.equals(repositoryId) &
                t.syncStatus.isIn([
                  'upload_pending',
                  'download_pending',
                  'delete_pending',
                  'error',
                ]),
          ))
          .get();

  Future<int> insertSyncMetadata(SyncMetadataCompanion metadata) =>
      into(syncMetadata).insertOnConflictUpdate(metadata);

  Future<bool> updateSyncMetadata(SyncMetadataCompanion metadata) =>
      update(syncMetadata).replace(metadata);

  Future<void> updateSyncStatus(
    String id,
    String status, {
    String? remoteSha,
    int? remoteSize,
    String? localHash,
    String? lastError,
    DateTime? lastSyncedAt,
  }) async {
    await (update(syncMetadata)..where((t) => t.id.equals(id))).write(
      SyncMetadataCompanion(
        syncStatus: Value(status),
        remoteSha: remoteSha != null ? Value(remoteSha) : const Value.absent(),
        remoteSize: remoteSize != null
            ? Value(remoteSize)
            : const Value.absent(),
        localHash: localHash != null ? Value(localHash) : const Value.absent(),
        lastError: Value(lastError),
        lastSyncedAt: lastSyncedAt != null
            ? Value(lastSyncedAt)
            : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> deleteSyncMetadataForPdf(String pdfId) =>
      (delete(syncMetadata)..where((t) => t.pdfId.equals(pdfId))).go();

  Future<int> deleteSyncMetadataForRepo(String repositoryId) =>
      (delete(syncMetadata)..where((t) => t.repositoryId.equals(repositoryId)))
          .go();

  Future<void> clearAllSyncMetadata() async {
    await delete(syncMetadata).go();
  }
}

