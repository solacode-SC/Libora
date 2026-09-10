import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/app_logger.dart';
import '../../data/datasources/github_api_client.dart';
import '../../data/datasources/github_token_storage.dart';
import '../../domain/models/github_repository_item.dart';
import 'github_providers.dart';

class GitHubRepositoryState {
  final List<GitHubRepositoryItem> repositories;
  final GitHubRepositoryItem? selectedRepository;
  final bool isLoading;
  final String? errorMessage;

  const GitHubRepositoryState({
    this.repositories = const [],
    this.selectedRepository,
    this.isLoading = false,
    this.errorMessage,
  });

  GitHubRepositoryState copyWith({
    List<GitHubRepositoryItem>? repositories,
    GitHubRepositoryItem? selectedRepository,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool clearSelected = false,
  }) {
    return GitHubRepositoryState(
      repositories: repositories ?? this.repositories,
      selectedRepository: clearSelected ? null : (selectedRepository ?? this.selectedRepository),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class GitHubRepositoryController extends Notifier<GitHubRepositoryState> {
  late GitHubRepository _repository;
  late IGitHubApiClient _apiClient;
  late IGitHubTokenStorage _tokenStorage;
  final Uuid _uuid = const Uuid();

  @override
  GitHubRepositoryState build() {
    _repository = ref.watch(gitHubRepositoryProvider);
    _apiClient = ref.watch(gitHubApiClientProvider);
    _tokenStorage = ref.watch(gitHubTokenStorageProvider);

    _listenToDatabase();
    return const GitHubRepositoryState(isLoading: true);
  }

  void _listenToDatabase() {
    final sub = _repository.watchAllRepositories().listen((repos) {
      if (!ref.mounted) return;
      final selected = repos.where((r) => r.isSelected).firstOrNull;
      state = state.copyWith(
        repositories: repos,
        selectedRepository: selected,
        isLoading: false,
      );
    });
    ref.onDispose(sub.cancel);
  }

  Future<void> refreshRepositories() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final token = await _tokenStorage.getToken();
      if (token == null || token.isEmpty) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final remoteRepos = await _apiClient.fetchUserRepositories(token);
      final currentSelected = await _repository.getSelectedRepository();

      final now = DateTime.now();
      for (final r in remoteRepos) {
        final isCurrentlySelected = currentSelected?.fullName == r.fullName;
        final repoItem = GitHubRepositoryItem(
          id: _uuid.v4(),
          githubRepoId: r.id.toString(),
          owner: r.owner,
          name: r.name,
          fullName: r.fullName,
          defaultBranch: r.defaultBranch,
          isPrivate: r.isPrivate,
          isSelected: isCurrentlySelected,
          createdAt: now,
          updatedAt: now,
        );
        await _repository.saveRepository(repoItem);
      }

      state = state.copyWith(isLoading: false);
    } catch (e, stack) {
      AppLogger.error('Failed to refresh repositories from GitHub: $e', error: e, stackTrace: stack, tag: 'GitHubRepositoryController');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to refresh repositories: $e',
      );
    }
  }

  Future<void> selectRepository(String repoId) async {
    try {
      await _repository.selectRepository(repoId);
    } catch (e, stack) {
      AppLogger.error('Failed to select repository: $e', error: e, stackTrace: stack, tag: 'GitHubRepositoryController');
      state = state.copyWith(errorMessage: 'Failed to select repository.');
    }
  }
}

final gitHubRepositoryControllerProvider =
    NotifierProvider<GitHubRepositoryController, GitHubRepositoryState>(() {
  return GitHubRepositoryController();
});
