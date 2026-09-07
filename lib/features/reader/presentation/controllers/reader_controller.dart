import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_logger.dart';
import '../../../library/data/repositories/pdf_repository.dart';
import 'reader_state.dart';

/// Riverpod controller for the PDF reader, managing state for a specific PDF.
///
/// Manages:
/// - Loading PDF metadata from [PdfRepository]
/// - Verifying local file existence
/// - Page change tracking with debounced persistence
/// - Toolbar visibility toggle
/// - Immediate persistence on reader exit
class ReaderController extends Notifier<ReaderState> {
  final String pdfId;

  ReaderController(this.pdfId);

  late PdfRepository _pdfRepository;
  Timer? _debounceTimer;

  @override
  ReaderState build() {
    _pdfRepository = ref.watch(pdfRepositoryProvider);

    ref.onDispose(() {
      _debounceTimer?.cancel();
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

      // Update lastReadAt on open
      await _pdfRepository.updateReadingProgress(
        pdf.id,
        pdf.currentPage > 0 ? pdf.currentPage : 0,
      );

      // Restore reading position (1-indexed for display, minimum 1)
      final restoredPage = pdf.currentPage > 0 ? pdf.currentPage : 1;

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
