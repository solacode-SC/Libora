import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import 'app_empty_state.dart';
import 'app_section_header.dart';

class PlaceholderPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<Widget>? actions;
  final Widget? customContent;
  final String? eyebrow;

  const PlaceholderPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.actions,
    this.customContent,
    this.eyebrow,
  });

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
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with actions
              AppSectionHeader(
                eyebrow: eyebrow ?? 'LIBORA',
                title: title,
                subtitle: description,
                trailing: actions != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int i = 0; i < actions!.length; i++) ...[
                            if (i > 0) const SizedBox(width: AppSpacing.xs),
                            actions![i],
                          ],
                        ],
                      )
                    : null,
                showBottomBorder: true,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Content or Minimal Editorial Empty State
              Expanded(
                child:
                    customContent ??
                    AppEmptyState(
                      icon: icon,
                      title: title,
                      description: description,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
