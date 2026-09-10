import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/default_pdf_file_service.dart';
import '../../../../core/services/default_pdf_thumbnail_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/storage/pdf_storage_provider.dart';
import '../../../folders/data/repositories/folder_repository.dart';
import '../../../library/data/repositories/pdf_repository.dart';
import '../../data/datasources/github_api_client.dart';
import '../../data/datasources/github_token_storage.dart';
import '../../data/repositories/drift_github_repository.dart';
import '../../domain/models/github_account.dart';
import '../../domain/models/github_repository_item.dart';
import '../../domain/models/sync_metadata_item.dart';
import '../../domain/services/library_sync_engine.dart';

export '../../data/repositories/drift_github_repository.dart';
export '../../domain/repositories/github_repository.dart';

final gitHubTokenStorageProvider = Provider<IGitHubTokenStorage>((ref) {
  return GitHubTokenStorage();
});

final gitHubApiClientProvider = Provider<IGitHubApiClient>((ref) {
  return GitHubApiClient();
});

final librarySyncEngineProvider = Provider<LibrarySyncEngine>((ref) {
  return LibrarySyncEngine(
    apiClient: ref.watch(gitHubApiClientProvider),
    tokenStorage: ref.watch(gitHubTokenStorageProvider),
    gitHubRepository: ref.watch(gitHubRepositoryProvider),
    pdfRepository: ref.watch(pdfRepositoryProvider),
    folderRepository: ref.watch(folderRepositoryProvider),
    storageService: ref.watch(storageServiceProvider),
    fileService: ref.watch(pdfFileServiceProvider),
    thumbnailService: ref.watch(pdfThumbnailServiceProvider),
    pdfStorage: ref.watch(pdfStorageServiceProvider),
  );
});

final gitHubAccountStreamProvider = StreamProvider<GitHubAccount?>((ref) {
  final repo = ref.watch(gitHubRepositoryProvider);
  return repo.watchAccount();
});

final gitHubSelectedRepoStreamProvider = StreamProvider<GitHubRepositoryItem?>((ref) {
  final repo = ref.watch(gitHubRepositoryProvider);
  return repo.watchSelectedRepository();
});

final gitHubAllReposStreamProvider = StreamProvider<List<GitHubRepositoryItem>>((ref) {
  final repo = ref.watch(gitHubRepositoryProvider);
  return repo.watchAllRepositories();
});

final gitHubSyncMetadataForPdfProvider = StreamProvider.family<SyncMetadataItem?, String>((ref, pdfId) {
  final repo = ref.watch(gitHubRepositoryProvider);
  return repo.watchSyncMetadataForPdf(pdfId);
});
