import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/repositories/folder_repository.dart';
import '../../domain/models/folder_item.dart';

/// StreamProvider that streams all created folders from the database.
final foldersStreamProvider = StreamProvider<List<FolderItem>>((ref) {
  final repo = ref.watch(folderRepositoryProvider);
  return repo.watchAllFolders();
});

/// Controller providing actions to create, rename, and delete folders.
class FoldersController {
  final FolderRepository _repo;
  final Uuid _uuid;

  FoldersController(this._repo, [this._uuid = const Uuid()]);

  Future<FolderItem?> createFolder(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return null;

    final now = DateTime.now();
    final folder = FolderItem(
      id: _uuid.v4(),
      name: trimmed,
      createdAt: now,
      updatedAt: now,
    );
    await _repo.createFolder(folder);
    return folder;
  }

  Future<void> renameFolder(String id, String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;
    await _repo.renameFolder(id, trimmed);
  }

  Future<void> deleteFolder(String id) async {
    await _repo.deleteFolder(id);
  }
}

final foldersControllerProvider = Provider<FoldersController>((ref) {
  final repo = ref.watch(folderRepositoryProvider);
  return FoldersController(repo);
});
