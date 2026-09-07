import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/theme_mode_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section_header.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.xl,
          ),
          children: [
            const AppSectionHeader(
              eyebrow: 'PREFERENCES',
              title: 'Settings',
              subtitle:
                  'Manage appearance, theme mode, and reading environment.',
              showBottomBorder: true,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Appearance Section
            Text(
              'APPEARANCE',
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Theme Mode',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'Choose between light paper, dark charcoal, or system default.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Responsive Theme Selector
                  Row(
                    children: [
                      Expanded(
                        child: _ThemeOptionCard(
                          label: 'System',
                          icon: Icons.brightness_auto_rounded,
                          isSelected: themeMode == ThemeMode.system,
                          onTap: () => ref
                              .read(themeModeProvider.notifier)
                              .setThemeMode(ThemeMode.system),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _ThemeOptionCard(
                          label: 'Light',
                          icon: Icons.wb_sunny_outlined,
                          isSelected: themeMode == ThemeMode.light,
                          onTap: () => ref
                              .read(themeModeProvider.notifier)
                              .setThemeMode(ThemeMode.light),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _ThemeOptionCard(
                          label: 'Dark',
                          icon: Icons.nightlight_outlined,
                          isSelected: themeMode == ThemeMode.dark,
                          onTap: () => ref
                              .read(themeModeProvider.notifier)
                              .setThemeMode(ThemeMode.dark),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // About Section
            Text(
              'APPLICATION',
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurfaceSubtle
                          : AppColors.lightSurfaceSubtle,
                      borderRadius: AppSpacing.roundedSm,
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                        width: 1.0,
                      ),
                    ),
                    child: Icon(
                      Icons.menu_book_rounded,
                      size: 20,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.strongCharcoal,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstants.appName,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Version ${AppConstants.appVersion} • Local-First Personal Bookshelf',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOptionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedBg = isDark
        ? AppColors.darkSubtleAccent
        : AppColors.warmBeige;
    final defaultBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    final selectedBorder = isDark
        ? AppColors.darkTextPrimary
        : AppColors.strongCharcoal;
    final defaultBorder = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.roundedSm,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : defaultBg,
          borderRadius: AppSpacing.roundedSm,
          border: Border.all(
            color: isSelected ? selectedBorder : defaultBorder,
            width: 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? (isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary)
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary)
                    : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
