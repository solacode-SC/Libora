import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../../../core/services/default_pdf_file_service.dart';
import '../../../../core/services/default_pdf_thumbnail_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../folders/data/repositories/folder_repository.dart';
import '../../data/repositories/pdf_repository.dart';
import '../../domain/models/pdf_item.dart';
import 'library_state.dart';

/// Riverpod Notifier managing the local PDF library state and workflows.
class LibraryController extends Notifier<LibraryState> {
  late PdfRepository _pdfRepository;
  late FolderRepository _folderRepository;
  late LocalStorageService _storageService;
  late DefaultPdfFileService _fileService;
  late DefaultPdfThumbnailService _thumbnailService;
  final Uuid _uuid = const Uuid();

  StreamSubscription<List<PdfItem>>? _pdfsSub;
  StreamSubscription<dynamic>? _foldersSub;

  @override
  LibraryState build() {
    _pdfRepository = ref.watch(pdfRepositoryProvider);
    _folderRepository = ref.watch(folderRepositoryProvider);
    _storageService = ref.watch(storageServiceProvider);
    _fileService = ref.watch(pdfFileServiceProvider);
    _thumbnailService = ref.watch(pdfThumbnailServiceProvider);

    _pdfsSub?.cancel();
    _foldersSub?.cancel();

    _pdfsSub = _pdfRepository.watchAllPdfs().listen((pdfs) {
      state = state.copyWith(allPdfs: pdfs, isLoading: false);
    });

    _foldersSub = _folderRepository.watchAllFolders().listen((folders) {
      state = state.copyWith(folders: folders);
    });

    ref.onDispose(() {
      _pdfsSub?.cancel();
      _foldersSub?.cancel();
    });

    return const LibraryState(isLoading: true);
  }

  /// Prompts the user to pick one or more PDF files and imports them into Libora-managed storage.
  Future<void> importPdfs() async {
    try {
      final pickedFiles = await _fileService.pickPdfFiles();
      if (pickedFiles.isEmpty) return;

      state = state.copyWith(
        isImporting: true,
        importProgress: () => 'Importing 0 of ${pickedFiles.length}...',
        userNotice: () => null,
        errorMessage: () => null,
      );

      final coversDir = await _storageService.getCoversDirectory();
      final duplicateNames = <String>[];

      for (int i = 0; i < pickedFiles.length; i++) {
        final file = pickedFiles[i];
        state = state.copyWith(
          importProgress: () =>
              'Importing ${i + 1} of ${pickedFiles.length}: ${p.basename(file.path)}...',
        );

        final isValid = await _fileService.validatePdf(file);
        if (!isValid) continue;

        final fileName = p.basename(file.path);
        final fileSize = await file.length();
        final hash = await _fileService.computeFileHash(file);

        // Check for duplicate
        final duplicate = await _pdfRepository.findDuplicate(
          hash: hash,
          fileSize: fileSize,
          fileName: fileName,
        );

        if (duplicate != null) {
          duplicateNames.add(fileName);
          continue;
        }

        final pdfId = _uuid.v4();
        // Copy into managed storage
        final managedFile = await _storageService.copyToManagedStorage(
          file,
          pdfId,
        );
        final metadata = await _fileService.extractMetadata(managedFile);

        // Generate cover thumbnail
        final targetCoverPath = p.join(coversDir.path, '$pdfId.jpg');
        final coverFile = await _thumbnailService.generateCoverImage(
          pdfFile: managedFile,
          destinationPath: targetCoverPath,
        );

        final now = DateTime.now();
        final pdfItem = PdfItem(
          id: pdfId,
          title: metadata.title,
          fileName: fileName,
          localPath: managedFile.path,
          coverPath: coverFile?.path,
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
      }

      String? notice;
      if (duplicateNames.isNotEmpty) {
        if (duplicateNames.length == 1) {
          notice = '"${duplicateNames.first}" is already in your library.';
        } else {
          notice = '${duplicateNames.length} duplicate files were skipped.';
        }
      }

      state = state.copyWith(
        isImporting: false,
        importProgress: () => null,
        userNotice: () => notice,
      );
    } catch (e) {
      state = state.copyWith(
        isImporting: false,
        importProgress: () => null,
        errorMessage: () => 'Failed to import PDFs: $e',
      );
    }
  }

  /// Removes a PDF from Libora, deleting its managed file, cached cover, and database entry.
  Future<void> deletePdf(String id) async {
    try {
      final pdf = await _pdfRepository.getPdfById(id);
      if (pdf != null) {
        await _storageService.deleteManagedFile(pdf.localPath);
        await _storageService.deleteManagedFile(pdf.coverPath);
      }
      await _pdfRepository.deletePdf(id);
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
  }

  /// Renames the user-facing title of a document.
  Future<void> renamePdf(String id, String newTitle) async {
    final trimmed = newTitle.trim();
    if (trimmed.isEmpty) return;
    await _pdfRepository.updateTitle(id, trimmed);
  }

  /// Moves a document into a folder (or null for root).
  Future<void> moveToFolder(String id, String? folderId) async {
    await _pdfRepository.moveToFolder(id, folderId);
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
