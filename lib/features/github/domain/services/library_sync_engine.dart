// ignore_for_file: prefer_initializing_formals

import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../../../core/services/default_pdf_thumbnail_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/pdf_file_service.dart';
import '../../../../core/storage/pdf_storage_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../folders/data/repositories/folder_repository.dart';
import '../../../library/data/repositories/pdf_repository.dart';
import '../../../library/domain/models/pdf_item.dart';
import '../../data/datasources/github_api_client.dart';
import '../../data/datasources/github_token_storage.dart';
import '../../data/models/github_tree_dto.dart';
import '../exceptions/github_exception.dart';
import '../models/sync_metadata_item.dart';
import '../models/sync_result.dart';
import '../models/sync_status.dart';
import '../repositories/github_repository.dart';
import 'folder_path_resolver.dart';

class LibrarySyncEngine {
  final IGitHubApiClient _apiClient;
  final IGitHubTokenStorage _tokenStorage;
  final GitHubRepository _gitHubRepository;
  final PdfRepository _pdfRepository;
  final FolderRepository _folderRepository;
  final LocalStorageService _storageService;
  final PdfFileService _fileService;
  final DefaultPdfThumbnailService _thumbnailService;
  final PdfStorageService? _pdfStorage;
  final Uuid _uuid = const Uuid();

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  LibrarySyncEngine({
    required IGitHubApiClient apiClient,
    required IGitHubTokenStorage tokenStorage,
    required GitHubRepository gitHubRepository,
    required PdfRepository pdfRepository,
    required FolderRepository folderRepository,
    required LocalStorageService storageService,
    required PdfFileService fileService,
    required DefaultPdfThumbnailService thumbnailService,
    PdfStorageService? pdfStorage,
  })  : _apiClient = apiClient,
        _tokenStorage = tokenStorage,
        _gitHubRepository = gitHubRepository,
        _pdfRepository = pdfRepository,
        _folderRepository = folderRepository,
        _storageService = storageService,
        _fileService = fileService,
        _thumbnailService = thumbnailService,
        _pdfStorage = pdfStorage;

  /// Executes a full, two-way, idempotent synchronization between the local Libora
  /// library and the connected GitHub repository.
  Future<SyncResult> syncLibrary({
    void Function(SyncProgress progress)? onProgress,
  }) async {
    if (_isSyncing) {
      AppLogger.info('Sync already in progress, skipping request.', tag: 'LibrarySyncEngine');
      return const SyncResult(
        errors: ['Sync already in progress'],
      );
    }

    _isSyncing = true;
    onProgress?.call(const SyncProgress(message: 'Initializing sync...'));

    try {
      final token = await _tokenStorage.getToken();
      if (token == null || token.isEmpty) {
        throw const GitHubAuthException('No GitHub Personal Access Token configured.');
      }

      final activeRepo = await _gitHubRepository.getSelectedRepository();
      if (activeRepo == null) {
        throw const GitHubNotFoundException('No active GitHub repository selected.');
      }

      onProgress?.call(const SyncProgress(message: 'Fetching remote repository state...'));
      final remoteTree = await _apiClient.fetchRepositoryTree(
        owner: activeRepo.owner,
        repo: activeRepo.name,
        branch: activeRepo.defaultBranch,
        token: token,
      );

      final remotePdfBlobs = remoteTree.pdfBlobs;
      final remoteBlobsByPath = <String, GitHubTreeItemDto>{
        for (final blob in remotePdfBlobs)
          FolderPathResolver.normalizePath(blob.path): blob,
      };

      // Load local state
      onProgress?.call(const SyncProgress(message: 'Reading local library...'));
      final localPdfs = await _pdfRepository.getAllPdfs();
      final localPdfsById = <String, PdfItem>{for (final p in localPdfs) p.id: p};
      final allFolders = await _folderRepository.getAllFolders();
      final existingMetadata = await _gitHubRepository.getAllSyncMetadata(activeRepo.id);
      final metadataByPdfId = <String, SyncMetadataItem>{
        for (final m in existingMetadata) m.pdfId: m,
      };
      final metadataByRemotePath = <String, SyncMetadataItem>{
        for (final m in existingMetadata) m.remotePath: m,
      };

      int uploadedCount = 0;
      int downloadedCount = 0;
      int deletedCount = 0;
      int conflictCount = 0;
      int errorCount = 0;
      final errors = <String>[];
      final conflictedPdfIds = <String>{};

      final totalOperations = localPdfs.length + remotePdfBlobs.length;
      int processedOperations = 0;

      // -------------------------------------------------------------
      // Step 1: Process Local Pending Deletions
      // -------------------------------------------------------------
      for (final meta in existingMetadata) {
        if (meta.syncStatus == SyncStatus.deletePending) {
          final remoteBlob = remoteBlobsByPath[meta.remotePath];
          if (remoteBlob != null) {
            try {
              onProgress?.call(
                SyncProgress(
                  message: 'Deleting remote file ${meta.remotePath}...',
                  completedItems: processedOperations,
                  totalItems: totalOperations,
                ),
              );
              await _apiClient.deleteFile(
                owner: activeRepo.owner,
                repo: activeRepo.name,
                path: meta.remotePath,
                sha: remoteBlob.sha,
                message: 'Delete ${FolderPathResolver.extractFileName(meta.remotePath)} from Libora',
                branch: activeRepo.defaultBranch,
                token: token,
              );
              deletedCount++;
              remoteBlobsByPath.remove(meta.remotePath);
            } catch (e) {
              AppLogger.error('Failed to delete remote file ${meta.remotePath}: $e', tag: 'LibrarySyncEngine');
              errors.add('Failed to delete remote file: ${meta.remotePath}');
              errorCount++;
            }
          }
          await _gitHubRepository.deleteSyncMetadataForPdf(meta.pdfId);
        }
      }

      // -------------------------------------------------------------
      // Step 2: Sync Local PDFs to Remote (Uploads & Updates)
      // -------------------------------------------------------------
      for (final pdf in localPdfs) {
        processedOperations++;
        final expectedRemotePath = FolderPathResolver.resolveRemotePath(
          folderId: pdf.folderId,
          fileName: pdf.fileName,
          allFolders: allFolders,
        );

        final meta = metadataByPdfId[pdf.id];
        Uint8List? fileBytes;
        if (_pdfStorage != null && await _pdfStorage.exists(pdf.id)) {
          fileBytes = await _pdfStorage.readPdf(pdf.id);
        } else if (!kIsWeb && pdf.localPath != null) {
          final file = File(pdf.localPath!);
          if (await file.exists()) {
            fileBytes = await file.readAsBytes();
          }
        }

        if (fileBytes == null) {
          AppLogger.warning('Local file content missing for PDF ${pdf.id}', tag: 'LibrarySyncEngine');
          continue;
        }

        final currentFileHash = sha256.convert(fileBytes).toString();

        // Check if path changed (PDF moved to another folder or renamed)
        final oldRemotePath = meta?.remotePath;
        final pathChanged = oldRemotePath != null && oldRemotePath != expectedRemotePath;

        if (pathChanged) {
          // Delete old remote path if it exists
          final oldRemoteBlob = remoteBlobsByPath[oldRemotePath];
          if (oldRemoteBlob != null) {
            try {
              await _apiClient.deleteFile(
                owner: activeRepo.owner,
                repo: activeRepo.name,
                path: oldRemotePath,
                sha: oldRemoteBlob.sha,
                message: 'Move ${pdf.fileName} to $expectedRemotePath',
                branch: activeRepo.defaultBranch,
                token: token,
              );
              remoteBlobsByPath.remove(oldRemotePath);
            } catch (e) {
              AppLogger.warning('Failed to delete old remote path $oldRemotePath: $e', tag: 'LibrarySyncEngine');
            }
          }
        }

        final remoteBlobAtExpected = remoteBlobsByPath[expectedRemotePath];

        // Determine if upload is required
        final isNeverSynced = meta == null;
        final isUploadPending = meta?.syncStatus == SyncStatus.uploadPending;
        final localContentChanged = meta != null && meta.localHash != currentFileHash;
        final remoteMissing = remoteBlobAtExpected == null;

        if (isNeverSynced || isUploadPending || localContentChanged || pathChanged || remoteMissing) {
          // Conflict check: if remote file already exists with different sha, and local file was modified locally
          if (remoteBlobAtExpected != null && meta != null && meta.remoteSha != null &&
              remoteBlobAtExpected.sha != meta.remoteSha && localContentChanged) {
            AppLogger.warning('Conflict detected for $expectedRemotePath: both local and remote changed', tag: 'LibrarySyncEngine');
            await _gitHubRepository.updateSyncStatus(
              meta.id,
              SyncStatus.conflict,
              lastError: 'Conflict: modified both locally and on GitHub',
            );
            conflictCount++;
            conflictedPdfIds.add(pdf.id);
            continue;
          }

          if (fileBytes.length > 100 * 1024 * 1024) {
            AppLogger.error('PDF exceeds 100MB limit: ${pdf.fileName}', tag: 'LibrarySyncEngine');
            errors.add('File "${pdf.fileName}" exceeds GitHub 100MB file limit.');
            errorCount++;
            if (meta != null) {
              await _gitHubRepository.updateSyncStatus(
                meta.id,
                SyncStatus.error,
                lastError: 'File exceeds GitHub 100MB size limit',
              );
            }
            continue;
          }

          try {
            onProgress?.call(
              SyncProgress(
                message: 'Uploading ${pdf.fileName}...',
                completedItems: processedOperations,
                totalItems: totalOperations,
                percentage: processedOperations / (totalOperations == 0 ? 1 : totalOperations),
              ),
            );

            final uploadResult = await _apiClient.uploadFile(
              owner: activeRepo.owner,
              repo: activeRepo.name,
              path: expectedRemotePath,
              contentBytes: fileBytes,
              message: pathChanged
                  ? 'Move ${pdf.fileName} to $expectedRemotePath'
                  : 'Sync ${pdf.fileName} from Libora',
              branch: activeRepo.defaultBranch,
              sha: remoteBlobAtExpected?.sha,
              token: token,
            );

            final contentInfo = uploadResult['content'] as Map<String, dynamic>?;
            final newSha = contentInfo?['sha'] as String? ?? remoteBlobAtExpected?.sha;

            final now = DateTime.now();
            final updatedMetadata = SyncMetadataItem(
              id: meta?.id ?? _uuid.v4(),
              pdfId: pdf.id,
              repositoryId: activeRepo.id,
              remotePath: expectedRemotePath,
              remoteSha: newSha,
              remoteSize: fileBytes.length,
              localHash: currentFileHash,
              lastSyncedAt: now,
              syncStatus: SyncStatus.synced,
              createdAt: meta?.createdAt ?? now,
              updatedAt: now,
            );

            await _gitHubRepository.saveSyncMetadata(updatedMetadata);
            uploadedCount++;

            // If local PDF hash in DB was outdated, update it
            if (pdf.fileHash != currentFileHash) {
              await _pdfRepository.savePdf(pdf.copyWith(fileHash: currentFileHash));
            }
          } catch (e) {
            AppLogger.error('Failed to upload ${pdf.fileName}: $e', tag: 'LibrarySyncEngine');
            errors.add('Failed to upload ${pdf.fileName}: $e');
            errorCount++;

            if (meta != null) {
              await _gitHubRepository.updateSyncStatus(
                meta.id,
                SyncStatus.uploadPending,
                lastError: e.toString(),
              );
            } else {
              await _gitHubRepository.saveSyncMetadata(
                SyncMetadataItem(
                  id: _uuid.v4(),
                  pdfId: pdf.id,
                  repositoryId: activeRepo.id,
                  remotePath: expectedRemotePath,
                  localHash: currentFileHash,
                  syncStatus: SyncStatus.uploadPending,
                  lastError: e.toString(),
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
              );
            }
          }
        } else {
          // File is already in sync; ensure metadata status is synced
          if (meta.syncStatus != SyncStatus.synced) {
            await _gitHubRepository.updateSyncStatus(meta.id, SyncStatus.synced);
          }
        }
      }

      // -------------------------------------------------------------
      // Step 3: Sync Remote Additions & Updates to Local (Downloads)
      // -------------------------------------------------------------
      for (final remoteBlob in remoteBlobsByPath.values) {
        processedOperations++;
        final remotePath = FolderPathResolver.normalizePath(remoteBlob.path);
        final meta = metadataByRemotePath[remotePath];

        if (meta != null && localPdfsById.containsKey(meta.pdfId)) {
          if (conflictedPdfIds.contains(meta.pdfId)) continue;
          // Already synced in the past; check if remote changed
          if (meta.remoteSha != remoteBlob.sha) {
            final localPdf = localPdfsById[meta.pdfId]!;
            Uint8List? localBytes;
            if (_pdfStorage != null && await _pdfStorage.exists(localPdf.id)) {
              localBytes = await _pdfStorage.readPdf(localPdf.id);
            } else if (!kIsWeb && localPdf.localPath != null) {
              final localFile = File(localPdf.localPath!);
              if (await localFile.exists()) {
                localBytes = await localFile.readAsBytes();
              }
            }
            final localHash = localBytes != null ? sha256.convert(localBytes).toString() : null;

            if (localHash != null && localHash != meta.localHash) {
              // Both modified -> CONFLICT
              AppLogger.warning('Conflict detected for $remotePath: both local and remote changed', tag: 'LibrarySyncEngine');
              await _gitHubRepository.updateSyncStatus(
                meta.id,
                SyncStatus.conflict,
                lastError: 'Conflict: modified both locally and on GitHub',
              );
              conflictCount++;
              continue;
            }

            // Remote modified, local untouched -> download updated version
            try {
              onProgress?.call(
                SyncProgress(
                  message: 'Downloading updated ${FolderPathResolver.extractFileName(remotePath)}...',
                  completedItems: processedOperations,
                  totalItems: totalOperations,
                ),
              );

              final rawBytes = await _apiClient.downloadFileBytes(
                owner: activeRepo.owner,
                repo: activeRepo.name,
                path: remotePath,
                branch: activeRepo.defaultBranch,
                token: token,
              );
              final downloadedBytes = Uint8List.fromList(rawBytes);

              if (_pdfStorage != null) {
                await _pdfStorage.savePdf(
                  id: localPdf.id,
                  bytes: downloadedBytes,
                  fileName: localPdf.fileName,
                );
              }
              if (!kIsWeb && localPdf.localPath != null) {
                final localFile = File(localPdf.localPath!);
                await localFile.writeAsBytes(downloadedBytes);
              }
              final newLocalHash = sha256.convert(downloadedBytes).toString();

              final updatedMetadata = meta.copyWith(
                remoteSha: remoteBlob.sha,
                remoteSize: downloadedBytes.length,
                localHash: newLocalHash,
                lastSyncedAt: DateTime.now(),
                syncStatus: SyncStatus.synced,
                updatedAt: DateTime.now(),
              );
              await _gitHubRepository.saveSyncMetadata(updatedMetadata);
              await _pdfRepository.savePdf(localPdf.copyWith(
                fileHash: newLocalHash,
                fileSize: downloadedBytes.length,
                updatedAt: DateTime.now(),
              ));
              downloadedCount++;
            } catch (e) {
              AppLogger.error('Failed to download update for $remotePath: $e', tag: 'LibrarySyncEngine');
              errors.add('Failed to download update for $remotePath: $e');
              errorCount++;
            }
          }
        } else if (meta == null) {
          // Brand new remote file!
          try {
            final fileName = FolderPathResolver.extractFileName(remotePath);
            onProgress?.call(
              SyncProgress(
                message: 'Downloading new file $fileName...',
                completedItems: processedOperations,
                totalItems: totalOperations,
              ),
            );

            final rawDownloaded = await _apiClient.downloadFileBytes(
              owner: activeRepo.owner,
              repo: activeRepo.name,
              path: remotePath,
              branch: activeRepo.defaultBranch,
              token: token,
            );
            final downloadedBytes = Uint8List.fromList(rawDownloaded);

            // Validate PDF header
            if (downloadedBytes.length < 5 ||
                downloadedBytes[0] != 0x25 ||
                downloadedBytes[1] != 0x50 ||
                downloadedBytes[2] != 0x44 ||
                downloadedBytes[3] != 0x46 ||
                downloadedBytes[4] != 0x2D) {
              AppLogger.warning('Downloaded file is not a valid PDF: $remotePath', tag: 'LibrarySyncEngine');
              continue;
            }

            final newPdfId = _uuid.v4();
            String? targetFilePath;
            String? targetCoverPath;

            if (_pdfStorage != null) {
              await _pdfStorage.savePdf(
                id: newPdfId,
                bytes: downloadedBytes,
                fileName: fileName,
              );
              targetFilePath = await _pdfStorage.getFilePath(newPdfId);
            } else if (!kIsWeb) {
              final pdfsDir = await _storageService.getPdfsDirectory();
              targetFilePath = p.join(pdfsDir.path, '$newPdfId.pdf');
              final newFile = File(targetFilePath);
              await newFile.writeAsBytes(downloadedBytes);
            }

            final fileHash = sha256.convert(downloadedBytes).toString();

            // Resolve folder hierarchy
            final targetFolderId = await FolderPathResolver.resolveLocalFolderId(
              remotePath: remotePath,
              folderRepo: _folderRepository,
            );

            final metaInfo = await _fileService.extractMetadataFromBytes(
              downloadedBytes,
              originalFileName: fileName,
            );

            // Generate thumbnail
            final coverBytes = await _thumbnailService.generateCoverBytes(
              pdfBytes: downloadedBytes,
            );
            if (coverBytes != null) {
              if (_pdfStorage != null) {
                await _pdfStorage.saveCover(id: newPdfId, bytes: coverBytes);
                targetCoverPath = await _pdfStorage.getCoverPath(newPdfId);
              } else if (!kIsWeb) {
                final coversDir = await _storageService.getCoversDirectory();
                targetCoverPath = p.join(coversDir.path, '$newPdfId.jpg');
                final coverFile = File(targetCoverPath);
                await coverFile.writeAsBytes(coverBytes);
              }
            }

            final now = DateTime.now();
            final newPdfItem = PdfItem(
              id: newPdfId,
              title: metaInfo.title,
              fileName: fileName,
              localPath: targetFilePath,
              coverPath: targetCoverPath,
              pageCount: metaInfo.pageCount > 0 ? metaInfo.pageCount : null,
              fileSize: downloadedBytes.length,
              folderId: targetFolderId,
              source: 'github',
              isFavorite: false,
              currentPage: 0,
              createdAt: now,
              updatedAt: now,
              fileHash: fileHash,
            );

            await _pdfRepository.savePdf(newPdfItem);

            final newMeta = SyncMetadataItem(
              id: _uuid.v4(),
              pdfId: newPdfId,
              repositoryId: activeRepo.id,
              remotePath: remotePath,
              remoteSha: remoteBlob.sha,
              remoteSize: downloadedBytes.length,
              localHash: fileHash,
              lastSyncedAt: now,
              syncStatus: SyncStatus.synced,
              createdAt: now,
              updatedAt: now,
            );
            await _gitHubRepository.saveSyncMetadata(newMeta);
            downloadedCount++;
          } catch (e) {
            AppLogger.error('Failed to download new remote file $remotePath: $e', tag: 'LibrarySyncEngine');
            errors.add('Failed to download $remotePath: $e');
            errorCount++;
          }
        }
      }

      // -------------------------------------------------------------
      // Step 4: Handle Remote Deletions (Files deleted remotely)
      // -------------------------------------------------------------
      for (final meta in existingMetadata) {
        if (meta.syncStatus == SyncStatus.synced) {
          if (!remoteBlobsByPath.containsKey(meta.remotePath)) {
            // File was deleted on remote. Local-first safety: do NOT delete local file.
            // Mark as upload_pending or detach from remote.
            AppLogger.info('Remote file was deleted for ${meta.remotePath}; keeping local file safe.', tag: 'LibrarySyncEngine');
            await _gitHubRepository.updateSyncStatus(
              meta.id,
              SyncStatus.uploadPending,
              lastError: 'Remote file was deleted on GitHub. Marked for local re-upload or unlinked.',
            );
          }
        }
      }

      // Update active repository lastSyncedAt and headSha
      final finishTime = DateTime.now();
      await _gitHubRepository.updateRepositorySyncTime(
        activeRepo.id,
        finishTime,
        headSha: remoteTree.sha.isNotEmpty ? remoteTree.sha : null,
      );

      onProgress?.call(
        SyncProgress(
          message: 'Sync completed successfully.',
          completedItems: totalOperations,
          totalItems: totalOperations,
          percentage: 1.0,
        ),
      );

      AppLogger.info(
        'Library sync completed: $uploadedCount uploaded, $downloadedCount downloaded, $deletedCount deleted, $conflictCount conflicts, $errorCount errors',
        tag: 'LibrarySyncEngine',
      );

      return SyncResult(
        uploadedCount: uploadedCount,
        downloadedCount: downloadedCount,
        deletedCount: deletedCount,
        conflictCount: conflictCount,
        errorCount: errorCount,
        errors: errors,
      );
    } catch (e, stack) {
      AppLogger.error('Sync failed with error: $e', error: e, stackTrace: stack, tag: 'LibrarySyncEngine');
      rethrow;
    } finally {
      _isSyncing = false;
    }
  }
}
