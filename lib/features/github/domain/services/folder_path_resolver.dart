import 'package:uuid/uuid.dart';

import '../../../folders/data/repositories/folder_repository.dart';
import '../../../folders/domain/models/folder_item.dart';

class FolderPathResolver {
  static const _uuid = Uuid();

  /// Normalizes a path string: converts backslashes to forward slashes,
  /// collapses consecutive slashes, removes leading/trailing slashes,
  /// and removes redundant directory traversal like './' or '../'.
  static String normalizePath(String path) {
    var clean = path.replaceAll(r'\', '/');
    final segments = clean.split('/').where((s) => s.isNotEmpty && s != '.').toList();
    final resolved = <String>[];
    for (final seg in segments) {
      if (seg == '..') {
        if (resolved.isNotEmpty) resolved.removeLast();
      } else {
        resolved.add(seg.trim());
      }
    }
    return resolved.join('/');
  }

  /// Resolves the remote GitHub path for a given local PDF file and folder.
  /// Example:
  /// - Root PDF: "Clean Code.pdf" -> "Clean Code.pdf"
  /// - Nested PDF: folder "Tech" -> parent folder "Books" -> "Books/Tech/Clean Code.pdf"
  static String resolveRemotePath({
    required String? folderId,
    required String fileName,
    required List<FolderItem> allFolders,
  }) {
    final cleanFileName = fileName.trim();
    if (folderId == null || folderId.isEmpty) {
      return cleanFileName;
    }

    final folderMap = {for (final f in allFolders) f.id: f};
    final segments = <String>[];
    final visited = <String>{};

    String? currentId = folderId;
    while (currentId != null && !visited.contains(currentId)) {
      visited.add(currentId);
      final folder = folderMap[currentId];
      if (folder == null) break;
      segments.insert(0, folder.name.trim());
      currentId = folder.parentId;
    }

    if (segments.isEmpty) {
      return cleanFileName;
    }

    segments.add(cleanFileName);
    return segments.join('/');
  }

  /// Parses a remote GitHub path (e.g. "Books/Tech/Clean Code.pdf"),
  /// finds or creates the corresponding nested local folders in the database,
  /// and returns the leaf folder ID (or null if the PDF resides in the root directory).
  static Future<String?> resolveLocalFolderId({
    required String remotePath,
    required FolderRepository folderRepo,
  }) async {
    final normalized = normalizePath(remotePath);
    final segments = normalized.split('/');
    if (segments.length <= 1) {
      // It's in root directory
      return null;
    }

    // Directory segments exclude the file name (the last segment)
    final dirSegments = segments.sublist(0, segments.length - 1);
    final allFolders = await folderRepo.getAllFolders();
    final activeFolders = List<FolderItem>.from(allFolders);

    String? currentParentId;

    for (final dirName in dirSegments) {
      final trimmedName = dirName.trim();
      if (trimmedName.isEmpty) continue;

      // Check if folder exists at this depth
      FolderItem? existing;
      for (final f in activeFolders) {
        if (f.name.toLowerCase() == trimmedName.toLowerCase() &&
            f.parentId == currentParentId) {
          existing = f;
          break;
        }
      }

      if (existing != null) {
        currentParentId = existing.id;
      } else {
        // Create new folder
        final now = DateTime.now();
        final newFolder = FolderItem(
          id: _uuid.v4(),
          name: trimmedName,
          parentId: currentParentId,
          createdAt: now,
          updatedAt: now,
        );
        await folderRepo.createFolder(newFolder);
        activeFolders.add(newFolder);
        currentParentId = newFolder.id;
      }
    }

    return currentParentId;
  }

  /// Extracts the filename from a remote path.
  static String extractFileName(String remotePath) {
    final normalized = normalizePath(remotePath);
    return normalized.split('/').last;
  }
}

