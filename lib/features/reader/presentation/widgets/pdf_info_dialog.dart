import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/pdf_card.dart';
import '../controllers/reader_state.dart';

/// Dialog displaying metadata about the current PDF.
class PdfInfoDialog extends StatelessWidget {
  final ReaderState readerState;
  final String? folderName;

  const PdfInfoDialog({super.key, required this.readerState, this.folderName});

  /// Shows the PDF information dialog.
  static Future<void> show(
    BuildContext context, {
    required ReaderState readerState,
    String? folderName,
  }) {
    return showDialog(
      context: context,
      builder: (context) =>
          PdfInfoDialog(readerState: readerState, folderName: folderName),
    );
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
      title: Text(
        readerState.title ?? 'PDF Information',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (readerState.fileName != null)
            _InfoRow(label: 'File', value: readerState.fileName!, theme: theme),
          if (readerState.totalPages > 0)
            _InfoRow(
              label: 'Pages',
              value: '${readerState.totalPages}',
              theme: theme,
            ),
          if (readerState.fileSize != null && readerState.fileSize! > 0)
            _InfoRow(
              label: 'Size',
              value: PdfCard.formatFileSize(readerState.fileSize),
              theme: theme,
            ),
          if (folderName != null)
            _InfoRow(label: 'Folder', value: folderName!, theme: theme),
          if (readerState.createdAt != null)
            _InfoRow(
              label: 'Added',
              value: DateFormat.yMMMMd().format(readerState.createdAt!),
              theme: theme,
            ),
          if (readerState.lastReadAt != null)
            _InfoRow(
              label: 'Last opened',
              value: _formatLastRead(readerState.lastReadAt!),
              theme: theme,
            ),
          if (readerState.totalPages > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Text(
                  'Progress',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ClipRRect(
                    borderRadius: AppSpacing.roundedXs,
                    child: LinearProgressIndicator(
                      value: readerState.progress,
                      minHeight: 4,
                      backgroundColor: isDark
                          ? AppColors.darkSurfaceSubtle
                          : AppColors.lightSurfaceSubtle,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.strongCharcoal,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${readerState.progressPercent}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Close',
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
      ],
    );
  }

  String _formatLastRead(DateTime lastRead) {
    final now = DateTime.now();
    final diff = now.difference(lastRead);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes} min ago';
    if (diff.inDays < 1) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return DateFormat.yMMMd().format(lastRead);
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 84,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(color: secondaryColor),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
