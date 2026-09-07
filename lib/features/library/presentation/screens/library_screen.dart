import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_section_header.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              AppSectionHeader(
                eyebrow: 'LOCAL BOOKSHELF',
                title: 'My Library',
                subtitle:
                    'Documents stored and imported locally on this device.',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppBadge(label: '0 BOOKS'),
                    const SizedBox(width: AppSpacing.sm),
                    AppButton.primary(
                      label: 'Import PDF',
                      icon: Icons.add_rounded,
                      size: AppButtonSize.small,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Local PDF file picker will be connected in Phase 1.',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                showBottomBorder: true,
              ),

              const SizedBox(height: AppSpacing.md),

              // Search & Filter Bar Placeholder
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
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
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Search books by title or author...',
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppButton.secondary(
                    label: 'Sort',
                    icon: Icons.sort_rounded,
                    size: AppButtonSize.small,
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // Empty Bookshelf State
              Expanded(
                child: AppEmptyState(
                  icon: Icons.local_library_outlined,
                  title: 'Your bookshelf is empty',
                  description: 'Import PDF documents from your device to begin reading and organizing your collection.',
                  actionLabel: 'Import First PDF',
                  actionIcon: Icons.add_rounded,
                  onAction: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Local PDF importing will be implemented in Phase 1',
                        ),
                      ),
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
