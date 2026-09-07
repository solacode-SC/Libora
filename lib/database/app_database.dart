import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tables/pdfs_table.dart';
import 'tables/folders_table.dart';
import 'tables/bookmarks_table.dart';
import 'daos/pdfs_dao.dart';
import 'daos/folders_dao.dart';
import 'daos/bookmarks_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Pdfs, Folders, Bookmarks],
  daos: [PdfsDao, FoldersDao, BookmarksDao],
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
  int get schemaVersion => 2;

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
