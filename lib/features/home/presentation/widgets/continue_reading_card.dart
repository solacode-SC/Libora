import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../library/domain/models/pdf_item.dart';

/// Editorial card highlighting in-progress PDFs on the Home dashboard.
class ContinueReadingCard extends StatelessWidget {
  final PdfItem pdf;
  final VoidCallback onTap;

  const ContinueReadingCard({
    super.key,
    required this.pdf,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    final totalPages = pdf.pageCount ?? 0;
    final currentPage = pdf.currentPage > 0 ? pdf.currentPage : 1;
    final progressFraction = totalPages > 0
        ? (currentPage / totalPages).clamp(0.0, 1.0)
        : 0.0;
    final progressPercent = (progressFraction * 100).round();

    final hasCover = pdf.coverPath != null && File(pdf.coverPath!).existsSync();

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover thumbnail
              Container(
                width: 48,
                height: 64,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceSubtle
                      : AppColors.lightSurfaceSubtle,
                  borderRadius: AppSpacing.roundedXs,
                  border: Border.all(color: borderColor, width: 1.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: hasCover
                    ? Image.file(File(pdf.coverPath!), fit: BoxFit.cover)
                    : Icon(
                        Icons.menu_book_rounded,
                        size: 22,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Title and Page numbers
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppBadge(label: 'READING'),
                        if (totalPages > 0)
                          Text(
                            'Page $currentPage of $totalPages',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: secondaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      pdf.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Reading progress gauge
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: AppSpacing.roundedXs,
                  child: LinearProgressIndicator(
                    value: progressFraction,
                    minHeight: 5,
                    backgroundColor: isDark
                        ? AppColors.darkSurfaceSubtle
                        : AppColors.lightSurfaceSubtle,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.strongCharcoal,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '$progressPercent%',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: secondaryColor,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
