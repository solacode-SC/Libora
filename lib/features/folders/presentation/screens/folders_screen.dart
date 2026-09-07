import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/breakpoints.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/library_dialogs.dart';
import '../../../library/presentation/controllers/library_controller.dart';
import '../controllers/folders_controller.dart';

class FoldersScreen extends ConsumerWidget {
  const FoldersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = Breakpoints.isMobile(MediaQuery.of(context).size.width);

    final foldersAsync = ref.watch(foldersStreamProvider);
    final foldersController = ref.watch(foldersControllerProvider);
    final libraryState = ref.watch(libraryControllerProvider);

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
                title: 'Folders',
                subtitle: 'Group your PDFs into reading lists, study topics, and series.',
                trailing: AppButton.primary(
                  label: 'New Folder',
                  icon: Icons.create_new_folder_outlined,
                  size: AppButtonSize.small,
                  onPressed: () async {
                    final name = await LibraryDialogs.showCreateFolderDialog(
                      context,
                    );
                    if (name != null) {
                      await foldersController.createFolder(name);
                    }
                  },
                ),
                showBottomBorder: true,
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: foldersAsync.when(
                  loading: () => const Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    ),
                  ),
                  error: (err, _) =>
                      Center(child: Text('Failed to load folders: $err')),
                  data: (folders) {
                    if (folders.isEmpty) {
                      return AppEmptyState(
                        icon: Icons.folder_outlined,
                        title: 'No folders yet',
                        description: 'Create custom folders to organize series, study topics, and thematic book collections.',
                        actionLabel: 'Create First Folder',
                        actionIcon: Icons.add_rounded,
                        onAction: () async {
                          final name =
                              await LibraryDialogs.showCreateFolderDialog(
                                context,
                              );
                          if (name != null) {
                            await foldersController.createFolder(name);
                          }
                        },
                      );
                    }

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final maxExtent = constraints.maxWidth < 500
                            ? 220.0
                            : 280.0;

                        return GridView.builder(
                          itemCount: folders.length,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: maxExtent,
                                childAspectRatio: 1.6,
                                crossAxisSpacing: AppSpacing.md,
                                mainAxisSpacing: AppSpacing.md,
                              ),
                          itemBuilder: (context, index) {
                            final folder = folders[index];
                            final docsInFolder = libraryState.allPdfs
                                .where((p) => p.folderId == folder.id)
                                .length;

                            return AppCard(
                              onTap: () {
                                ref
                                    .read(libraryControllerProvider.notifier)
                                    .selectFolder(folder.id);
                                context.go('/library/folder/${folder.id}');
                              },
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? AppColors.darkSurfaceSubtle
                                              : AppColors.lightSurfaceSubtle,
                                          borderRadius: AppSpacing.roundedSm,
                                        ),
                                        child: Icon(
                                          Icons.folder_rounded,
                                          size: 18,
                                          color: isDark
                                              ? AppColors.darkTextPrimary
                                              : AppColors.strongCharcoal,
                                        ),
                                      ),
                                      const Spacer(),
                                      PopupMenuButton<String>(
                                        padding: EdgeInsets.zero,
                                        iconSize: 16,
                                        icon: Icon(
                                          Icons.more_vert_rounded,
                                          color: isDark
                                              ? AppColors.darkTextMuted
                                              : AppColors.lightTextMuted,
                                        ),
                                        onSelected: (action) async {
                                          if (action == 'rename') {
                                            final newName =
                                                await LibraryDialogs.showRenameDialog(
                                                  context,
                                                  currentTitle: folder.name,
                                                );
                                            if (newName != null) {
                                              await foldersController
                                                  .renameFolder(
                                                    folder.id,
                                                    newName,
                                                  );
                                            }
                                          } else if (action == 'delete') {
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: Text(
                                                  'Delete folder "${folder.name}"?',
                                                ),
                                                content: const Text(
                                                  'Documents inside this folder will not be deleted; they will be moved to the library root.',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(ctx)
                                                            .pop(false),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(ctx)
                                                            .pop(true),
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              ),
                                            );
                                            if (confirm == true) {
                                              await foldersController
                                                  .deleteFolder(folder.id);
                                            }
                                          }
                                        },
                                        itemBuilder: (context) => const [
                                          PopupMenuItem(
                                            value: 'rename',
                                            child: Text('Rename'),
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Text(
                                              'Delete folder',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(
                                    folder.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.xxs),
                                  Text(
                                    '$docsInFolder ${docsInFolder == 1 ? 'document' : 'documents'}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: isDark
                                          ? AppColors.darkTextMuted
                                          : AppColors.lightTextMuted,
                                    ),
                                  ),
                                ],
                              ),
                            );
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
