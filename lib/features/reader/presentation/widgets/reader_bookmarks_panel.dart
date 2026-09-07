import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../bookmarks/domain/models/bookmark_item.dart';
import '../../../bookmarks/presentation/widgets/bookmark_dialog.dart';

/// In-reader bookmarks management panel.
///
/// Can be displayed in an end Drawer or Modal Bottom Sheet.
class ReaderBookmarksPanel extends StatelessWidget {
  final List<BookmarkItem> bookmarks;
  final ValueChanged<int> onSelectPage;
  final Future<void> Function(BookmarkItem bookmark) onEditBookmark;
  final Future<void> Function(String id) onDeleteBookmark;

  const ReaderBookmarksPanel({
    super.key,
    required this.bookmarks,
    required this.onSelectPage,
    required this.onEditBookmark,
    required this.onDeleteBookmark,
  });

  /// Shows the panel as a right-side drawer or modal sheet depending on screen width.
  static void show(
    BuildContext context, {
    required List<BookmarkItem> bookmarks,
    required ValueChanged<int> onSelectPage,
    required Future<void> Function(BookmarkItem bookmark) onEditBookmark,
    required Future<void> Function(String id) onDeleteBookmark,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 600;

    if (isDesktop) {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Bookmarks',
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (ctx, anim1, anim2) {
          return Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 360,
              height: double.infinity,
              child: Material(
                child: ReaderBookmarksPanel(
                  bookmarks: bookmarks,
                  onSelectPage: (page) {
                    Navigator.of(ctx).pop();
                    onSelectPage(page);
                  },
                  onEditBookmark: onEditBookmark,
                  onDeleteBookmark: onDeleteBookmark,
                ),
              ),
            ),
          );
        },
        transitionBuilder: (ctx, anim, _, child) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
                ),
            child: child,
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (ctx, scrollController) => Material(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusLg),
            ),
            clipBehavior: Clip.antiAlias,
            child: ReaderBookmarksPanel(
              bookmarks: bookmarks,
              onSelectPage: (page) {
                Navigator.of(ctx).pop();
                onSelectPage(page);
              },
              onEditBookmark: onEditBookmark,
              onDeleteBookmark: onDeleteBookmark,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    final sorted = List<BookmarkItem>.from(bookmarks)
      ..sort((a, b) => a.pageNumber.compareTo(b.pageNumber));

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: borderColor, height: 1.0),
        ),
        title: Row(
          children: [
            Icon(
              Icons.bookmark_rounded,
              size: 20,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.strongCharcoal,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Bookmarks',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 2.0,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceSubtle
                    : AppColors.lightSurfaceSubtle,
                borderRadius: AppSpacing.roundedSm,
                border: Border.all(color: borderColor, width: 1.0),
              ),
              child: Text(
                '${sorted.length}',
                style: TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                  color: secondaryColor,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 20),
            tooltip: 'Close',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: sorted.isEmpty
          ? const AppEmptyState(
              icon: Icons.bookmark_outline_rounded,
              title: 'No bookmarks yet',
              description: 'Bookmark pages while reading to quickly return to important sections.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: sorted.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.xs),
              itemBuilder: (context, index) {
                final bookmark = sorted[index];

                return AppCard(
                  onTap: () => onSelectPage(bookmark.pageNumber),
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Page badge
                      Container(
                        width: 44,
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurfaceSubtle
                              : AppColors.lightSurfaceSubtle,
                          borderRadius: AppSpacing.roundedSm,
                          border: Border.all(color: borderColor, width: 1.0),
                        ),
                        child: Text(
                          'P. ${bookmark.pageNumber}',
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),

                      // Label & Note
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bookmark.label ?? 'Page ${bookmark.pageNumber}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (bookmark.note != null &&
                                bookmark.note!.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                bookmark.note!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: secondaryColor,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Edit button
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        tooltip: 'Edit bookmark',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 28,
                          minHeight: 28,
                        ),
                        onPressed: () async {
                          final result = await BookmarkDialog.show(
                            context,
                            pageNumber: bookmark.pageNumber,
                            initialLabel: bookmark.label,
                            initialNote: bookmark.note,
                            isEditing: true,
                          );

                          if (result != null) {
                            if (result.isDelete) {
                              await onDeleteBookmark(bookmark.id);
                            } else {
                              await onEditBookmark(
                                bookmark.copyWith(
                                  label: result.label,
                                  note: result.note,
                                ),
                              );
                            }
                          }
                        },
                      ),

                      // Delete button
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 16,
                        ),
                        tooltip: 'Delete bookmark',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 28,
                          minHeight: 28,
                        ),
                        onPressed: () => onDeleteBookmark(bookmark.id),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
