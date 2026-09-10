import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/app_logger.dart';
import '../../data/datasources/github_api_client.dart';
import '../../data/datasources/github_token_storage.dart';
import '../../domain/exceptions/github_exception.dart';
import '../../domain/models/github_account.dart';
import '../../domain/models/github_repository_item.dart';
import 'github_providers.dart';

class GitHubConnectionState {
  final bool isConnected;
  final bool isLoading;
  final GitHubAccount? account;
  final String? errorMessage;

  const GitHubConnectionState({
    this.isConnected = false,
    this.isLoading = false,
    this.account,
    this.errorMessage,
  });

  GitHubConnectionState copyWith({
    bool? isConnected,
    bool? isLoading,
    GitHubAccount? account,
    String? errorMessage,
    bool clearError = false,
  }) {
    return GitHubConnectionState(
      isConnected: isConnected ?? this.isConnected,
      isLoading: isLoading ?? this.isLoading,
      account: account ?? this.account,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class GitHubConnectionController extends Notifier<GitHubConnectionState> {
  late IGitHubTokenStorage _tokenStorage;
  late IGitHubApiClient _apiClient;
  late GitHubRepository _repository;
  final Uuid _uuid = const Uuid();

  @override
  GitHubConnectionState build() {
    _tokenStorage = ref.watch(gitHubTokenStorageProvider);
    _apiClient = ref.watch(gitHubApiClientProvider);
    _repository = ref.watch(gitHubRepositoryProvider);

    _init();

    return const GitHubConnectionState(isLoading: true);
  }

  Future<void> _init() async {
    try {
      final hasToken = await _tokenStorage.hasToken();
      if (!ref.mounted) return;
      final account = await _repository.getAccount();
      if (!ref.mounted) return;

      if (hasToken && account != null) {
        state = state.copyWith(
          isConnected: true,
          isLoading: false,
          account: account,
          clearError: true,
        );
      } else {
        state = state.copyWith(
          isConnected: false,
          isLoading: false,
          account: null,
          clearError: true,
        );
      }
    } catch (e, stack) {
      if (!ref.mounted) return;
      AppLogger.error('Failed to init GitHub connection state: $e', error: e, stackTrace: stack, tag: 'GitHubConnectionController');
      state = state.copyWith(
        isConnected: false,
        isLoading: false,
        errorMessage: 'Failed to restore connection status',
      );
    }
  }

  Future<bool> connectWithToken(String rawToken) async {
    final token = rawToken.trim();
    if (token.isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter a valid GitHub token.');
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      AppLogger.info('Validating GitHub PAT...', tag: 'GitHubConnectionController');
      final userDto = await _apiClient.validateToken(token);

      // Save token securely
      await _tokenStorage.saveToken(token);

      final now = DateTime.now();
      final account = GitHubAccount(
        id: _uuid.v4(),
        githubUserId: userDto.id.toString(),
        login: userDto.login,
        name: userDto.name,
        avatarUrl: userDto.avatarUrl,
        createdAt: now,
        updatedAt: now,
      );

      await _repository.saveAccount(account);

      // Fetch user repos to populate initial list
      try {
        final repos = await _apiClient.fetchUserRepositories(token);
        for (final r in repos) {
          final repoItem = GitHubRepositoryItem(
            id: _uuid.v4(),
            githubRepoId: r.id.toString(),
            owner: r.owner,
            name: r.name,
            fullName: r.fullName,
            defaultBranch: r.defaultBranch,
            isPrivate: r.isPrivate,
            createdAt: now,
            updatedAt: now,
          );
          await _repository.saveRepository(repoItem);
        }

        // Auto-select first repo if none selected
        final selected = await _repository.getSelectedRepository();
        if (selected == null && repos.isNotEmpty) {
          final allSaved = await _repository.getAllRepositories();
          if (allSaved.isNotEmpty) {
            await _repository.selectRepository(allSaved.first.id);
          }
        }
      } catch (e) {
        AppLogger.warning('Failed to fetch repos after token connection: $e', tag: 'GitHubConnectionController');
      }

      state = state.copyWith(
        isConnected: true,
        isLoading: false,
        account: account,
        clearError: true,
      );
      return true;
    } on GitHubAuthException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Invalid Personal Access Token. Please check token permissions (requires "repo" scope).',
      );
      return false;
    } on GitHubNetworkException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
      return false;
    } on GitHubRateLimitException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Connection failed: ${e.toString()}',
      );
      return false;
    }
  }

  Future<void> disconnect() async {
    state = state.copyWith(isLoading: true);
    try {
      await _tokenStorage.deleteToken();
      await _repository.deleteAccount();
      await _repository.clearAllRepositories();
      state = const GitHubConnectionState(
        isConnected: false,
        isLoading: false,
        account: null,
      );
      AppLogger.info('Disconnected from GitHub', tag: 'GitHubConnectionController');
    } catch (e, stack) {
      AppLogger.error('Failed to disconnect GitHub: $e', error: e, stackTrace: stack, tag: 'GitHubConnectionController');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to disconnect cleanly: $e',
      );
    }
  }
}

final gitHubConnectionControllerProvider =
    NotifierProvider<GitHubConnectionController, GitHubConnectionState>(() {
  return GitHubConnectionController();
});
