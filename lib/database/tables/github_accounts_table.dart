import 'package:drift/drift.dart';

@DataClassName('GitHubAccountEntry')
class GitHubAccounts extends Table {
  TextColumn get id => text()();
  TextColumn get githubUserId => text()();
  TextColumn get login => text()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get name => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

