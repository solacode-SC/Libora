import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';

class ReaderScreen extends StatelessWidget {
  final String pdfId;

  const ReaderScreen({super.key, required this.pdfId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: borderColor, height: 1.0),
        ),
        leading: AppIconButton(
          icon: Icons.arrow_back_rounded,
          tooltip: 'Back to library',
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Text(
              'Document: $pdfId',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const AppBadge(label: 'READING'),
          ],
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          constraints: const BoxConstraints(maxWidth: 440),
          child: AppCard(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 40,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.strongCharcoal,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Reading View Placeholder',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Hardware-accelerated PDF rendering with pdfrx and bookmarking controls will be connected in Phase 2.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton.secondary(
                  label: 'Return to Library',
                  icon: Icons.arrow_back_rounded,
                  onPressed: () => context.pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
