import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../features/github/domain/models/sync_status.dart';
import '../../features/library/domain/models/pdf_item.dart';
import '../storage/pdf_storage_provider.dart';
import 'app_card.dart';

/// Reusable editorial card displaying a local PDF document in the library grid.
class PdfCard extends ConsumerWidget {
  final PdfItem pdf;
  final String? folderName;
  final SyncStatus? syncStatus;
  final VoidCallback? onTap;
  final VoidCallback? onToggleFavorite;
  final VoidCallback? onRename;
  final VoidCallback? onMoveToFolder;
  final VoidCallback? onDelete;

  const PdfCard({
    super.key,
    required this.pdf,
    this.folderName,
    this.syncStatus,
    this.onTap,
    this.onToggleFavorite,
    this.onRename,
    this.onMoveToFolder,
    this.onDelete,
  });

  static String formatFileSize(int? bytes) {
    if (bytes == null || bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final hasPhysicalFile = kIsWeb ||
        (pdf.localPath != null && File(pdf.localPath!).existsSync());
    final hasCoverFile = !kIsWeb &&
        pdf.coverPath != null &&
        File(pdf.coverPath!).existsSync();

    return AppCard(
      onTap: hasPhysicalFile ? onTap : null,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Area
          AspectRatio(
            aspectRatio: 1.35,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Cover Image or Minimal Placeholder
                if (hasCoverFile)
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSpacing.radiusLg),
                      topRight: Radius.circular(AppSpacing.radiusLg),
                    ),
                    child: Image.file(
                      File(pdf.coverPath!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(isDark, borderColor),
                    ),
                  )
                else if (kIsWeb)
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSpacing.radiusLg),
                      topRight: Radius.circular(AppSpacing.radiusLg),
                    ),
                    child: FutureBuilder<Uint8List?>(
                      future: ref
                          .watch(pdfStorageServiceProvider)
                          .readCover(pdf.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholder(isDark, borderColor),
                          );
                        }
                        return _buildPlaceholder(isDark, borderColor);
                      },
                    ),
                  )
                else
                  _buildPlaceholder(isDark, borderColor),

                // Hairline bottom border of the cover
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(height: 1.0, color: borderColor),
                ),

                // Missing file badge overlay
                if (!hasPhysicalFile)
                  Positioned(
                    top: AppSpacing.xs,
                    left: AppSpacing.xs,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade900.withValues(alpha: 0.85),
                        borderRadius: AppSpacing.roundedXs,
                      ),
                      child: const Text(
                        'FILE UNAVAILABLE',
                        style: TextStyle(
                          fontSize: 9.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                else if (syncStatus != null)
                  Positioned(
                    top: 4.0,
                    left: 4.0,
                    child: _buildSyncBadge(syncStatus!, isDark),
                  ),

                // Quick Favorite Button (Top Right)
                Positioned(
                  top: 4.0,
                  right: 4.0,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onToggleFavorite,
                      borderRadius: AppSpacing.roundedSm,
                      child: Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color:
                              (isDark
                                      ? AppColors.darkSurface
                                      : AppColors.lightSurface)
                                  .withValues(alpha: 0.75),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          pdf.isFavorite
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 16.0,
                          color: pdf.isFavorite
                              ? (isDark
                                    ? Colors.amber.shade300
                                    : Colors.amber.shade700)
                              : (isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Metadata & Content Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Context Menu
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          pdf.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.1,
                            height: 1.25,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        iconSize: 16,
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                        onSelected: (val) {
                          switch (val) {
                            case 'open':
                              if (hasPhysicalFile) onTap?.call();
                              break;
                            case 'favorite':
                              onToggleFavorite?.call();
                              break;
                            case 'move':
                              onMoveToFolder?.call();
                              break;
                            case 'rename':
                              onRename?.call();
                              break;
                            case 'delete':
                              onDelete?.call();
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          if (hasPhysicalFile)
                            const PopupMenuItem(
                              value: 'open',
                              child: Row(
                                children: [
                                  Icon(Icons.menu_book_rounded, size: 16),
                                  SizedBox(width: 8),
                                  Text('Open'),
                                ],
                              ),
                            ),
                          PopupMenuItem(
                            value: 'favorite',
                            child: Row(
                              children: [
                                Icon(
                                  pdf.isFavorite
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  pdf.isFavorite
                                      ? 'Remove Favorite'
                                      : 'Add to Favorites',
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'move',
                            child: Row(
                              children: [
                                Icon(Icons.drive_file_move_outlined, size: 16),
                                SizedBox(width: 8),
                                Text('Move to Folder'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'rename',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined, size: 16),
                                SizedBox(width: 8),
                                Text('Rename'),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline_rounded,
                                  size: 16,
                                  color: Colors.red.shade400,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Remove from library',
                                  style: TextStyle(color: Colors.red.shade400),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Folder Tag (if assigned)
                  if (folderName != null) ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.folder_outlined,
                          size: 11,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            folderName!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.5,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                  ],

                  // Metadata Details Row
                  Row(
                    children: [
                      if (pdf.pageCount != null && pdf.pageCount! > 0) ...[
                        Text(
                          '${pdf.pageCount} p.',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '•',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        formatFileSize(pdf.fileSize),
                        style: TextStyle(
                          fontSize: 10.5,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat.yMMMd().format(pdf.createdAt),
                        style: TextStyle(
                          fontSize: 10.0,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark, Color borderColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceSubtle
            : AppColors.lightSurfaceSubtle,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radiusLg),
          topRight: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: AppSpacing.roundedSm,
                border: Border.all(color: borderColor, width: 1.0),
              ),
              child: Icon(
                Icons.menu_book_rounded,
                size: 18,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'PDF',
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncBadge(SyncStatus status, bool isDark) {
    IconData icon;
    Color color;
    String tooltip;

    switch (status) {
      case SyncStatus.synced:
        icon = Icons.cloud_done_rounded;
        color = Colors.teal;
        tooltip = 'Synchronized with GitHub';
        break;
      case SyncStatus.uploadPending:
        icon = Icons.cloud_upload_outlined;
        color = Colors.amber.shade700;
        tooltip = 'Pending upload to GitHub';
        break;
      case SyncStatus.downloadPending:
        icon = Icons.cloud_download_outlined;
        color = Colors.blue;
        tooltip = 'Pending download from GitHub';
        break;
      case SyncStatus.deletePending:
        icon = Icons.delete_outline_rounded;
        color = Colors.red;
        tooltip = 'Pending deletion on GitHub';
        break;
      case SyncStatus.syncing:
        icon = Icons.sync_rounded;
        color = Colors.blue;
        tooltip = 'Syncing with GitHub...';
        break;
      case SyncStatus.conflict:
        icon = Icons.warning_amber_rounded;
        color = Colors.orange;
        tooltip = 'Sync conflict with GitHub';
        break;
      case SyncStatus.error:
        icon = Icons.error_outline_rounded;
        color = Colors.red;
        tooltip = 'Sync error';
        break;
    }

    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: (isDark ? AppColors.darkSurface : AppColors.lightSurface).withValues(alpha: 0.85),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 14.0,
          color: color,
        ),
      ),
    );
  }
}

