import 'package:flutter_test/flutter_test.dart';
import 'package:libora/features/folders/data/repositories/folder_repository.dart';
import 'package:libora/features/folders/domain/models/folder_item.dart';
import 'package:libora/features/github/domain/services/folder_path_resolver.dart';

import '../../helpers/test_database.dart';

void main() {
  group('FolderPathResolver Tests', () {
    test('normalizePath cleans slashes and traversal', () {
      expect(
        FolderPathResolver.normalizePath(r'Books\Programming\Clean Code.pdf'),
        equals('Books/Programming/Clean Code.pdf'),
      );
      expect(
        FolderPathResolver.normalizePath('/Books//Programming/Clean Code.pdf/'),
        equals('Books/Programming/Clean Code.pdf'),
      );
      expect(
        FolderPathResolver.normalizePath('Books/Sub/../Programming/Clean Code.pdf'),
        equals('Books/Programming/Clean Code.pdf'),
      );
    });

    test('extractFileName extracts simple and nested file names', () {
      expect(
        FolderPathResolver.extractFileName('Clean Code.pdf'),
        equals('Clean Code.pdf'),
      );
      expect(
        FolderPathResolver.extractFileName('Books/Programming/Clean Code.pdf'),
        equals('Clean Code.pdf'),
      );
    });

    test('resolveRemotePath for root document (no folder)', () {
      final path = FolderPathResolver.resolveRemotePath(
        folderId: null,
        fileName: 'Clean Architecture.pdf',
        allFolders: [],
      );
      expect(path, equals('Clean Architecture.pdf'));
    });

    test('resolveRemotePath for 1-level folder', () {
      final now = DateTime.now();
      final folders = [
        FolderItem(id: 'f1', name: 'Software', createdAt: now, updatedAt: now),
      ];

      final path = FolderPathResolver.resolveRemotePath(
        folderId: 'f1',
        fileName: 'Clean Code.pdf',
        allFolders: folders,
      );
      expect(path, equals('Software/Clean Code.pdf'));
    });

    test('resolveRemotePath for multi-level nested folders', () {
      final now = DateTime.now();
      final folders = [
        FolderItem(id: 'root-books', name: 'Books', createdAt: now, updatedAt: now),
        FolderItem(id: 'f-tech', name: 'Technology', parentId: 'root-books', createdAt: now, updatedAt: now),
        FolderItem(id: 'f-dart', name: 'Dart & Flutter', parentId: 'f-tech', createdAt: now, updatedAt: now),
      ];

      final path = FolderPathResolver.resolveRemotePath(
        folderId: 'f-dart',
        fileName: 'Flutter In Action.pdf',
        allFolders: folders,
      );
      expect(path, equals('Books/Technology/Dart & Flutter/Flutter In Action.pdf'));
    });

    test('resolveLocalFolderId creates nested local folders from remote path', () async {
      final db = createTestDatabase();
      final folderRepo = DriftFolderRepository(db.foldersDao);

      // Root item returns null folderId
      final rootFolderId = await FolderPathResolver.resolveLocalFolderId(
        remotePath: 'RootBook.pdf',
        folderRepo: folderRepo,
      );
      expect(rootFolderId, isNull);

      // Nested item: Books/Engineering/Architecture.pdf
      final leafFolderId = await FolderPathResolver.resolveLocalFolderId(
        remotePath: 'Books/Engineering/Architecture.pdf',
        folderRepo: folderRepo,
      );
      expect(leafFolderId, isNotNull);

      final allFolders = await folderRepo.getAllFolders();
      expect(allFolders.length, equals(2));

      final rootFolder = allFolders.firstWhere((f) => f.name == 'Books');
      expect(rootFolder.parentId, isNull);

      final leafFolder = allFolders.firstWhere((f) => f.name == 'Engineering');
      expect(leafFolder.parentId, equals(rootFolder.id));
      expect(leafFolder.id, equals(leafFolderId));

      // Resolving same path again should reuse existing folders without duplicate creation
      final secondLeafId = await FolderPathResolver.resolveLocalFolderId(
        remotePath: 'Books/Engineering/SecondBook.pdf',
        folderRepo: folderRepo,
      );
      expect(secondLeafId, equals(leafFolderId));

      final foldersAfterSecond = await folderRepo.getAllFolders();
      expect(foldersAfterSecond.length, equals(2));

      await db.close();
    });
  });
}

