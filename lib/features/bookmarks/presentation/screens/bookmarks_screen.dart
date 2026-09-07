import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/breakpoints.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../library/data/repositories/pdf_repository.dart';
import '../../data/repositories/bookmark_repository.dart';
import '../../domain/models/bookmark_item.dart';
import '../widgets/bookmark_dialog.dart';

final allBookmarksStreamProvider = StreamProvider<List<BookmarkItem>>((ref) {
  final repo = ref.watch(bookmarkRepositoryProvider);
  return repo.watchAllBookmarks();
});

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = Breakpoints.isMobile(MediaQuery.of(context).size.width);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    final bookmarksAsync = ref.watch(allBookmarksStreamProvider);
    final allPdfsAsync = ref.watch(allPdfsStreamProvider);
    final bookmarkRepo = ref.read(bookmarkRepositoryProvider);

    final pdfsMap = allPdfsAsync.value != null
        ? {for (final p in allPdfsAsync.value!) p.id: p}
        : const {};

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? AppSpacing.md : AppSpacing.xxl,
            vertical: isMobile ? AppSpacing.md : AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSectionHeader(
                eyebrow: 'COLLECTIONS',
                title: 'Bookmarks',
                subtitle: 'Saved page markers, quotes, and reading references across your library.',
                trailing: bookmarksAsync.value != null
                    ? AppBadge(
                        label: '${bookmarksAsync.value!.length} BOOKMARKS',
                      )
                    : null,
                showBottomBorder: true,
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: bookmarksAsync.when(
                  loading: () => const Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    ),
                  ),
                  error: (err, _) =>
                      Center(child: Text('Failed to load bookmarks: $err')),
                  data: (bookmarks) {
                    if (bookmarks.isEmpty) {
                      return AppEmptyState(
                        icon: Icons.bookmark_outline_rounded,
                        title: 'No bookmarks yet',
                        description: 'Pages you bookmark while reading documents will be preserved here for quick recall.',
                        actionLabel: 'Browse Library',
                        actionIcon: Icons.local_library_outlined,
                        onAction: () => context.go('/library'),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                      itemCount: bookmarks.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final bookmark = bookmarks[index];
                        final pdf = pdfsMap[bookmark.pdfId];
                        final pdfTitle =
                            pdf?.title ?? 'Document (${bookmark.pdfId})';

                        return AppCard(
                          onTap: () {
                            context.push('/reader/${bookmark.pdfId}');
                          },
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Page badge
                              Container(
                                width: 50,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkSurfaceSubtle
                                      : AppColors.lightSurfaceSubtle,
                                  borderRadius: AppSpacing.roundedSm,
                                  border: Border.all(
                                    color: borderColor,
                                    width: 1.0,
                                  ),
                                ),
                                child: Text(
                                  'P. ${bookmark.pageNumber}',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),

                              // Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bookmark.label ??
                                          'Page ${bookmark.pageNumber}',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: AppSpacing.xxs),
                                    Text(
                                      pdfTitle,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: secondaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    if (bookmark.note != null &&
                                        bookmark.note!.isNotEmpty) ...[
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        bookmark.note!,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: isDark
                                                  ? AppColors.darkTextPrimary
                                                  : AppColors.lightTextPrimary,
                                            ),
                                      ),
                                    ],
                                    const SizedBox(height: AppSpacing.xxs),
                                    Text(
                                      DateFormat.yMMMd().format(
                                        bookmark.createdAt,
                                      ),
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            fontSize: 11.0,
                                            color: isDark
                                                ? AppColors.darkTextMuted
                                                : AppColors.lightTextMuted,
                                          ),
                                    ),
                                  ],
                                ),
                              ),

                              // Actions
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                tooltip: 'Edit',
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
                                      await bookmarkRepo.deleteBookmark(
                                        bookmark.id,
                                      );
                                    } else {
                                      await bookmarkRepo.updateBookmark(
                                        bookmark.copyWith(
                                          label: result.label,
                                          note: result.note,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  size: 18,
                                ),
                                tooltip: 'Delete',
                                onPressed: () =>
                                    bookmarkRepo.deleteBookmark(bookmark.id),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final allPdfsStreamProvider = StreamProvider((ref) {
  return ref.watch(pdfRepositoryProvider).watchAllPdfs();
});
