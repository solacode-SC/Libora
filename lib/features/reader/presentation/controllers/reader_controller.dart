import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/app_logger.dart';
import '../../../bookmarks/data/repositories/bookmark_repository.dart';
import '../../../bookmarks/domain/models/bookmark_item.dart';
import '../../../library/data/repositories/pdf_repository.dart';
import 'reader_state.dart';

/// Riverpod controller for the PDF reader, managing state for a specific PDF.
///
/// Manages:
/// - Loading PDF metadata from [PdfRepository]
/// - Verifying local file existence
/// - Page change tracking with debounced persistence
/// - Bookmarks and favorite toggling
/// - Toolbar visibility toggle
/// - Immediate persistence on reader exit
class ReaderController extends Notifier<ReaderState> {
  final String pdfId;

  ReaderController(this.pdfId);

  late PdfRepository _pdfRepository;
  late BookmarkRepository _bookmarkRepository;
  Timer? _debounceTimer;
  StreamSubscription<List<BookmarkItem>>? _bookmarksSub;
  final _uuid = const Uuid();

  @override
  ReaderState build() {
    _pdfRepository = ref.watch(pdfRepositoryProvider);
    _bookmarkRepository = ref.watch(bookmarkRepositoryProvider);

    ref.onDispose(() {
      _debounceTimer?.cancel();
      _bookmarksSub?.cancel();
    });

    _bookmarksSub?.cancel();
    _bookmarksSub = _bookmarkRepository.watchBookmarksForPdf(pdfId).listen((
      bms,
    ) {
      state = state.copyWith(bookmarks: bms);
    });

    // Trigger async loading
    _loadPdf(pdfId);

    return const ReaderState(status: ReaderStatus.loading);
  }

  /// Loads PDF metadata and verifies the local file exists.
  Future<void> _loadPdf(String id) async {
    try {
      final pdf = await _pdfRepository.getPdfById(id);

      if (pdf == null) {
        state = state.copyWith(
          status: ReaderStatus.error,
          errorMessage: () => 'PDF not found in library.',
          isFileAvailable: false,
        );
        return;
      }

      // Verify local file exists
      final localPath = pdf.localPath;
      if (localPath == null || localPath.isEmpty) {
        state = ReaderState(
          status: ReaderStatus.error,
          pdfId: pdf.id,
          title: pdf.title,
          fileName: pdf.fileName,
          errorMessage: 'This PDF is no longer available.\n\nThe local file could not be found.',
          isFileAvailable: false,
        );
        return;
      }

      final file = File(localPath);
      if (!file.existsSync()) {
        state = ReaderState(
          status: ReaderStatus.error,
          pdfId: pdf.id,
          title: pdf.title,
          fileName: pdf.fileName,
          errorMessage: 'This PDF is no longer available.\n\nThe local file could not be found.',
          isFileAvailable: false,
        );
        return;
      }

      // Restore reading position (1-indexed for display, minimum 1)
      final restoredPage = pdf.currentPage > 0 ? pdf.currentPage : 1;

      // Update lastReadAt and reading progress on open
      await _pdfRepository.updateReadingProgress(pdf.id, restoredPage);

      state = ReaderState(
        status: ReaderStatus.ready,
        pdfId: pdf.id,
        title: pdf.title,
        fileName: pdf.fileName,
        localPath: localPath,
        coverPath: pdf.coverPath,
        folderId: pdf.folderId,
        fileSize: pdf.fileSize,
        currentPage: restoredPage,
        totalPages: pdf.pageCount ?? 0,
        isToolbarVisible: true,
        isFavorite: pdf.isFavorite,
        bookmarks: state.bookmarks,
        isFileAvailable: true,
        createdAt: pdf.createdAt,
        lastReadAt: DateTime.now(),
      );

      AppLogger.info(
        'Opened PDF: "${pdf.title}" at page $restoredPage/${pdf.pageCount ?? "?"}',
        tag: 'Reader',
      );
    } catch (e, stack) {
      AppLogger.error(
        'Failed to load PDF: $e',
        tag: 'Reader',
        error: e,
        stackTrace: stack,
      );
      state = state.copyWith(
        status: ReaderStatus.error,
        errorMessage: () => 'Unable to open this PDF.\n\nThe file may be damaged or unsupported.',
      );
    }
  }

  /// Called when the viewer reports a page change.
  ///
  /// Updates local state immediately and debounces DB write by 500ms.
  void onPageChanged(int page) {
    if (page < 1 || page == state.currentPage) return;

    state = state.copyWith(currentPage: page, lastReadAt: () => DateTime.now());

    // Debounce database write
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _persistPosition(page);
    });
  }

  /// Updates the total page count from the viewer.
  void setTotalPages(int total) {
    if (total > 0 && total != state.totalPages) {
      state = state.copyWith(totalPages: total);

      final currentPdfId = state.pdfId;
      if (currentPdfId != null) {
        _pdfRepository.getPdfById(currentPdfId).then((pdf) {
          if (pdf != null && (pdf.pageCount == null || pdf.pageCount == 0)) {
            AppLogger.debug(
              'Total pages discovered: $total for "${state.title}"',
              tag: 'Reader',
            );
          }
        });
      }
    }
  }

  /// Toggles favorite status for this PDF.
  Future<void> toggleFavorite() async {
    final newFavorite = !state.isFavorite;
    state = state.copyWith(isFavorite: newFavorite);

    try {
      await _pdfRepository.toggleFavorite(pdfId, newFavorite);
      AppLogger.info(
        'Toggled favorite for "${state.title}": $newFavorite',
        tag: 'Reader',
      );
    } catch (e, stack) {
      AppLogger.error(
        'Failed to toggle favorite: $e',
        tag: 'Reader',
        error: e,
        stackTrace: stack,
      );
      state = state.copyWith(isFavorite: !newFavorite);
    }
  }

  /// Adds a bookmark for the specified page (or current page if omitted).
  ///
  /// Returns `true` if saved successfully, `false` if duplicate or invalid.
  Future<bool> addBookmark({int? page, String? label, String? note}) async {
    final pageToBookmark = page ?? state.currentPage;
    if (pageToBookmark < 1 ||
        (state.totalPages > 0 && pageToBookmark > state.totalPages)) {
      return false;
    }

    // Check duplicate
    if (state.bookmarkedPages.contains(pageToBookmark)) {
      return false;
    }

    final bookmark = BookmarkItem(
      id: _uuid.v4(),
      pdfId: pdfId,
      pageNumber: pageToBookmark,
      label: label,
      note: note,
      createdAt: DateTime.now(),
    );

    try {
      await _bookmarkRepository.addBookmark(bookmark);
      AppLogger.info(
        'Bookmarked page $pageToBookmark for "${state.title}"',
        tag: 'Reader',
      );
      return true;
    } catch (e, stack) {
      AppLogger.error(
        'Failed to add bookmark: $e',
        tag: 'Reader',
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  /// Updates an existing bookmark's label and note.
  Future<void> updateBookmark(BookmarkItem bookmark) async {
    try {
      await _bookmarkRepository.updateBookmark(bookmark);
      AppLogger.info(
        'Updated bookmark for page ${bookmark.pageNumber}',
        tag: 'Reader',
      );
    } catch (e, stack) {
      AppLogger.error(
        'Failed to update bookmark: $e',
        tag: 'Reader',
        error: e,
        stackTrace: stack,
      );
    }
  }

  /// Deletes a bookmark by ID.
  Future<void> deleteBookmark(String id) async {
    try {
      await _bookmarkRepository.deleteBookmark(id);
      AppLogger.info('Deleted bookmark $id', tag: 'Reader');
    } catch (e, stack) {
      AppLogger.error(
        'Failed to delete bookmark: $e',
        tag: 'Reader',
        error: e,
        stackTrace: stack,
      );
    }
  }

  /// Deletes the bookmark for the current page if one exists.
  Future<void> deleteCurrentPageBookmark() async {
    final current = state.currentBookmark;
    if (current != null) {
      await deleteBookmark(current.id);
    }
  }

  /// Toggles toolbar visibility.
  void toggleToolbar() {
    state = state.copyWith(isToolbarVisible: !state.isToolbarVisible);
  }

  /// Shows the toolbar.
  void showToolbar() {
    if (!state.isToolbarVisible) {
      state = state.copyWith(isToolbarVisible: true);
    }
  }

  /// Hides the toolbar.
  void hideToolbar() {
    if (state.isToolbarVisible) {
      state = state.copyWith(isToolbarVisible: false);
    }
  }

  /// Persists the current reading position immediately.
  ///
  /// Call this before leaving the reader.
  Future<void> persistPosition() async {
    _debounceTimer?.cancel();
    await _persistPosition(state.currentPage);
  }

  /// Writes the current page to the database.
  Future<void> _persistPosition(int page) async {
    final currentPdfId = state.pdfId;
    if (currentPdfId == null || page < 1) return;

    try {
      await _pdfRepository.updateReadingProgress(currentPdfId, page);
      AppLogger.debug(
        'Saved reading position: page $page for "${state.title}"',
        tag: 'Reader',
      );
    } catch (e, stack) {
      AppLogger.error(
        'Failed to persist reading position: $e',
        tag: 'Reader',
        error: e,
        stackTrace: stack,
      );
    }
  }

  /// Removes the PDF from the library (for missing-file cleanup).
  Future<void> deletePdf() async {
    final currentPdfId = state.pdfId;
    if (currentPdfId == null) return;

    try {
      await _pdfRepository.deletePdf(currentPdfId);
      AppLogger.info(
        'Removed PDF from library: "${state.title}"',
        tag: 'Reader',
      );
    } catch (e, stack) {
      AppLogger.error(
        'Failed to delete PDF: $e',
        tag: 'Reader',
        error: e,
        stackTrace: stack,
      );
    }
  }
}

/// Provider for the reader controller, keyed by PDF ID.
final readerControllerProvider =
    NotifierProvider.family<ReaderController, ReaderState, String>(
      (arg) => ReaderController(arg),
    );
