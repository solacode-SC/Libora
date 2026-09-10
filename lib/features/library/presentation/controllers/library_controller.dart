import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/storage/pdf_storage_provider.dart';
import '../../../../core/storage/pdf_storage_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/services/default_pdf_file_service.dart';
import '../../../../core/services/default_pdf_thumbnail_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../folders/data/repositories/folder_repository.dart';
import '../../../github/data/repositories/drift_github_repository.dart';
import '../../../github/domain/models/sync_status.dart';
import '../../../github/domain/repositories/github_repository.dart';
import '../../../github/presentation/controllers/sync_controller.dart';
import '../../data/repositories/pdf_repository.dart';
import '../../domain/models/pdf_item.dart';
import 'library_state.dart';

/// Riverpod Notifier managing the local PDF library state and workflows.
class LibraryController extends Notifier<LibraryState> {
  late PdfRepository _pdfRepository;
  late FolderRepository _folderRepository;
  late LocalStorageService _storageService;
  late PdfStorageService _pdfStorage;
  late DefaultPdfFileService _fileService;
  late DefaultPdfThumbnailService _thumbnailService;
  late GitHubRepository _gitHubRepository;
  final Uuid _uuid = const Uuid();

  StreamSubscription<List<PdfItem>>? _pdfsSub;
  StreamSubscription<dynamic>? _foldersSub;

  @override
  LibraryState build() {
    _pdfRepository = ref.watch(pdfRepositoryProvider);
    _folderRepository = ref.watch(folderRepositoryProvider);
    _storageService = ref.watch(storageServiceProvider);
    _pdfStorage = ref.watch(pdfStorageServiceProvider);
    _fileService = ref.watch(pdfFileServiceProvider);
    _thumbnailService = ref.watch(pdfThumbnailServiceProvider);
    _gitHubRepository = ref.watch(gitHubRepositoryProvider);

    _pdfsSub?.cancel();
    _foldersSub?.cancel();

    _pdfsSub = _pdfRepository.watchAllPdfs().listen((pdfs) {
      state = state.copyWith(allPdfs: pdfs, isLoading: false);
    });

    _foldersSub = _folderRepository.watchAllFolders().listen((folders) {
      state = state.copyWith(folders: folders);
    });

    _loadInitialData();

    ref.onDispose(() {
      _pdfsSub?.cancel();
      _foldersSub?.cancel();
    });

    return const LibraryState(isLoading: true);
  }

  /// Explicitly reloads all PDFs and folders directly from SQLite and updates state.
  Future<void> refresh() async {
    try {
      final pdfs = await _pdfRepository.getAllPdfs();
      final folders = await _folderRepository.getAllFolders();
      state = state.copyWith(allPdfs: pdfs, folders: folders, isLoading: false);
    } catch (e, stack) {
      AppLogger.error(
        'Failed to refresh library state: $e',
        error: e,
        stackTrace: stack,
      );
    }
  }

  Future<void> _loadInitialData() async {
    await refresh();
  }

  /// Prompts the user to pick one or more PDF files and imports them into Libora-managed storage.
  Future<void> importPdfs() async {
    try {
      AppLogger.info('Launching file picker for PDF import...');
      final pickedDocs = await _fileService.pickPdfs();
      if (pickedDocs.isEmpty) {
        AppLogger.info('No PDF files selected (cancelled or empty).');
        return;
      }

      state = state.copyWith(
        isImporting: true,
        importProgress: () => 'Importing 0 of ${pickedDocs.length}...',
        userNotice: () => null,
        errorMessage: () => null,
      );

      final duplicateNames = <String>[];
      int importedCount = 0;
      int invalidCount = 0;

      for (int i = 0; i < pickedDocs.length; i++) {
        final doc = pickedDocs[i];
        final fileName = doc.name;

        state = state.copyWith(
          importProgress: () =>
              'Importing ${i + 1} of ${pickedDocs.length}: $fileName...',
        );

        final isValid = _fileService.validateBytes(doc.bytes);
        if (!isValid) {
          AppLogger.warning('Skipping invalid PDF: $fileName');
          invalidCount++;
          continue;
        }

        final fileSize = doc.bytes.length;
        final hash = _fileService.computeBytesHash(doc.bytes);

        // Check for duplicate
        final duplicate = await _pdfRepository.findDuplicate(
          hash: hash,
          fileSize: fileSize,
          fileName: fileName,
        );

        if (duplicate != null) {
          AppLogger.info('Skipping duplicate PDF: $fileName');
          duplicateNames.add(fileName);
          continue;
        }

        final pdfId = _uuid.v4();

        // Save to PdfStorageService
        await _pdfStorage.savePdf(
          id: pdfId,
          bytes: doc.bytes,
          fileName: fileName,
        );

        final localPath = await _pdfStorage.getFilePath(pdfId);

        final metadata = await _fileService.extractMetadataFromBytes(
          doc.bytes,
          originalFileName: fileName,
        );

        // Generate cover thumbnail
        final coverBytes = await _thumbnailService.generateCoverBytes(
          pdfBytes: doc.bytes,
        );
        String? coverPath;
        if (coverBytes != null) {
          await _pdfStorage.saveCover(id: pdfId, bytes: coverBytes);
          coverPath = await _pdfStorage.getCoverPath(pdfId);
        }

        final now = DateTime.now();
        final pdfItem = PdfItem(
          id: pdfId,
          title: metadata.title,
          fileName: fileName,
          localPath: localPath,
          coverPath: coverPath,
          pageCount: metadata.pageCount > 0 ? metadata.pageCount : null,
          fileSize: fileSize,
          folderId: state.selectedFolderId,
          source: 'local',
          isFavorite: false,
          currentPage: 0,
          createdAt: now,
          updatedAt: now,
          fileHash: hash,
        );

        await _pdfRepository.savePdf(pdfItem);
        importedCount++;
        AppLogger.info('Successfully imported PDF: $fileName (id: $pdfId)');
      }

      String? notice;
      if (duplicateNames.isNotEmpty) {
        if (duplicateNames.length == 1) {
          notice = '"${duplicateNames.first}" is already in your library.';
        } else {
          notice = '${duplicateNames.length} duplicate files were skipped.';
        }
      } else if (invalidCount > 0) {
        notice =
            '$invalidCount file(s) could not be imported (not valid PDFs).';
      } else if (importedCount > 0) {
        if (importedCount == 1) {
          notice = 'Imported 1 document successfully.';
        } else {
          notice = 'Imported $importedCount documents successfully.';
        }
      }

      // Explicitly reload all PDFs directly from SQLite to guarantee immediate synchronization
      final latestPdfs = await _pdfRepository.getAllPdfs();

      state = state.copyWith(
        allPdfs: latestPdfs,
        isImporting: false,
        importProgress: () => null,
        userNotice: () => notice,
        selectedFilter: LibraryFilter.all,
        searchQuery: '',
      );

      // If GitHub repository is active, trigger background sync for new items
      if (importedCount > 0) {
        final activeRepo = await _gitHubRepository.getSelectedRepository();
        if (activeRepo != null) {
          unawaited(ref.read(syncControllerProvider.notifier).syncNow());
        }
      }
    } catch (e, stack) {
      AppLogger.error('Failed to import PDFs: $e', error: e, stackTrace: stack);
      state = state.copyWith(
        isImporting: false,
        importProgress: () => null,
        errorMessage: () => 'Failed to import PDFs: $e',
      );
    }
  }

  /// Removes a PDF from Libora, deleting its managed file, cached cover, and database entry.
  /// If [deleteFromRemote] is true, also marks remote file on GitHub for deletion and triggers sync.
  Future<void> deletePdf(String id, {bool deleteFromRemote = false}) async {
    try {
      await _pdfStorage.deletePdf(id);
      await _pdfStorage.deleteCover(id);

      final pdf = await _pdfRepository.getPdfById(id);
      if (pdf != null && !kIsWeb) {
        await _storageService.deleteManagedFile(pdf.localPath);
        await _storageService.deleteManagedFile(pdf.coverPath);
      }

      if (deleteFromRemote) {
        final existingMeta = await _gitHubRepository.getSyncMetadataForPdf(id);
        if (existingMeta != null) {
          await _gitHubRepository.updateSyncStatus(
            existingMeta.id,
            SyncStatus.deletePending,
          );
          unawaited(ref.read(syncControllerProvider.notifier).syncNow());
        }
      } else {
        await _gitHubRepository.deleteSyncMetadataForPdf(id);
      }

      await _pdfRepository.deletePdf(id);
      await refresh();
    } catch (e) {
      state = state.copyWith(
        errorMessage: () => 'Failed to remove document: $e',
      );
    }
  }

  /// Toggles favorite status for a document.
  Future<void> toggleFavorite(String id) async {
    final pdf = state.allPdfs.firstWhere(
      (p) => p.id == id,
      orElse: () => throw StateError('PDF not found'),
    );
    await _pdfRepository.toggleFavorite(id, !pdf.isFavorite);
    await refresh();
  }

  /// Renames the user-facing title of a document.
  Future<void> renamePdf(String id, String newTitle) async {
    final trimmed = newTitle.trim();
    if (trimmed.isEmpty) return;
    await _pdfRepository.updateTitle(id, trimmed);
    await refresh();
  }

  /// Moves a document into a folder (or null for root).
  Future<void> moveToFolder(String id, String? folderId) async {
    await _pdfRepository.moveToFolder(id, folderId);
    await refresh();

    final activeRepo = await _gitHubRepository.getSelectedRepository();
    if (activeRepo != null) {
      unawaited(ref.read(syncControllerProvider.notifier).syncNow());
    }
  }

  /// Sets the live search query string.
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Changes the active library tab filter.
  void setFilter(LibraryFilter filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  /// Changes the active sorting algorithm.
  void setSort(LibrarySort sort) {
    state = state.copyWith(selectedSort: sort);
  }

  /// Selects a folder to filter documents.
  void selectFolder(String? folderId) {
    state = state.copyWith(selectedFolderId: () => folderId);
  }

  /// Clears notifications or error messages.
  void clearNotice() {
    state = state.copyWith(userNotice: () => null, errorMessage: () => null);
  }
}

final libraryControllerProvider =
    NotifierProvider<LibraryController, LibraryState>(LibraryController.new);
