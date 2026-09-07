import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/breakpoints.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/library_dialogs.dart';
import '../../../../core/widgets/pdf_card.dart';
import '../../../folders/domain/models/folder_item.dart';
import '../../domain/models/pdf_item.dart';
import '../controllers/library_controller.dart';
import '../controllers/library_state.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  final String? initialFolderId;

  const LibraryScreen({super.key, this.initialFolderId});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    if (widget.initialFolderId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(libraryControllerProvider.notifier)
            .selectFolder(widget.initialFolderId);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(screenWidth);

    final libraryState = ref.watch(libraryControllerProvider);
    final controller = ref.read(libraryControllerProvider.notifier);

    // Show transient notices / messages
    ref.listen<LibraryState>(libraryControllerProvider, (prev, next) {
      if (next.userNotice != null && next.userNotice != prev?.userNotice) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.userNotice!),
            duration: const Duration(seconds: 3),
          ),
        );
        controller.clearNotice();
      }
      if (next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red.shade800,
            duration: const Duration(seconds: 4),
          ),
        );
        controller.clearNotice();
      }
    });

    final visiblePdfs = libraryState.visiblePdfs;
    final foldersMap = {for (final f in libraryState.folders) f.id: f};
    final activeFolder = libraryState.selectedFolderId != null
        ? foldersMap[libraryState.selectedFolderId]
        : null;

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
              // Header
              AppSectionHeader(
                eyebrow: activeFolder != null
                    ? 'FOLDER: ${activeFolder.name.toUpperCase()}'
                    : 'LOCAL BOOKSHELF',
                title: activeFolder != null ? activeFolder.name : 'My Library',
                subtitle: activeFolder != null
                    ? 'Documents categorized inside this folder.'
                    : 'Documents stored and imported locally on this device.',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (activeFolder != null) ...[
                      AppButton.ghost(
                        label: 'All Books',
                        icon: Icons.arrow_back_rounded,
                        size: AppButtonSize.small,
                        onPressed: () => controller.selectFolder(null),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    AppBadge(
                      label:
                          '${visiblePdfs.length} ${visiblePdfs.length == 1 ? 'BOOK' : 'BOOKS'}',
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    AppButton.primary(
                      label: libraryState.isImporting
                          ? 'Importing...'
                          : 'Import PDF',
                      icon: libraryState.isImporting ? null : Icons.add_rounded,
                      size: AppButtonSize.small,
                      onPressed: libraryState.isImporting
                          ? null
                          : () => controller.importPdfs(),
                    ),
                  ],
                ),
                showBottomBorder: true,
              ),

              // Import Progress Bar Indicator
              if (libraryState.isImporting &&
                  libraryState.importProgress != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        libraryState.importProgress!,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: AppSpacing.md),

              // Search & Filter Toolbar
              Row(
                children: [
                  // Search Text Input
                  Expanded(
                    child: Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurface
                            : AppColors.lightSurface,
                        borderRadius: AppSpacing.roundedSm,
                        border: Border.all(color: borderColor, width: 1.0),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 18,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: theme.textTheme.bodyMedium,
                              decoration: InputDecoration(
                                hintText:
                                    'Search library by title or filename...',
                                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextMuted
                                      : AppColors.lightTextMuted,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (val) =>
                                  controller.setSearchQuery(val),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 16),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                              onPressed: () {
                                _searchController.clear();
                                controller.setSearchQuery('');
                              },
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: AppSpacing.sm),

                  // Sort Menu Button
                  PopupMenuButton<LibrarySort>(
                    tooltip: 'Sort Documents',
                    onSelected: (sort) => controller.setSort(sort),
                    itemBuilder: (context) => [
                      for (final sort in LibrarySort.values)
                        PopupMenuItem(
                          value: sort,
                          child: Row(
                            children: [
                              if (libraryState.selectedSort == sort)
                                const Icon(Icons.check_rounded, size: 16)
                              else
                                const SizedBox(width: 16),
                              const SizedBox(width: 8),
                              Text(sort.label),
                            ],
                          ),
                        ),
                    ],
                    child: Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurface
                            : AppColors.lightSurface,
                        borderRadius: AppSpacing.roundedSm,
                        border: Border.all(color: borderColor, width: 1.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.sort_rounded,
                            size: 16,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                          if (!isMobile) ...[
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              libraryState.selectedSort.label,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.sm),

              // Filter Tabs (All, Favorites, Recent)
              Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected:
                        libraryState.selectedFilter == LibraryFilter.all,
                    onTap: () => controller.setFilter(LibraryFilter.all),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _FilterChip(
                    label: 'Favorites',
                    isSelected:
                        libraryState.selectedFilter == LibraryFilter.favorites,
                    onTap: () => controller.setFilter(LibraryFilter.favorites),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _FilterChip(
                    label: 'Recent',
                    isSelected:
                        libraryState.selectedFilter == LibraryFilter.recent,
                    onTap: () => controller.setFilter(LibraryFilter.recent),
                  ),
                  if (activeFolder != null) ...[
                    const Spacer(),
                    Chip(
                      label: Text(
                        'Folder: ${activeFolder.name}',
                        style: const TextStyle(fontSize: 11),
                      ),
                      deleteIcon: const Icon(Icons.close_rounded, size: 14),
                      onDeleted: () => controller.selectFolder(null),
                      backgroundColor: isDark
                          ? AppColors.darkSurfaceSubtle
                          : AppColors.lightSurfaceSubtle,
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppSpacing.roundedSm,
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Library Content Area
              Expanded(
                child: _buildLibraryContent(
                  context,
                  libraryState,
                  controller,
                  visiblePdfs,
                  foldersMap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLibraryContent(
    BuildContext context,
    LibraryState state,
    LibraryController controller,
    List<PdfItem> visiblePdfs,
    Map<String, FolderItem> foldersMap,
  ) {
    if (state.isLoading) {
      return const Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 2.0),
        ),
      );
    }

    if (visiblePdfs.isEmpty) {
      if (state.searchQuery.isNotEmpty) {
        return AppEmptyState(
          icon: Icons.search_off_rounded,
          title: 'No PDFs found',
          description:
              'No documents matched "${state.searchQuery}". Try a different keyword or clear the search field.',
          actionLabel: 'Clear Search',
          onAction: () {
            _searchController.clear();
            controller.setSearchQuery('');
          },
        );
      }

      if (state.selectedFilter == LibraryFilter.favorites) {
        return AppEmptyState(
          icon: Icons.star_outline_rounded,
          title: 'No favorites yet',
          description: 'Tap the star icon on any document in your library to keep it pinned here.',
          actionLabel: 'View All Documents',
          onAction: () => controller.setFilter(LibraryFilter.all),
        );
      }

      if (state.selectedFilter == LibraryFilter.recent) {
        return AppEmptyState(
          icon: Icons.history_rounded,
          title: 'No recently read PDFs',
          description:
              'Documents you open and read will appear here automatically.',
          actionLabel: 'View All Documents',
          onAction: () => controller.setFilter(LibraryFilter.all),
        );
      }

      if (state.selectedFolderId != null) {
        return AppEmptyState(
          icon: Icons.folder_open_outlined,
          title: 'This folder is empty',
          description: 'Move PDFs into this folder from the bookshelf context menu to organize your materials.',
          actionLabel: 'View All Documents',
          onAction: () => controller.selectFolder(null),
        );
      }

      return AppEmptyState(
        icon: Icons.local_library_outlined,
        title: 'Your bookshelf is empty',
        description: 'Import PDF documents from your device to begin reading and organizing your collection.',
        actionLabel: 'Import First PDF',
        actionIcon: Icons.add_rounded,
        onAction: () => controller.importPdfs(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxExtent = constraints.maxWidth < 450 ? 160.0 : 210.0;
        final childAspectRatio = constraints.maxWidth < 450 ? 0.62 : 0.68;

        return GridView.builder(
          itemCount: visiblePdfs.length,
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: maxExtent,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
          ),
          itemBuilder: (context, index) {
            final pdf = visiblePdfs[index];
            final folder = pdf.folderId != null
                ? foldersMap[pdf.folderId]
                : null;

            return PdfCard(
              pdf: pdf,
              folderName: folder?.name,
              onTap: () => context.push('/reader/${pdf.id}'),
              onToggleFavorite: () => controller.toggleFavorite(pdf.id),
              onRename: () async {
                final newTitle = await LibraryDialogs.showRenameDialog(
                  context,
                  currentTitle: pdf.title,
                );
                if (newTitle != null) {
                  await controller.renamePdf(pdf.id, newTitle);
                }
              },
              onMoveToFolder: () async {
                final selectedFolder =
                    await LibraryDialogs.showMoveToFolderDialog(
                      context,
                      folders: state.folders,
                      currentFolderId: pdf.folderId,
                    );
                // Note: user may choose null to move to root
                await controller.moveToFolder(pdf.id, selectedFolder);
              },
              onDelete: () async {
                final confirm = await LibraryDialogs.showConfirmDeleteDialog(
                  context,
                  title: pdf.title,
                );
                if (confirm) {
                  await controller.deletePdf(pdf.id);
                }
              },
            );
          },
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.roundedSm,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 4.0,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.strongCharcoal)
                : (isDark
                      ? AppColors.darkSurfaceSubtle
                      : AppColors.lightSurfaceSubtle),
            borderRadius: AppSpacing.roundedSm,
            border: Border.all(
              color: isSelected
                  ? (isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.strongCharcoal)
                  : borderColor,
              width: 1.0,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? (isDark ? AppColors.darkBackground : AppColors.lightSurface)
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
