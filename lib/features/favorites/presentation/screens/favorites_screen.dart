import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/breakpoints.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/library_dialogs.dart';
import '../../../../core/widgets/pdf_card.dart';
import '../../../library/presentation/controllers/library_controller.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Breakpoints.isMobile(MediaQuery.of(context).size.width);

    final libraryState = ref.watch(libraryControllerProvider);
    final controller = ref.read(libraryControllerProvider.notifier);

    final favoritePdfs = libraryState.allPdfs
        .where((p) => p.isFavorite)
        .toList();
    final foldersMap = {for (final f in libraryState.folders) f.id: f};

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
                title: 'Favorites',
                subtitle: 'Your starred books, papers, and documents.',
                trailing: AppBadge(
                  label:
                      '${favoritePdfs.length} ${favoritePdfs.length == 1 ? 'STARRED' : 'STARRED'}',
                ),
                showBottomBorder: true,
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: favoritePdfs.isEmpty
                    ? AppEmptyState(
                        icon: Icons.star_outline_rounded,
                        title: 'No favorites yet',
                        description: 'Tap the star icon on any document in your library to keep it pinned here for quick access.',
                        actionLabel: 'Browse Library',
                        actionIcon: Icons.local_library_outlined,
                        onAction: () => context.go('/library'),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final maxExtent = constraints.maxWidth < 450
                              ? 160.0
                              : 210.0;
                          final childAspectRatio = constraints.maxWidth < 450
                              ? 0.62
                              : 0.68;

                          return GridView.builder(
                            itemCount: favoritePdfs.length,
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.xxl,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: maxExtent,
                                  childAspectRatio: childAspectRatio,
                                  crossAxisSpacing: AppSpacing.md,
                                  mainAxisSpacing: AppSpacing.md,
                                ),
                            itemBuilder: (context, index) {
                              final pdf = favoritePdfs[index];
                              final folder = pdf.folderId != null
                                  ? foldersMap[pdf.folderId]
                                  : null;

                              return PdfCard(
                                pdf: pdf,
                                folderName: folder?.name,
                                onTap: () => context.push('/reader/${pdf.id}'),
                                onToggleFavorite: () =>
                                    controller.toggleFavorite(pdf.id),
                                onRename: () async {
                                  final newTitle =
                                      await LibraryDialogs.showRenameDialog(
                                        context,
                                        currentTitle: pdf.title,
                                      );
                                  if (newTitle != null) {
                                    await controller.renamePdf(
                                      pdf.id,
                                      newTitle,
                                    );
                                  }
                                },
                                onMoveToFolder: () async {
                                  final selectedFolder =
                                      await LibraryDialogs.showMoveToFolderDialog(
                                        context,
                                        folders: libraryState.folders,
                                        currentFolderId: pdf.folderId,
                                      );
                                  await controller.moveToFolder(
                                    pdf.id,
                                    selectedFolder,
                                  );
                                },
                                onDelete: () async {
                                  final confirm =
                                      await LibraryDialogs.showConfirmDeleteDialog(
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
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
