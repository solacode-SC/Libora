import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/app_database.dart';
import '../../../../database/daos/github_dao.dart';
import '../../domain/models/github_account.dart';
import '../../domain/models/github_repository_item.dart';
import '../../domain/models/sync_metadata_item.dart';
import '../../domain/models/sync_status.dart';
import '../../domain/repositories/github_repository.dart';

class DriftGitHubRepository implements GitHubRepository {
  final GitHubDao _dao;

  DriftGitHubRepository(this._dao);

  // --- Account ---

  @override
  Future<GitHubAccount?> getAccount() async {
    final entry = await _dao.getAccount();
    return entry != null ? _mapAccountEntryToDomain(entry) : null;
  }

  @override
  Stream<GitHubAccount?> watchAccount() {
    return _dao.watchAccount().map((entry) => entry != null ? _mapAccountEntryToDomain(entry) : null);
  }

  @override
  Future<void> saveAccount(GitHubAccount account) async {
    await _dao.setAccount(
      GitHubAccountsCompanion.insert(
        id: account.id,
        githubUserId: account.githubUserId,
        login: account.login,
        name: Value(account.name),
        avatarUrl: Value(account.avatarUrl),
        createdAt: account.createdAt,
        updatedAt: account.updatedAt,
      ),
    );
  }

  @override
  Future<void> deleteAccount() => _dao.deleteAccount();

  // --- Repositories ---

  @override
  Future<List<GitHubRepositoryItem>> getAllRepositories() async {
    final entries = await _dao.getAllRepositories();
    return entries.map(_mapRepoEntryToDomain).toList();
  }

  @override
  Stream<List<GitHubRepositoryItem>> watchAllRepositories() {
    return _dao.watchAllRepositories().map((entries) => entries.map(_mapRepoEntryToDomain).toList());
  }

  @override
  Future<GitHubRepositoryItem?> getSelectedRepository() async {
    final entry = await _dao.getSelectedRepository();
    return entry != null ? _mapRepoEntryToDomain(entry) : null;
  }

  @override
  Stream<GitHubRepositoryItem?> watchSelectedRepository() {
    return _dao.watchSelectedRepository().map((entry) => entry != null ? _mapRepoEntryToDomain(entry) : null);
  }

  @override
  Future<void> saveRepository(GitHubRepositoryItem repo) async {
    await _dao.saveRepository(
      GitHubRepositoriesCompanion.insert(
        id: repo.id,
        githubRepoId: Value(repo.githubRepoId),
        owner: repo.owner,
        name: repo.name,
        fullName: repo.fullName,
        defaultBranch: Value(repo.defaultBranch),
        isPrivate: Value(repo.isPrivate),
        isSelected: Value(repo.isSelected),
        lastSyncedAt: Value(repo.lastSyncedAt),
        remoteHeadSha: Value(repo.remoteHeadSha),
        createdAt: repo.createdAt,
        updatedAt: repo.updatedAt,
      ),
    );
  }

  @override
  Future<void> selectRepository(String repoId) => _dao.setSelectedRepository(repoId);

  @override
  Future<void> updateRepositorySyncTime(String repoId, DateTime syncTime, {String? headSha}) =>
      _dao.updateRepositorySyncTime(repoId, syncTime, headSha: headSha);

  @override
  Future<void> deleteRepository(String repoId) => _dao.deleteRepository(repoId);

  @override
  Future<void> clearAllRepositories() => _dao.clearAllRepositories();

  // --- Sync Metadata ---

  @override
  Future<SyncMetadataItem?> getSyncMetadataForPdf(String pdfId) async {
    final entry = await _dao.getSyncMetadataForPdf(pdfId);
    return entry != null ? _mapSyncEntryToDomain(entry) : null;
  }

  @override
  Stream<SyncMetadataItem?> watchSyncMetadataForPdf(String pdfId) {
    return _dao.watchSyncMetadataForPdf(pdfId).map((entry) => entry != null ? _mapSyncEntryToDomain(entry) : null);
  }

  @override
  Future<SyncMetadataItem?> getSyncMetadataByRemotePath(String repoId, String remotePath) async {
    final entry = await _dao.getSyncMetadataByRemotePath(repoId, remotePath);
    return entry != null ? _mapSyncEntryToDomain(entry) : null;
  }

  @override
  Future<List<SyncMetadataItem>> getAllSyncMetadata(String repoId) async {
    final entries = await _dao.getAllSyncMetadata(repoId);
    return entries.map(_mapSyncEntryToDomain).toList();
  }

  @override
  Stream<List<SyncMetadataItem>> watchAllSyncMetadata(String repoId) {
    return _dao.watchAllSyncMetadata(repoId).map((entries) => entries.map(_mapSyncEntryToDomain).toList());
  }

  @override
  Future<List<SyncMetadataItem>> getPendingSyncMetadata(String repoId) async {
    final entries = await _dao.getPendingSyncMetadata(repoId);
    return entries.map(_mapSyncEntryToDomain).toList();
  }

  @override
  Future<void> saveSyncMetadata(SyncMetadataItem item) async {
    await _dao.insertSyncMetadata(
      SyncMetadataCompanion.insert(
        id: item.id,
        pdfId: item.pdfId,
        repositoryId: item.repositoryId,
        remotePath: item.remotePath,
        remoteSha: Value(item.remoteSha),
        remoteSize: Value(item.remoteSize),
        localHash: Value(item.localHash),
        lastSyncedAt: Value(item.lastSyncedAt),
        syncStatus: Value(item.syncStatus.value),
        lastError: Value(item.lastError),
        createdAt: item.createdAt,
        updatedAt: item.updatedAt,
      ),
    );
  }

  @override
  Future<void> updateSyncStatus(
    String id,
    SyncStatus status, {
    String? remoteSha,
    int? remoteSize,
    String? localHash,
    String? lastError,
    DateTime? lastSyncedAt,
  }) =>
      _dao.updateSyncStatus(
        id,
        status.value,
        remoteSha: remoteSha,
        remoteSize: remoteSize,
        localHash: localHash,
        lastError: lastError,
        lastSyncedAt: lastSyncedAt,
      );

  @override
  Future<void> deleteSyncMetadataForPdf(String pdfId) => _dao.deleteSyncMetadataForPdf(pdfId);

  @override
  Future<void> clearAllSyncMetadata() => _dao.clearAllSyncMetadata();

  // --- Mappers ---

  GitHubAccount _mapAccountEntryToDomain(GitHubAccountEntry entry) {
    return GitHubAccount(
      id: entry.id,
      githubUserId: entry.githubUserId,
      login: entry.login,
      name: entry.name,
      avatarUrl: entry.avatarUrl,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }

  GitHubRepositoryItem _mapRepoEntryToDomain(GitHubRepositoryEntry entry) {
    return GitHubRepositoryItem(
      id: entry.id,
      githubRepoId: entry.githubRepoId,
      owner: entry.owner,
      name: entry.name,
      fullName: entry.fullName,
      defaultBranch: entry.defaultBranch,
      isPrivate: entry.isPrivate,
      isSelected: entry.isSelected,
      lastSyncedAt: entry.lastSyncedAt,
      remoteHeadSha: entry.remoteHeadSha,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }

  SyncMetadataItem _mapSyncEntryToDomain(SyncMetadataEntry entry) {
    return SyncMetadataItem(
      id: entry.id,
      pdfId: entry.pdfId,
      repositoryId: entry.repositoryId,
      remotePath: entry.remotePath,
      remoteSha: entry.remoteSha,
      remoteSize: entry.remoteSize,
      localHash: entry.localHash,
      lastSyncedAt: entry.lastSyncedAt,
      syncStatus: SyncStatus.fromString(entry.syncStatus),
      lastError: entry.lastError,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }
}

final gitHubRepositoryProvider = Provider<GitHubRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftGitHubRepository(db.gitHubDao);
});

