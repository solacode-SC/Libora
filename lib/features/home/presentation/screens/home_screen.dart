import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Editorial Hero Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YOUR BOOKSHELF',
                    style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'A quiet place for your books.',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Read locally downloaded PDFs or explore documents from connected repositories.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              Divider(color: borderColor, height: 1.0),
              const SizedBox(height: AppSpacing.xxl),

              // Section 1: Continue Reading
              const AppSectionHeader(
                eyebrow: 'READING PROGRESS',
                title: 'Continue Reading',
                subtitle: 'Pick up right where you left off',
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cover preview placeholder
                        Container(
                          width: 52,
                          height: 72,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurfaceSubtle
                                : AppColors.lightSurfaceSubtle,
                            borderRadius: AppSpacing.roundedXs,
                            border: Border.all(color: borderColor, width: 1.0),
                          ),
                          child: Icon(
                            Icons.menu_book_rounded,
                            size: 24,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: AppSpacing.xs,
                                runSpacing: AppSpacing.xxs,
                                children: [
                                  const AppBadge(label: 'LOCAL'),
                                  Text(
                                    'Page 42 of 120',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Design Patterns & Minimal Architecture',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                'Local Library • Added recently',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Reading Gauge (Inspired by Reference Design's Weight Gauge)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 6.0,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurfaceSubtle
                                  : AppColors.lightSurfaceSubtle,
                              borderRadius: AppSpacing.roundedXs,
                              border: Border.all(
                                color: borderColor,
                                width: 0.5,
                              ),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.35,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.strongCharcoal,
                                  borderRadius: AppSpacing.roundedXs,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '35%',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        AppButton.ghost(
                          label: 'View in Library',
                          size: AppButtonSize.small,
                          onPressed: () => context.go('/library'),
                        ),
                        AppButton.primary(
                          label: 'Resume Reading',
                          icon: Icons.play_arrow_rounded,
                          size: AppButtonSize.small,
                          onPressed: () => context.push('/reader/demo-pdf-1'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Section 2: Quick Collections
              const AppSectionHeader(
                eyebrow: 'BROWSE',
                title: 'Collections',
                subtitle: 'Filter and organize your reading materials',
              ),
              const SizedBox(height: AppSpacing.md),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 560;
                  final items = const [
                    (
                      icon: Icons.star_outline_rounded,
                      title: 'Favorites',
                      subtitle: 'Starred items',
                      route: '/favorites',
                    ),
                    (
                      icon: Icons.bookmark_outline_rounded,
                      title: 'Bookmarks',
                      subtitle: 'Saved pages',
                      route: '/bookmarks',
                    ),
                    (
                      icon: Icons.folder_outlined,
                      title: 'Folders',
                      subtitle: 'Custom series',
                      route: '/folders',
                    ),
                  ];

                  if (isCompact) {
                    return Column(
                      children: [
                        for (int i = 0; i < items.length; i++) ...[
                          if (i > 0) const SizedBox(height: AppSpacing.xs),
                          _CollectionCard(
                            icon: items[i].icon,
                            title: items[i].title,
                            subtitle: items[i].subtitle,
                            route: items[i].route,
                            compact: true,
                          ),
                        ],
                      ],
                    );
                  }

                  return Row(
                    children: [
                      for (int i = 0; i < items.length; i++) ...[
                        if (i > 0) const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _CollectionCard(
                            icon: items[i].icon,
                            title: items[i].title,
                            subtitle: items[i].subtitle,
                            route: items[i].route,
                            compact: false,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final bool compact;

  const _CollectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (compact) {
      return AppCard(
        onTap: () => context.go(route),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.strongCharcoal,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
          ],
        ),
      );
    }

    return AppCard(
      onTap: () => context.go(route),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.strongCharcoal,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(subtitle, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
