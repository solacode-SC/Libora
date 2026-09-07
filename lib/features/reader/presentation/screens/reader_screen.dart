import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/app_logger.dart';
import '../controllers/reader_controller.dart';
import '../controllers/reader_state.dart';
import '../widgets/reader_bottom_bar.dart';
import '../widgets/reader_error_widget.dart';
import '../widgets/reader_loading_widget.dart';
import '../widgets/reader_toolbar.dart';

/// Fullscreen PDF reader screen.
///
/// Handles rendering via pdfrx, smooth scrolling, zoom controls,
/// page navigation, toolbar toggling, keyboard shortcuts, and
/// persistent reading position.
class ReaderScreen extends ConsumerStatefulWidget {
  final String pdfId;

  const ReaderScreen({super.key, required this.pdfId});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  late final PdfViewerController _viewerController;
  double _currentZoom = 1.0;

  @override
  void initState() {
    super.initState();
    _viewerController = PdfViewerController();
    _viewerController.addListener(_onViewerMatrixChanged);
  }

  @override
  void dispose() {
    _viewerController.removeListener(_onViewerMatrixChanged);
    super.dispose();
  }

  void _onViewerMatrixChanged() {
    if (!mounted) return;
    final newZoom = _viewerController.currentZoom;
    if ((newZoom - _currentZoom).abs() > 0.01) {
      setState(() => _currentZoom = newZoom);
    }
  }

  Future<void> _handleBack() async {
    await ref
        .read(readerControllerProvider(widget.pdfId).notifier)
        .persistPosition();
    if (mounted) {
      context.pop();
    }
  }

  void _fitWidth() {
    final state = ref.read(readerControllerProvider(widget.pdfId));
    final page = state.currentPage > 0 ? state.currentPage : 1;
    final matrix = _viewerController.calcMatrixFitWidthForPage(
      pageNumber: page,
    );
    if (matrix != null) {
      _viewerController.goTo(matrix);
    }
  }

  void _fitPage() {
    final state = ref.read(readerControllerProvider(widget.pdfId));
    final page = state.currentPage > 0 ? state.currentPage : 1;
    final matrix = _viewerController.calcMatrixForFit(pageNumber: page);
    if (matrix != null) {
      _viewerController.goTo(matrix);
    }
  }

  void _resetZoom() {
    _viewerController.setZoom(_viewerController.centerPosition, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final readerState = ref.watch(readerControllerProvider(widget.pdfId));
    final controller = ref.read(
      readerControllerProvider(widget.pdfId).notifier,
    );

    // 1. Loading State
    if (readerState.status == ReaderStatus.loading) {
      return ReaderLoadingWidget(title: readerState.title);
    }

    // 2. Error State
    if (readerState.status == ReaderStatus.error) {
      return ReaderErrorWidget(
        title: readerState.title,
        errorMessage:
            readerState.errorMessage ?? 'An unexpected error occurred.',
        isFileAvailable: readerState.isFileAvailable,
        onBack: () => context.pop(),
        onRemoveFromLibrary: () async {
          await controller.deletePdf();
          if (context.mounted) {
            context.pop();
          }
        },
      );
    }

    // 3. Ready State
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBack();
      },
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.escape): _handleBack,
          const SingleActivator(LogicalKeyboardKey.equal): () =>
              _viewerController.zoomUp(),
          const SingleActivator(LogicalKeyboardKey.add): () =>
              _viewerController.zoomUp(),
          const SingleActivator(LogicalKeyboardKey.equal, shift: true): () =>
              _viewerController.zoomUp(),
          const SingleActivator(LogicalKeyboardKey.minus): () =>
              _viewerController.zoomDown(),
          const SingleActivator(LogicalKeyboardKey.numpadSubtract): () =>
              _viewerController.zoomDown(),
          const SingleActivator(LogicalKeyboardKey.digit0): _fitWidth,
          const SingleActivator(LogicalKeyboardKey.numpad0): _fitWidth,
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            backgroundColor: isDark
                ? AppColors.darkBackground
                : AppColors.lightBackground,
            body: MouseRegion(
              onHover: (event) {
                // Reveal controls when hovering near top or bottom on desktop
                if (event.position.dy < 60 ||
                    event.position.dy >
                        MediaQuery.of(context).size.height - 60) {
                  controller.showToolbar();
                }
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // PDF Viewer
                  Positioned.fill(
                    child: PdfViewer.file(
                      readerState.localPath!,
                      controller: _viewerController,
                      initialPageNumber: readerState.currentPage > 0
                          ? readerState.currentPage
                          : 1,
                      params: PdfViewerParams(
                        backgroundColor: isDark
                            ? AppColors.darkBackground
                            : AppColors.lightBackground,
                        keyHandlerParams: const PdfViewerKeyHandlerParams(
                          autofocus: true,
                        ),
                        onPageChanged: (pageNumber) {
                          if (pageNumber != null) {
                            controller.onPageChanged(pageNumber);
                          }
                        },
                        onViewerReady: (document, _) {
                          controller.setTotalPages(document.pages.length);
                        },
                        onKey: (params, key, isRealKeyPress) {
                          if (key == LogicalKeyboardKey.escape) {
                            _handleBack();
                            return true;
                          }
                          if (key == LogicalKeyboardKey.equal ||
                              key == LogicalKeyboardKey.add) {
                            _viewerController.zoomUp();
                            return true;
                          }
                          if (key == LogicalKeyboardKey.minus ||
                              key == LogicalKeyboardKey.numpadSubtract) {
                            _viewerController.zoomDown();
                            return true;
                          }
                          if (key == LogicalKeyboardKey.digit0 ||
                              key == LogicalKeyboardKey.numpad0) {
                            _fitWidth();
                            return true;
                          }
                          // Allow pdfrx to handle Page Up/Down, Home/End, Arrow keys
                          return null;
                        },
                        errorBannerBuilder:
                            (context, error, stackTrace, documentRef) {
                              AppLogger.error(
                                'PDF rendering error: $error',
                                tag: 'Reader',
                                error: error,
                                stackTrace: stackTrace,
                              );
                              return ReaderErrorWidget(
                                title: readerState.title,
                                errorMessage: 'Unable to open this PDF.\n\nThe file may be damaged or unsupported.',
                                isFileAvailable: true,
                                onBack: _handleBack,
                              );
                            },
                        viewerOverlayBuilder: (context, size, handleLinkTap) =>
                            [
                              // Tap on page area toggles controls while still passing through link taps
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTapUp: (details) {
                                  handleLinkTap(details.localPosition);
                                  controller.toggleToolbar();
                                },
                                child: IgnorePointer(
                                  child: SizedBox(
                                    width: size.width,
                                    height: size.height,
                                  ),
                                ),
                              ),
                              // Vertical scrollbar thumb
                              PdfViewerScrollThumb(
                                controller: _viewerController,
                                orientation: ScrollbarOrientation.right,
                              ),
                            ],
                      ),
                    ),
                  ),

                  // Top Toolbar (animated slide)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeInOut,
                    top: readerState.isToolbarVisible
                        ? 0
                        : -AppSpacing.topBarHeight,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      bottom: false,
                      child: ReaderToolbar(
                        readerState: readerState,
                        viewerController: _viewerController,
                        onBack: _handleBack,
                        onFitWidth: _fitWidth,
                        onFitPage: _fitPage,
                      ),
                    ),
                  ),

                  // Bottom Bar (animated slide)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeInOut,
                    bottom: readerState.isToolbarVisible ? 0 : -50,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      top: false,
                      child: ReaderBottomBar(
                        readerState: readerState,
                        currentZoom: _currentZoom,
                        onZoomIn: () => _viewerController.zoomUp(),
                        onZoomOut: () => _viewerController.zoomDown(),
                        onResetZoom: _resetZoom,
                        onFitWidth: _fitWidth,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
