import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';

class BookmarkDialogResult {
  final String? label;
  final String? note;
  final bool isDelete;

  const BookmarkDialogResult({this.label, this.note, this.isDelete = false});
}

/// Dialog for creating or editing a bookmark on a specific PDF page.
class BookmarkDialog extends StatefulWidget {
  final int pageNumber;
  final String? initialLabel;
  final String? initialNote;
  final bool isEditing;

  const BookmarkDialog({
    super.key,
    required this.pageNumber,
    this.initialLabel,
    this.initialNote,
    this.isEditing = false,
  });

  /// Shows the bookmark dialog.
  static Future<BookmarkDialogResult?> show(
    BuildContext context, {
    required int pageNumber,
    String? initialLabel,
    String? initialNote,
    bool isEditing = false,
  }) {
    return showDialog<BookmarkDialogResult>(
      context: context,
      builder: (context) => BookmarkDialog(
        pageNumber: pageNumber,
        initialLabel: initialLabel,
        initialNote: initialNote,
        isEditing: isEditing,
      ),
    );
  }

  @override
  State<BookmarkDialog> createState() => _BookmarkDialogState();
}

class _BookmarkDialogState extends State<BookmarkDialog> {
  late final TextEditingController _labelController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.initialLabel ?? '');
    _noteController = TextEditingController(text: widget.initialNote ?? '');
  }

  @override
  void dispose() {
    _labelController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onSave() {
    final label = _labelController.text.trim();
    final note = _noteController.text.trim();

    Navigator.of(context).pop(
      BookmarkDialogResult(
        label: label.isNotEmpty ? label : null,
        note: note.isNotEmpty ? note : null,
      ),
    );
  }

  void _onDelete() {
    Navigator.of(context).pop(const BookmarkDialogResult(isDelete: true));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedXl),
      title: Row(
        children: [
          Icon(
            widget.isEditing
                ? Icons.bookmark_rounded
                : Icons.bookmark_add_outlined,
            size: 20,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.strongCharcoal,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            widget.isEditing
                ? 'Edit Bookmark'
                : 'Bookmark Page ${widget.pageNumber}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Label (optional)',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: secondaryColor,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            TextField(
              controller: _labelController,
              autofocus: !widget.isEditing,
              decoration: const InputDecoration(
                hintText: 'e.g. Key Concept, Chapter 4',
              ),
              onSubmitted: (_) => _onSave(),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Note (optional)',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: secondaryColor,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            TextField(
              controller: _noteController,
              maxLines: 3,
              minLines: 2,
              decoration: const InputDecoration(
                hintText: 'Add a personal note or quote...',
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (widget.isEditing)
          TextButton(
            onPressed: _onDelete,
            child: Text(
              'Delete',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: TextStyle(color: secondaryColor)),
        ),
        AppButton.primary(
          label: widget.isEditing ? 'Save' : 'Save Bookmark',
          size: AppButtonSize.small,
          onPressed: _onSave,
        ),
      ],
    );
  }
}
