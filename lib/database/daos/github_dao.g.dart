// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_dao.dart';

// ignore_for_file: type=lint
mixin _$GitHubDaoMixin on DatabaseAccessor<AppDatabase> {
  $GitHubAccountsTable get gitHubAccounts => attachedDatabase.gitHubAccounts;
  $GitHubRepositoriesTable get gitHubRepositories =>
      attachedDatabase.gitHubRepositories;
  $SyncMetadataTable get syncMetadata => attachedDatabase.syncMetadata;
  GitHubDaoManager get managers => GitHubDaoManager(this);
}

class GitHubDaoManager {
  final _$GitHubDaoMixin _db;
  GitHubDaoManager(this._db);
  $$GitHubAccountsTableTableManager get gitHubAccounts =>
      $$GitHubAccountsTableTableManager(
        _db.attachedDatabase,
        _db.gitHubAccounts,
      );
  $$GitHubRepositoriesTableTableManager get gitHubRepositories =>
      $$GitHubRepositoriesTableTableManager(
        _db.attachedDatabase,
        _db.gitHubRepositories,
      );
  $$SyncMetadataTableTableManager get syncMetadata =>
      $$SyncMetadataTableTableManager(_db.attachedDatabase, _db.syncMetadata);
}
