import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tables/pdfs_table.dart';
import 'tables/folders_table.dart';
import 'tables/bookmarks_table.dart';
import 'tables/github_accounts_table.dart';
import 'tables/github_repositories_table.dart';
import 'tables/sync_metadata_table.dart';
import 'daos/pdfs_dao.dart';
import 'daos/folders_dao.dart';
import 'daos/bookmarks_dao.dart';
import 'daos/github_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Pdfs,
    Folders,
    Bookmarks,
    GitHubAccounts,
    GitHubRepositories,
    SyncMetadata,
  ],
  daos: [PdfsDao, FoldersDao, BookmarksDao, GitHubDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e])
    : super(
        e ??
            driftDatabase(
              name: 'libora',
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              ),
            ),
      );

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(pdfs, pdfs.fileHash);
        }
        if (from < 3) {
          await m.addColumn(bookmarks, bookmarks.note);
          await m.addColumn(bookmarks, bookmarks.updatedAt);
        }
        if (from < 4) {
          await m.createTable(gitHubAccounts);
          await m.createTable(gitHubRepositories);
          await m.createTable(syncMetadata);
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

/// Centralized Riverpod provider for the Drift database.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});
