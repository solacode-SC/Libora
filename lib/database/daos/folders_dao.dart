import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/folders_table.dart';

part 'folders_dao.g.dart';

@DriftAccessor(tables: [Folders])
class FoldersDao extends DatabaseAccessor<AppDatabase> with _$FoldersDaoMixin {
  FoldersDao(super.db);

  Stream<List<FolderEntry>> watchAllFolders() => select(folders).watch();
  Future<List<FolderEntry>> getAllFolders() => select(folders).get();

  Future<FolderEntry?> getFolderById(String id) =>
      (select(folders)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertFolder(FoldersCompanion folder) =>
      into(folders).insert(folder);

  Future<bool> updateFolder(FoldersCompanion folder) =>
      update(folders).replace(folder);

  Future<int> deleteFolder(String id) =>
      (delete(folders)..where((t) => t.id.equals(id))).go();

  Future<int> renameFolder(String id, String newName) =>
      (update(folders)..where((t) => t.id.equals(id))).write(
        FoldersCompanion(
          name: Value(newName),
          updatedAt: Value(DateTime.now()),
        ),
      );
}
