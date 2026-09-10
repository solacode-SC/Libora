import 'package:drift/drift.dart';

@DataClassName('GitHubRepositoryEntry')
class GitHubRepositories extends Table {
  TextColumn get id => text()();
  TextColumn get githubRepoId => text().nullable()();
  TextColumn get owner => text()();
  TextColumn get name => text()();
  TextColumn get fullName => text()();
  TextColumn get defaultBranch => text().withDefault(const Constant('main'))();
  BoolColumn get isPrivate => boolean().withDefault(const Constant(false))();
  BoolColumn get isSelected => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  TextColumn get remoteHeadSha => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

