import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_section_header.dart';

class GitHubScreen extends StatelessWidget {
  const GitHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                eyebrow: 'REMOTE STORAGE',
                title: 'GitHub Repositories',
                subtitle: 'Connect GitHub repositories to explore, preview, and selectively sync PDFs.',
                trailing: AppButton.primary(
                  label: 'Connect Repository',
                  icon: Icons.link_rounded,
                  size: AppButtonSize.small,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'GitHub repository connection will be implemented in Phase 4',
                        ),
                      ),
                    );
                  },
                ),
                showBottomBorder: true,
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: AppEmptyState(
                  icon: Icons.hub_outlined,
                  title: 'No repositories connected',
                  description: 'Connect a GitHub repository with your personal access token to explore remote documents without downloading entire archives.',
                  actionLabel: 'Add Repository',
                  actionIcon: Icons.add_link_rounded,
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
