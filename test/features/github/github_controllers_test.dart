import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libora/core/services/default_pdf_file_service.dart';
import 'package:libora/core/services/default_pdf_thumbnail_service.dart';
import 'package:libora/database/app_database.dart';
import 'package:libora/features/github/data/datasources/github_api_client.dart';
import 'package:libora/features/github/data/models/github_repo_dto.dart';
import 'package:libora/features/github/data/models/github_tree_dto.dart';
import 'package:libora/features/github/data/models/github_user_dto.dart';
import 'package:libora/features/github/domain/exceptions/github_exception.dart';
import 'package:libora/features/github/domain/models/github_repository_item.dart';
import 'package:libora/features/github/presentation/controllers/github_connection_controller.dart';
import 'package:libora/features/github/presentation/controllers/github_providers.dart';
import 'package:libora/features/github/presentation/controllers/github_repository_controller.dart';
import 'package:libora/features/github/presentation/controllers/sync_controller.dart';

import '../../helpers/test_database.dart';
import 'library_sync_engine_test.dart';

class MockControllersApiClient implements IGitHubApiClient {
  bool shouldFailAuth = false;

  @override
  Future<GitHubUserDto> validateToken(String token) async {
    if (shouldFailAuth || token == 'ghp_invalid') {
      throw const GitHubAuthException();
    }
    return const GitHubUserDto(
      id: 999,
      login: 'solacode',
      name: 'Sola Code',
      avatarUrl: 'https://avatars.githubusercontent.com/u/999',
    );
  }

  @override
  Future<List<GitHubRepoDto>> fetchUserRepositories(String token, {int page = 1, int perPage = 100}) async {
    return const [
      GitHubRepoDto(
        id: 101,
        name: 'my-books',
        fullName: 'solacode/my-books',
        owner: 'solacode',
        isPrivate: true,
        defaultBranch: 'main',
      ),
      GitHubRepoDto(
        id: 102,
        name: 'papers',
        fullName: 'solacode/papers',
        owner: 'solacode',
        isPrivate: false,
        defaultBranch: 'master',
      ),
    ];
  }

  @override
  Future<GitHubTreeDto> fetchRepositoryTree({
    required String owner,
    required String repo,
    required String branch,
    required String token,
  }) async =>
      const GitHubTreeDto(sha: 'head-sha-1', tree: []);

  @override
  Future<List<int>> downloadFileBytes({
    required String owner,
    required String repo,
    required String path,
    required String branch,
    required String token,
    void Function(int received, int total)? onProgress,
  }) async =>
      [];

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
  }) async =>
      {};

  @override
  Future<void> deleteFile({
    required String owner,
    required String repo,
    required String path,
    required String sha,
    required String message,
    required String branch,
    required String token,
  }) async {}
}

void main() {
  group('GitHub Controllers Tests', () {
    late AppDatabase db;
    late MockControllersApiClient mockApi;
    late MockTokenStorage mockTokenStorage;
    late ProviderContainer container;

    setUp(() {
      db = createTestDatabase();
      mockApi = MockControllersApiClient();
      mockTokenStorage = MockTokenStorage();
      mockTokenStorage.token = null;

      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          gitHubApiClientProvider.overrideWithValue(mockApi),
          gitHubTokenStorageProvider.overrideWithValue(mockTokenStorage),
          pdfFileServiceProvider.overrideWithValue(FakePdfFileService()),
          pdfThumbnailServiceProvider.overrideWithValue(FakeThumbnailService()),
        ],
      );
    });

    tearDown(() async {
      container.dispose();
      await db.close();
    });

    test('GitHubConnectionController connects with valid token and auto-selects repo', () async {
      final controller = container.read(gitHubConnectionControllerProvider.notifier);

      final success = await controller.connectWithToken('ghp_validToken123');
      expect(success, isTrue);

      final state = container.read(gitHubConnectionControllerProvider);
      expect(state.isConnected, isTrue);
      expect(state.account, isNotNull);
      expect(state.account?.login, equals('solacode'));
      expect(mockTokenStorage.token, equals('ghp_validToken123'));

      // Verify repositories were populated
      final repo = container.read(gitHubRepositoryProvider);
      final allRepos = await repo.getAllRepositories();
      expect(allRepos.length, equals(2));
      expect(allRepos.any((r) => r.isSelected), isTrue);
    });

    test('GitHubConnectionController fails on invalid token with error message', () async {
      final controller = container.read(gitHubConnectionControllerProvider.notifier);

      final success = await controller.connectWithToken('ghp_invalid');
      expect(success, isFalse);

      final state = container.read(gitHubConnectionControllerProvider);
      expect(state.isConnected, isFalse);
      expect(state.errorMessage, isNotNull);
      expect(mockTokenStorage.token, isNull);
    });

    test('GitHubConnectionController disconnects and clears credentials', () async {
      final controller = container.read(gitHubConnectionControllerProvider.notifier);
      await controller.connectWithToken('ghp_validToken123');

      expect(container.read(gitHubConnectionControllerProvider).isConnected, isTrue);

      await controller.disconnect();

      final state = container.read(gitHubConnectionControllerProvider);
      expect(state.isConnected, isFalse);
      expect(state.account, isNull);
      expect(mockTokenStorage.token, isNull);
    });

    test('GitHubRepositoryController selects repository', () async {
      final repo = container.read(gitHubRepositoryProvider);
      final now = DateTime.now();
      await repo.saveRepository(
        GitHubRepositoryItem(
          id: 'repo-a',
          owner: 'solacode',
          name: 'repo-a',
          fullName: 'solacode/repo-a',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await repo.saveRepository(
        GitHubRepositoryItem(
          id: 'repo-b',
          owner: 'solacode',
          name: 'repo-b',
          fullName: 'solacode/repo-b',
          createdAt: now,
          updatedAt: now,
        ),
      );

      final controller = container.read(gitHubRepositoryControllerProvider.notifier);
      await controller.selectRepository('repo-b');

      final selected = await repo.getSelectedRepository();
      expect(selected?.id, equals('repo-b'));
    });

    test('SyncController executes syncNow cleanly', () async {
      // Connect first
      final connectionCtrl = container.read(gitHubConnectionControllerProvider.notifier);
      await connectionCtrl.connectWithToken('ghp_validToken123');

      final syncCtrl = container.read(syncControllerProvider.notifier);
      final result = await syncCtrl.syncNow();

      expect(result, isNotNull);
      expect(result?.isSuccess, isTrue);

      final syncState = container.read(syncControllerProvider);
      expect(syncState.status, equals(OverallSyncStatus.synced));
      expect(syncState.lastSyncedAt, isNotNull);
    });
  });
}
