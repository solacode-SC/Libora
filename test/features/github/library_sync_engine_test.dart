import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:libora/core/services/default_pdf_file_service.dart';
import 'package:libora/core/services/default_pdf_thumbnail_service.dart';
import 'package:libora/core/services/local_storage_service.dart';
import 'package:libora/core/services/pdf_file_service.dart';
import 'package:libora/database/app_database.dart';
import 'package:libora/features/folders/data/repositories/folder_repository.dart';
import 'package:libora/features/folders/domain/models/folder_item.dart';
import 'package:libora/features/github/data/datasources/github_api_client.dart';
import 'package:libora/features/github/data/datasources/github_token_storage.dart';
import 'package:libora/features/github/data/models/github_repo_dto.dart';
import 'package:libora/features/github/data/models/github_tree_dto.dart';
import 'package:libora/features/github/data/models/github_user_dto.dart';
import 'package:libora/features/github/data/repositories/drift_github_repository.dart';
import 'package:libora/features/github/domain/models/github_repository_item.dart';
import 'package:libora/features/github/domain/models/sync_metadata_item.dart';
import 'package:libora/features/github/domain/models/sync_status.dart';
import 'package:libora/features/github/domain/repositories/github_repository.dart';
import 'package:libora/features/github/domain/services/library_sync_engine.dart';
import 'package:libora/features/library/data/repositories/pdf_repository.dart';
import 'package:libora/features/library/domain/models/pdf_item.dart';

import '../../helpers/test_database.dart';

class MockGitHubApiClient implements IGitHubApiClient {
  final Map<String, List<int>> remoteFiles = {};
  final Map<String, String> remoteShas = {};
  final List<String> deletedPaths = [];
  final List<String> uploadedPaths = [];

  @override
  Future<GitHubTreeDto> fetchRepositoryTree({
    required String owner,
    required String repo,
    required String branch,
    required String token,
  }) async {
    final items = remoteFiles.entries.map((e) {
      return GitHubTreeItemDto(
        path: e.key,
        mode: '100644',
        type: 'blob',
        sha: remoteShas[e.key] ?? 'sha-${e.key}',
        size: e.value.length,
        url: null,
      );
    }).toList();

    return GitHubTreeDto(sha: 'head-sha-123', tree: items);
  }

  @override
  Future<List<int>> downloadFileBytes({
    required String owner,
    required String repo,
    required String path,
    required String branch,
    required String token,
    void Function(int received, int total)? onProgress,
  }) async {
    final content = remoteFiles[path];
    if (content == null) {
      throw Exception('Remote file not found: $path');
    }
    return content;
  }

  @override
  Future<Map<String, dynamic>> uploadFile({
    required String owner,
    required String repo,
    required String path,
    required List<int> contentBytes,
    required String message,
    required String branch,
    String? sha,
    required String token,
    void Function(int sent, int total)? onProgress,
  }) async {
    uploadedPaths.add(path);
    remoteFiles[path] = contentBytes;
    final newSha = 'sha-${path.hashCode}-${contentBytes.length}';
    remoteShas[path] = newSha;

    return {
      'content': {
        'name': path.split('/').last,
        'path': path,
        'sha': newSha,
        'size': contentBytes.length,
      }
    };
  }

  @override
  Future<void> deleteFile({
    required String owner,
    required String repo,
    required String path,
    required String sha,
    required String message,
    required String branch,
    required String token,
  }) async {
    deletedPaths.add(path);
    remoteFiles.remove(path);
    remoteShas.remove(path);
  }

  @override
  Future<List<GitHubRepoDto>> fetchUserRepositories(String token, {int page = 1, int perPage = 100}) async => [];

  @override
  Future<GitHubUserDto> validateToken(String token) async =>
      const GitHubUserDto(id: 1, login: 'testuser');
}

class MockTokenStorage implements IGitHubTokenStorage {
  String? token = 'ghp_dummyToken';

  @override
  Future<void> deleteToken() async => token = null;

  @override
  Future<String?> getToken() async => token;

  @override
  Future<bool> hasToken() async => token != null;

  @override
  Future<void> saveToken(String t) async => token = t;
}

class FakePdfFileService extends DefaultPdfFileService {
  @override
  Future<PdfMetadata> extractMetadata(File file, {String? originalFileName}) async {
    final name = originalFileName ?? file.path.split('/').last;
    return PdfMetadata(
      title: name.replaceAll('.pdf', ''),
      pageCount: 10,
      fileSize: await file.length(),
    );
  }

  @override
  Future<List<File>> pickPdfFiles() async => [];

  @override
  Future<bool> validatePdf(File file) async => true;
}

class FakeThumbnailService implements DefaultPdfThumbnailService {
  @override
  Future<File?> generateCoverImage({
    required File pdfFile,
    required String destinationPath,
    int pageIndex = 0,
    int targetWidth = 400,
  }) async => null;

  @override
  Future<Uint8List?> generateCoverBytes({
    required Uint8List pdfBytes,
    int pageIndex = 0,
    int targetWidth = 400,
  }) async => null;
}

void main() {
  group('LibrarySyncEngine Tests', () {
    late AppDatabase db;
    late GitHubRepository gitHubRepo;
    late PdfRepository pdfRepo;
    late FolderRepository folderRepo;
    late MockGitHubApiClient mockApi;
    late MockTokenStorage mockToken;
    late Directory tempDir;
    late LocalStorageService storageService;
    late LibrarySyncEngine engine;

    // Valid PDF header bytes "%PDF-1.4 ... %%EOF"
    final validPdfBytes = [
      0x25, 0x50, 0x44, 0x46, 0x2D, 0x31, 0x2E, 0x34,
      0x0A, 0x25, 0xC4, 0xE5, 0xF2, 0xE5, 0x0A,
    ];

    setUp(() async {
      db = createTestDatabase();
      gitHubRepo = DriftGitHubRepository(db.gitHubDao);
      pdfRepo = DriftPdfRepository(db.pdfsDao);
      folderRepo = DriftFolderRepository(db.foldersDao);
      mockApi = MockGitHubApiClient();
      mockToken = MockTokenStorage();

      tempDir = await Directory.systemTemp.createTemp('libora_sync_test_');
      storageService = LocalStorageService(baseDirectory: tempDir);

      engine = LibrarySyncEngine(
        apiClient: mockApi,
        tokenStorage: mockToken,
        gitHubRepository: gitHubRepo,
        pdfRepository: pdfRepo,
        folderRepository: folderRepo,
        storageService: storageService,
        fileService: FakePdfFileService(),
        thumbnailService: FakeThumbnailService(),
      );

      // Setup active selected repo
      final now = DateTime.now();
      await gitHubRepo.saveRepository(
        GitHubRepositoryItem(
          id: 'repo-1',
          owner: 'solacode',
          name: 'libora-books',
          fullName: 'solacode/libora-books',
          defaultBranch: 'main',
          isSelected: true,
          createdAt: now,
          updatedAt: now,
        ),
      );
    });

    tearDown(() async {
      await db.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('uploads local PDF to GitHub and records SyncMetadata (Local Addition)', () async {
      // 1. Create a physical PDF file
      final pdfsDir = await storageService.getPdfsDirectory();
      final localPdfFile = File('${pdfsDir.path}/clean_code.pdf');
      await localPdfFile.writeAsBytes(validPdfBytes);

      // 2. Add PDF item to repository
      final now = DateTime.now();
      await pdfRepo.savePdf(
        PdfItem(
          id: 'pdf-1',
          title: 'Clean Code',
          fileName: 'Clean Code.pdf',
          localPath: localPdfFile.path,
          fileSize: validPdfBytes.length,
          source: 'local',
          createdAt: now,
          updatedAt: now,
        ),
      );

      // 3. Run sync
      final result = await engine.syncLibrary();
      expect(result.uploadedCount, equals(1));
      expect(result.downloadedCount, equals(0));
      expect(result.errorCount, equals(0));
      expect(mockApi.uploadedPaths, contains('Clean Code.pdf'));

      // 4. Verify metadata persisted in DB
      final metadata = await gitHubRepo.getSyncMetadataForPdf('pdf-1');
      expect(metadata, isNotNull);
      expect(metadata?.remotePath, equals('Clean Code.pdf'));
      expect(metadata?.syncStatus, equals(SyncStatus.synced));
    });

    test('idempotency: subsequent sync with no changes executes 0 uploads and 0 downloads', () async {
      // Setup local PDF
      final pdfsDir = await storageService.getPdfsDirectory();
      final localPdfFile = File('${pdfsDir.path}/clean_code.pdf');
      await localPdfFile.writeAsBytes(validPdfBytes);

      final now = DateTime.now();
      await pdfRepo.savePdf(
        PdfItem(
          id: 'pdf-1',
          title: 'Clean Code',
          fileName: 'Clean Code.pdf',
          localPath: localPdfFile.path,
          fileSize: validPdfBytes.length,
          source: 'local',
          createdAt: now,
          updatedAt: now,
        ),
      );

      // First sync
      final result1 = await engine.syncLibrary();
      expect(result1.uploadedCount, equals(1));

      // Second sync immediately after with no changes
      final result2 = await engine.syncLibrary();
      expect(result2.uploadedCount, equals(0));
      expect(result2.downloadedCount, equals(0));
      expect(result2.deletedCount, equals(0));
      expect(result2.hasChanges, isFalse);
    });

    test('downloads new remote PDF from GitHub and resolves folder hierarchy (Remote Addition)', () async {
      // Remote has a PDF at 'Tech/Programming/Clean Architecture.pdf'
      mockApi.remoteFiles['Tech/Programming/Clean Architecture.pdf'] = validPdfBytes;
      mockApi.remoteShas['Tech/Programming/Clean Architecture.pdf'] = 'sha-arch-123';

      final result = await engine.syncLibrary();
      expect(result.downloadedCount, equals(1));
      expect(result.errorCount, equals(0));

      // Verify PDF was inserted locally in SQLite
      final localPdfs = await pdfRepo.getAllPdfs();
      expect(localPdfs.length, equals(1));
      expect(localPdfs.first.fileName, equals('Clean Architecture.pdf'));
      expect(localPdfs.first.source, equals('github'));

      // Verify folders were created
      final allFolders = await folderRepo.getAllFolders();
      expect(allFolders.length, equals(2));
      final techFolder = allFolders.firstWhere((f) => f.name == 'Tech');
      final progFolder = allFolders.firstWhere((f) => f.name == 'Programming');
      expect(progFolder.parentId, equals(techFolder.id));
      expect(localPdfs.first.folderId, equals(progFolder.id));

      // Verify physical file saved to managed storage
      final downloadedFile = File(localPdfs.first.localPath!);
      expect(await downloadedFile.exists(), isTrue);
    });

    test('handles local folder moves by deleting old remote path and uploading to new path', () async {
      final pdfsDir = await storageService.getPdfsDirectory();
      final localPdfFile = File('${pdfsDir.path}/refactoring.pdf');
      await localPdfFile.writeAsBytes(validPdfBytes);

      final now = DateTime.now();
      await pdfRepo.savePdf(
        PdfItem(
          id: 'pdf-move-1',
          title: 'Refactoring',
          fileName: 'Refactoring.pdf',
          localPath: localPdfFile.path,
          fileSize: validPdfBytes.length,
          source: 'local',
          createdAt: now,
          updatedAt: now,
        ),
      );

      // First sync uploads to root
      await engine.syncLibrary();
      expect(mockApi.remoteFiles.containsKey('Refactoring.pdf'), isTrue);

      // Now create folder 'Design' and move the PDF locally
      final folderId = 'folder-design';
      await folderRepo.createFolder(
        FolderItem(id: folderId, name: 'Design', createdAt: now, updatedAt: now),
      );
      await pdfRepo.moveToFolder('pdf-move-1', folderId);

      // Re-sync
      final moveResult = await engine.syncLibrary();
      expect(moveResult.uploadedCount, equals(1));
      expect(mockApi.deletedPaths, contains('Refactoring.pdf'));
      expect(mockApi.remoteFiles.containsKey('Design/Refactoring.pdf'), isTrue);

      final updatedMeta = await gitHubRepo.getSyncMetadataForPdf('pdf-move-1');
      expect(updatedMeta?.remotePath, equals('Design/Refactoring.pdf'));
    });

    test('remote deletion safety: does NOT delete local PDF when file is missing from remote', () async {
      final pdfsDir = await storageService.getPdfsDirectory();
      final localPdfFile = File('${pdfsDir.path}/safe.pdf');
      await localPdfFile.writeAsBytes(validPdfBytes);

      final now = DateTime.now();
      await pdfRepo.savePdf(
        PdfItem(
          id: 'pdf-safe',
          title: 'Safe Book',
          fileName: 'Safe.pdf',
          localPath: localPdfFile.path,
          fileSize: validPdfBytes.length,
          source: 'local',
          createdAt: now,
          updatedAt: now,
        ),
      );

      // First sync
      await engine.syncLibrary();
      expect(mockApi.remoteFiles.containsKey('Safe.pdf'), isTrue);

      // Simulate remote deletion on GitHub by another client
      mockApi.remoteFiles.remove('Safe.pdf');
      mockApi.remoteShas.remove('Safe.pdf');

      // Sync again
      final syncResult = await engine.syncLibrary();
      expect(syncResult.errorCount, equals(0));

      // Local file and SQLite record MUST STILL EXIST!
      final localPdf = await pdfRepo.getPdfById('pdf-safe');
      expect(localPdf, isNotNull);
      expect(await localPdfFile.exists(), isTrue);

      // Metadata marked as upload_pending to keep local safe
      final meta = await gitHubRepo.getSyncMetadataForPdf('pdf-safe');
      expect(meta?.syncStatus, equals(SyncStatus.uploadPending));
    });

    test('conflict handling: flags conflict when modified both locally and on GitHub', () async {
      final pdfsDir = await storageService.getPdfsDirectory();
      final localPdfFile = File('${pdfsDir.path}/conflict.pdf');
      await localPdfFile.writeAsBytes(validPdfBytes);

      final now = DateTime.now();
      await pdfRepo.savePdf(
        PdfItem(
          id: 'pdf-conflict',
          title: 'Conflict Book',
          fileName: 'Conflict.pdf',
          localPath: localPdfFile.path,
          fileSize: validPdfBytes.length,
          source: 'local',
          createdAt: now,
          updatedAt: now,
        ),
      );

      // First sync
      await engine.syncLibrary();

      // Modify local file
      await localPdfFile.writeAsBytes([...validPdfBytes, 0x99, 0x88]);

      // Modify remote SHA
      mockApi.remoteShas['Conflict.pdf'] = 'sha-diverged-from-remote';

      // Sync
      final result = await engine.syncLibrary();
      expect(result.conflictCount, equals(1));

      final meta = await gitHubRepo.getSyncMetadataForPdf('pdf-conflict');
      expect(meta?.syncStatus, equals(SyncStatus.conflict));
    });

    test('processes pending delete: deletes file on GitHub and removes metadata', () async {
      final now = DateTime.now();
      mockApi.remoteFiles['DeleteMe.pdf'] = validPdfBytes;
      mockApi.remoteShas['DeleteMe.pdf'] = 'sha-delete-123';

      await gitHubRepo.saveSyncMetadata(
        SyncMetadataItem(
          id: 'meta-delete-1',
          pdfId: 'pdf-deleted-locally',
          repositoryId: 'repo-1',
          remotePath: 'DeleteMe.pdf',
          remoteSha: 'sha-delete-123',
          syncStatus: SyncStatus.deletePending,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final result = await engine.syncLibrary();
      expect(result.deletedCount, equals(1));
      expect(mockApi.deletedPaths, contains('DeleteMe.pdf'));
      expect(mockApi.remoteFiles.containsKey('DeleteMe.pdf'), isFalse);

      final meta = await gitHubRepo.getSyncMetadataForPdf('pdf-deleted-locally');
      expect(meta, isNull);
    });
  });
}
