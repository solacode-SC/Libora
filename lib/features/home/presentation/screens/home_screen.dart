import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/breakpoints.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../library/data/repositories/pdf_repository.dart';
import '../../../library/domain/models/pdf_item.dart';
import '../widgets/continue_reading_card.dart';

final continueReadingStreamProvider = StreamProvider<List<PdfItem>>((ref) {
  final repo = ref.watch(pdfRepositoryProvider);
  return repo.watchContinueReading(limit: 6);
});

final homeFavoritesStreamProvider = StreamProvider<List<PdfItem>>((ref) {
  final repo = ref.watch(pdfRepositoryProvider);
  return repo.watchFavorites();
});

final recentlyAddedStreamProvider = StreamProvider<List<PdfItem>>((ref) {
  final repo = ref.watch(pdfRepositoryProvider);
  return repo.watchRecentlyAdded(limit: 6);
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Welcome back';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final isMobile = Breakpoints.isMobile(MediaQuery.of(context).size.width);

    final continueReadingAsync = ref.watch(continueReadingStreamProvider);
    final favoritesAsync = ref.watch(homeFavoritesStreamProvider);
    final recentlyAddedAsync = ref.watch(recentlyAddedStreamProvider);

    final inProgressPdfs = continueReadingAsync.value ?? [];
    final favoritePdfs = favoritesAsync.value ?? [];
    final recentPdfs = recentlyAddedAsync.value ?? [];

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? AppSpacing.md : AppSpacing.xxl,
            vertical: isMobile ? AppSpacing.md : AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Hero Section
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
                    '${_getGreeting()}.',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'A calm, focused place for your documents and books.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Divider(color: borderColor, height: 1.0),
              const SizedBox(height: AppSpacing.xl),

              // 1. Continue Reading (hidden if no in-progress books)
              if (inProgressPdfs.isNotEmpty) ...[
                const AppSectionHeader(
                  eyebrow: 'READING PROGRESS',
                  title: 'Continue Reading',
                  subtitle: 'Pick up right where you left off',
                ),
                const SizedBox(height: AppSpacing.md),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 640;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: inProgressPdfs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isCompact ? 1 : 2,
                        childAspectRatio: isCompact ? 2.8 : 2.5,
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                      ),
                      itemBuilder: (context, index) {
                        final pdf = inProgressPdfs[index];
                        return ContinueReadingCard(
                          pdf: pdf,
                          onTap: () => context.push('/reader/${pdf.id}'),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],

              // 2. Collections Quick Access
              const AppSectionHeader(
                eyebrow: 'BROWSE',
                title: 'Collections',
                subtitle: 'Filter and organize your reading materials',
              ),
              const SizedBox(height: AppSpacing.md),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 560;
                  final items = [
                    (
                      icon: Icons.star_outline_rounded,
                      title: 'Favorites',
                      subtitle: '${favoritePdfs.length} starred',
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
                      subtitle: 'Categories',
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

              // 3. Recently Added (or empty library callout)
              if (recentPdfs.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xxl),
                AppSectionHeader(
                  eyebrow: 'RECENTLY ADDED',
                  title: 'Latest Documents',
                  subtitle: 'Recently imported into your library',
                  trailing: TextButton(
                    onPressed: () => context.go('/library'),
                    child: const Text('View all'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentPdfs.length > 4 ? 4 : recentPdfs.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (context, index) {
                    final pdf = recentPdfs[index];
                    return AppCard(
                      onTap: () => context.push('/reader/${pdf.id}'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.picture_as_pdf_outlined,
                            size: 20,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pdf.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (pdf.pageCount != null &&
                                    pdf.pageCount! > 0) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    '${pdf.pageCount} pages',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: isDark
                                          ? AppColors.darkTextMuted
                                          : AppColors.lightTextMuted,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (pdf.isFavorite)
                            Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: Colors.amber.shade700,
                            ),
                          const SizedBox(width: AppSpacing.xs),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ] else ...[
                const SizedBox(height: AppSpacing.xxl),
                AppCard(
                  onTap: () => context.go('/library'),
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
                        ),
                        child: Icon(
                          Icons.add_circle_outline_rounded,
                          size: 22,
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
                              'Import your first PDF',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Add books and documents from your device to your library.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ],
                  ),
                ),
              ],
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
