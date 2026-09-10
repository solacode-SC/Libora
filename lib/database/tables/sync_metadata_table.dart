import 'package:drift/drift.dart';

@DataClassName('SyncMetadataEntry')
class SyncMetadata extends Table {
  TextColumn get id => text()();
  TextColumn get pdfId => text()();
  TextColumn get repositoryId => text()();
  TextColumn get remotePath => text()();
  TextColumn get remoteSha => text().nullable()();
  IntColumn get remoteSize => integer().nullable()();
  TextColumn get localHash => text().nullable()();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant('upload_pending'))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

