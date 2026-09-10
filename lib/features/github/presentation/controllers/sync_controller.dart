import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_logger.dart';
import '../../domain/exceptions/github_exception.dart';
import '../../domain/models/sync_result.dart';
import '../../domain/services/library_sync_engine.dart';
import 'github_providers.dart';

enum OverallSyncStatus {
  idle,
  syncing,
  synced,
  uploadPending,
  conflict,
  offline,
  error;

  bool get isSyncing => this == OverallSyncStatus.syncing;
  bool get isSynced => this == OverallSyncStatus.synced;
  bool get isOffline => this == OverallSyncStatus.offline;
  bool get isError => this == OverallSyncStatus.error;
}

class SyncState {
  final OverallSyncStatus status;
  final SyncProgress? progress;
  final SyncResult? lastResult;
  final DateTime? lastSyncedAt;
  final String? errorMessage;

  const SyncState({
    this.status = OverallSyncStatus.idle,
    this.progress,
    this.lastResult,
    this.lastSyncedAt,
    this.errorMessage,
  });

  SyncState copyWith({
    OverallSyncStatus? status,
    SyncProgress? progress,
    SyncResult? lastResult,
    DateTime? lastSyncedAt,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SyncState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      lastResult: lastResult ?? this.lastResult,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class SyncController extends Notifier<SyncState> {
  late LibrarySyncEngine _syncEngine;

  @override
  SyncState build() {
    _syncEngine = ref.watch(librarySyncEngineProvider);
    return const SyncState();
  }

  Future<SyncResult?> syncNow() async {
    if (state.status.isSyncing) return null;

    state = state.copyWith(
      status: OverallSyncStatus.syncing,
      progress: const SyncProgress(message: 'Starting sync...'),
      clearError: true,
    );

    try {
      final result = await _syncEngine.syncLibrary(
        onProgress: (progress) {
          state = state.copyWith(progress: progress);
        },
      );

      final now = DateTime.now();
      OverallSyncStatus finalStatus;
      if (result.conflictCount > 0) {
        finalStatus = OverallSyncStatus.conflict;
      } else if (result.errorCount > 0) {
        finalStatus = OverallSyncStatus.error;
      } else {
        finalStatus = OverallSyncStatus.synced;
      }

      state = state.copyWith(
        status: finalStatus,
        lastResult: result,
        lastSyncedAt: now,
        progress: null,
      );

      return result;
    } on GitHubNetworkException catch (e) {
      AppLogger.warning('Sync network failure (offline): $e', tag: 'SyncController');
      state = state.copyWith(
        status: OverallSyncStatus.offline,
        errorMessage: 'Offline: local changes queued for sync.',
        progress: null,
      );
      return null;
    } on GitHubAuthException catch (e) {
      AppLogger.error('Sync auth failure: $e', tag: 'SyncController');
      state = state.copyWith(
        status: OverallSyncStatus.error,
        errorMessage: e.message,
        progress: null,
      );
      return null;
    } catch (e, stack) {
      AppLogger.error('Sync failed unexpectedly: $e', error: e, stackTrace: stack, tag: 'SyncController');
      state = state.copyWith(
        status: OverallSyncStatus.error,
        errorMessage: 'Sync failed: $e',
        progress: null,
      );
      return null;
    }
  }
}

final syncControllerProvider = NotifierProvider<SyncController, SyncState>(() {
  return SyncController();
});
