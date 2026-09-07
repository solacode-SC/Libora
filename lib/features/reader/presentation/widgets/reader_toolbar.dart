import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../bookmarks/presentation/widgets/bookmark_dialog.dart';
import '../../../folders/data/repositories/folder_repository.dart';
import '../controllers/reader_controller.dart';
import '../controllers/reader_state.dart';
import 'go_to_page_dialog.dart';
import 'pdf_info_dialog.dart';

/// Compact top toolbar for the PDF reader.
///
/// Contains back button, title, page indicator, bookmark toggle, and more menu.
class ReaderToolbar extends ConsumerWidget {
  final ReaderState readerState;
  final PdfViewerController? viewerController;
  final VoidCallback onBack;
  final VoidCallback? onFitWidth;
  final VoidCallback? onFitPage;
  final VoidCallback? onOpenBookmarks;

  const ReaderToolbar({
    super.key,
    required this.readerState,
    this.viewerController,
    required this.onBack,
    this.onFitWidth,
    this.onFitPage,
    this.onOpenBookmarks,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final bgColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    final isBookmarked = readerState.isCurrentPageBookmarked;

    return Container(
      height: AppSpacing.topBarHeight,
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.95),
        border: Border(bottom: BorderSide(color: borderColor, width: 1.0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        children: [
          // Back button
          AppIconButton(
            icon: Icons.arrow_back_rounded,
            tooltip: 'Back to library',
            onPressed: onBack,
            size: 34,
          ),
          const SizedBox(width: AppSpacing.sm),

          // Title
          Expanded(
            child: Text(
              readerState.title ?? 'Document',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Page indicator
          if (readerState.totalPages > 0)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceSubtle
                    : AppColors.lightSurfaceSubtle,
                borderRadius: AppSpacing.roundedSm,
                border: Border.all(color: borderColor, width: 1.0),
              ),
              child: Text(
                readerState.pageIndicator,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
          const SizedBox(width: AppSpacing.xs),

          // Bookmark quick action button
          AppIconButton(
            icon: isBookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            tooltip: isBookmarked
                ? 'Bookmarked (Page ${readerState.currentPage}) — tap to edit'
                : 'Bookmark page ${readerState.currentPage}',
            onPressed: () => _handleBookmarkTap(context, ref),
            size: 34,
          ),
          const SizedBox(width: AppSpacing.xxs),

          // More menu
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              size: 18,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            tooltip: 'More options',
            onSelected: (value) => _onMenuSelected(context, ref, value),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'bookmarks',
                child: Row(
                  children: [
                    const Icon(Icons.bookmarks_outlined, size: 16),
                    const SizedBox(width: 8),
                    Text('Bookmarks (${readerState.bookmarks.length})'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'favorite',
                child: Row(
                  children: [
                    Icon(
                      readerState.isFavorite
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 16,
                      color: readerState.isFavorite
                          ? Colors.amber.shade700
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      readerState.isFavorite ? 'Remove Favorite' : 'Favorite',
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              if (onFitWidth != null)
                const PopupMenuItem(
                  value: 'fit_width',
                  child: Row(
                    children: [
                      Icon(Icons.width_normal_rounded, size: 16),
                      SizedBox(width: 8),
                      Text('Fit width'),
                    ],
                  ),
                ),
              if (onFitPage != null)
                const PopupMenuItem(
                  value: 'fit_page',
                  child: Row(
                    children: [
                      Icon(Icons.fit_screen_rounded, size: 16),
                      SizedBox(width: 8),
                      Text('Fit page'),
                    ],
                  ),
                ),
              if (readerState.totalPages > 0)
                const PopupMenuItem(
                  value: 'go_to_page',
                  child: Row(
                    children: [
                      Icon(Icons.find_in_page_outlined, size: 16),
                      SizedBox(width: 8),
                      Text('Go to page'),
                    ],
                  ),
                ),
              const PopupMenuItem(
                value: 'info',
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 16),
                    SizedBox(width: 8),
                    Text('PDF information'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'close',
                child: Row(
                  children: [
                    Icon(Icons.close_rounded, size: 16),
                    SizedBox(width: 8),
                    Text('Close'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleBookmarkTap(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(
      readerControllerProvider(readerState.pdfId!).notifier,
    );
    final existing = readerState.currentBookmark;

    final result = await BookmarkDialog.show(
      context,
      pageNumber: readerState.currentPage,
      initialLabel: existing?.label,
      initialNote: existing?.note,
      isEditing: existing != null,
    );

    if (result != null) {
      if (result.isDelete && existing != null) {
        await controller.deleteBookmark(existing.id);
      } else if (existing != null) {
        await controller.updateBookmark(
          existing.copyWith(label: result.label, note: result.note),
        );
      } else {
        await controller.addBookmark(
          page: readerState.currentPage,
          label: result.label,
          note: result.note,
        );
      }
    }
  }

  Future<void> _onMenuSelected(
    BuildContext context,
    WidgetRef ref,
    String value,
  ) async {
    switch (value) {
      case 'bookmarks':
        onOpenBookmarks?.call();
        break;
      case 'favorite':
        if (readerState.pdfId != null) {
          await ref
              .read(readerControllerProvider(readerState.pdfId!).notifier)
              .toggleFavorite();
        }
        break;
      case 'fit_width':
        onFitWidth?.call();
        break;
      case 'fit_page':
        onFitPage?.call();
        break;
      case 'go_to_page':
        _goToPage(context);
        break;
      case 'info':
        String? folderName;
        if (readerState.folderId != null) {
          final folder = await ref
              .read(folderRepositoryProvider)
              .getFolderById(readerState.folderId!);
          folderName = folder?.name;
        }
        if (context.mounted) {
          PdfInfoDialog.show(
            context,
            readerState: readerState,
            folderName: folderName,
          );
        }
        break;
      case 'close':
        onBack();
        break;
    }
  }

  Future<void> _goToPage(BuildContext context) async {
    final page = await GoToPageDialog.show(
      context,
      currentPage: readerState.currentPage,
      totalPages: readerState.totalPages,
    );

    if (page != null && viewerController != null) {
      viewerController!.goToPage(pageNumber: page);
    }
  }
}
