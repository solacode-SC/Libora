import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_section_header.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
              AppSectionHeader(
                eyebrow: 'REMOTE BOOKSHELF',
                title: 'Explore',
                subtitle: 'Discover and selectively download documents from connected GitHub repositories.',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppBadge(label: 'GITHUB REMOTE'),
                    const SizedBox(width: AppSpacing.sm),
                    AppButton.secondary(
                      label: 'Sync Repositories',
                      icon: Icons.sync_rounded,
                      size: AppButtonSize.small,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Repository synchronization will be implemented in Phase 5',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                showBottomBorder: true,
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: AppEmptyState(
                  icon: Icons.explore_outlined,
                  title: 'No remote repositories connected',
                  description: 'Connect a GitHub repository in Settings or GitHub tab to browse remote chapters and books without downloading entire archives.',
                  actionLabel: 'Connect Repository',
                  actionIcon: Icons.hub_outlined,
                  onAction: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'GitHub repository connection will be implemented in Phase 4',
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
