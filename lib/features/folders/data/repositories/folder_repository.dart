import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/app_database.dart';
import '../../../../database/daos/folders_dao.dart';
import '../../../../database/daos/pdfs_dao.dart';
import '../../domain/models/folder_item.dart';

abstract class FolderRepository {
  Stream<List<FolderItem>> watchAllFolders();
  Future<List<FolderItem>> getAllFolders();
  Future<FolderItem?> getFolderById(String id);
  Future<void> createFolder(FolderItem folder);
  Future<void> renameFolder(String id, String newName);
  Future<void> deleteFolder(String id);
}

class DriftFolderRepository implements FolderRepository {
  final FoldersDao _dao;
  final PdfsDao? _pdfsDao;

  DriftFolderRepository(this._dao, [this._pdfsDao]);

  static FolderItem _toItem(FolderEntry entry) {
    return FolderItem(
      id: entry.id,
      name: entry.name,
      parentId: entry.parentId,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }

  @override
  Stream<List<FolderItem>> watchAllFolders() {
    return _dao.watchAllFolders().map(
      (entries) => entries.map(_toItem).toList(),
    );
  }

  @override
  Future<List<FolderItem>> getAllFolders() async {
    final entries = await _dao.getAllFolders();
    return entries.map(_toItem).toList();
  }

  @override
  Future<FolderItem?> getFolderById(String id) async {
    final entry = await _dao.getFolderById(id);
    return entry != null ? _toItem(entry) : null;
  }

  @override
  Future<void> createFolder(FolderItem folder) async {
    final companion = FoldersCompanion(
      id: Value(folder.id),
      name: Value(folder.name),
      parentId: Value(folder.parentId),
      createdAt: Value(folder.createdAt),
      updatedAt: Value(folder.updatedAt),
    );
    await _dao.insertFolder(companion);
  }

  @override
  Future<void> renameFolder(String id, String newName) async {
    await _dao.renameFolder(id, newName);
  }

  @override
  Future<void> deleteFolder(String id) async {
    if (_pdfsDao != null) {
      await _pdfsDao.detachFromFolder(id);
    }
    await _dao.deleteFolder(id);
  }
}

final folderRepositoryProvider = Provider<FolderRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftFolderRepository(db.foldersDao, db.pdfsDao);
});
