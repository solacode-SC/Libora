import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../features/folders/domain/models/folder_item.dart';
import 'app_button.dart';

class LibraryDialogs {
  LibraryDialogs._();

  /// Prompts the user to create a new folder.
  static Future<String?> showCreateFolderDialog(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.roundedLg,
          ),
          title: Text(
            'New Folder',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.strongCharcoal,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Folder name (e.g. Programming)',
              filled: true,
              fillColor: isDark
                  ? AppColors.darkSurfaceSubtle
                  : AppColors.lightSurfaceSubtle,
              border: OutlineInputBorder(
                borderRadius: AppSpacing.roundedSm,
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppSpacing.roundedSm,
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1.0,
                ),
              ),
            ),
            onSubmitted: (val) {
              if (val.trim().isNotEmpty) {
                Navigator.of(context).pop(val.trim());
              }
            },
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          actions: [
            AppButton.ghost(
              label: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
            AppButton.primary(
              label: 'Create',
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  Navigator.of(context).pop(name);
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// Prompts the user to rename a PDF title.
  static Future<String?> showRenameDialog(
    BuildContext context, {
    required String currentTitle,
  }) {
    final controller = TextEditingController(text: currentTitle);
    return showDialog<String>(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.roundedLg,
          ),
          title: Text(
            'Rename Document',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.strongCharcoal,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Document title',
              filled: true,
              fillColor: isDark
                  ? AppColors.darkSurfaceSubtle
                  : AppColors.lightSurfaceSubtle,
              border: OutlineInputBorder(
                borderRadius: AppSpacing.roundedSm,
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppSpacing.roundedSm,
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1.0,
                ),
              ),
            ),
            onSubmitted: (val) {
              if (val.trim().isNotEmpty) {
                Navigator.of(context).pop(val.trim());
              }
            },
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          actions: [
            AppButton.ghost(
              label: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
            AppButton.primary(
              label: 'Save',
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  Navigator.of(context).pop(text);
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// Prompts the user to move a document to a chosen folder or to root (null).
  static Future<String?> showMoveToFolderDialog(
    BuildContext context, {
    required List<FolderItem> folders,
    required String? currentFolderId,
  }) {
    String? selected = currentFolderId;

    return showDialog<String?>(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: isDark
                  ? AppColors.darkSurface
                  : AppColors.lightSurface,
              shape: const RoundedRectangleBorder(
                borderRadius: AppSpacing.roundedLg,
              ),
              title: Text(
                'Move to Folder',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.strongCharcoal,
                ),
              ),
              content: SizedBox(
                width: 320,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        dense: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppSpacing.roundedSm,
                        ),
                        selected: selected == null,
                        selectedTileColor: isDark
                            ? AppColors.darkSurfaceSubtle
                            : AppColors.lightSurfaceSubtle,
                        leading: Icon(
                          selected == null
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_off_rounded,
                          size: 18,
                          color: selected == null
                              ? (isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.strongCharcoal)
                              : (isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted),
                        ),
                        title: const Text('No folder (Library root)'),
                        onTap: () => setState(() => selected = null),
                      ),
                      const Divider(height: 8),
                      for (final folder in folders)
                        ListTile(
                          dense: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppSpacing.roundedSm,
                          ),
                          selected: selected == folder.id,
                          selectedTileColor: isDark
                              ? AppColors.darkSurfaceSubtle
                              : AppColors.lightSurfaceSubtle,
                          leading: Icon(
                            selected == folder.id
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_off_rounded,
                            size: 18,
                            color: selected == folder.id
                                ? (isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.strongCharcoal)
                                : (isDark
                                      ? AppColors.darkTextMuted
                                      : AppColors.lightTextMuted),
                          ),
                          title: Text(folder.name),
                          onTap: () => setState(() => selected = folder.id),
                        ),
                    ],
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              actions: [
                AppButton.ghost(
                  label: 'Cancel',
                  onPressed: () => Navigator.of(context).pop(),
                ),
                AppButton.primary(
                  label: 'Move',
                  onPressed: () => Navigator.of(context).pop(selected),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Prompts the user to confirm deletion of a PDF from the library.
  static Future<bool> showConfirmDeleteDialog(
    BuildContext context, {
    required String title,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.roundedLg,
          ),
          title: Text(
            'Remove "$title"?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.strongCharcoal,
            ),
          ),
          content: Text(
            'This will remove the PDF from Libora\'s library and delete its local copy.',
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontSize: 14,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          actions: [
            AppButton.ghost(
              label: 'Cancel',
              onPressed: () => Navigator.of(context).pop(false),
            ),
            AppButton.primary(
              label: 'Remove',
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
