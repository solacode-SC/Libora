import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

class NavDestination {
  final String label;
  final String route;
  final IconData icon;
  final IconData selectedIcon;

  const NavDestination({
    required this.label,
    required this.route,
    required this.icon,
    required this.selectedIcon,
  });
}

class AppSidebar extends StatelessWidget {
  final String currentRoute;
  final ValueChanged<String> onNavigate;

  const AppSidebar({
    super.key,
    required this.currentRoute,
    required this.onNavigate,
  });

  static const List<NavDestination> primaryDestinations = [
    NavDestination(
      label: 'Home',
      route: '/home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    NavDestination(
      label: 'My Library',
      route: '/library',
      icon: Icons.local_library_outlined,
      selectedIcon: Icons.local_library_rounded,
    ),
    NavDestination(
      label: 'Explore',
      route: '/explore',
      icon: Icons.explore_outlined,
      selectedIcon: Icons.explore_rounded,
    ),
    NavDestination(
      label: 'Favorites',
      route: '/favorites',
      icon: Icons.star_outline_rounded,
      selectedIcon: Icons.star_rounded,
    ),
    NavDestination(
      label: 'Bookmarks',
      route: '/bookmarks',
      icon: Icons.bookmark_outline_rounded,
      selectedIcon: Icons.bookmark_rounded,
    ),
    NavDestination(
      label: 'Folders',
      route: '/folders',
      icon: Icons.folder_outlined,
      selectedIcon: Icons.folder_rounded,
    ),
  ];

  static const List<NavDestination> secondaryDestinations = [
    NavDestination(
      label: 'GitHub',
      route: '/github',
      icon: Icons.hub_outlined,
      selectedIcon: Icons.hub_rounded,
    ),
    NavDestination(
      label: 'Settings',
      route: '/settings',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      width: AppSpacing.sidebarWidth,
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(right: BorderSide(color: borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header / Logo
          Container(
            height: AppSpacing.topBarHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: AppSpacing.roundedSm,
                  ),
                  child: const Icon(
                    Icons.auto_stories_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Libora',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          // Primary navigation list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              children: [
                for (final item in primaryDestinations)
                  _SidebarNavItem(
                    destination: item,
                    isSelected: currentRoute == item.route,
                    onTap: () => onNavigate(item.route),
                  ),
              ],
            ),
          ),

          const Divider(),
          // Secondary navigation (GitHub, Settings)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              children: [
                for (final item in secondaryDestinations)
                  _SidebarNavItem(
                    destination: item,
                    isSelected: currentRoute == item.route,
                    onTap: () => onNavigate(item.route),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  final NavDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarNavItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedColor = theme.colorScheme.primary;
    final selectedBg = isDark
        ? AppColors.primary.withAlpha(50)
        : AppColors.primary.withAlpha(25);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Material(
        color: isSelected ? selectedBg : Colors.transparent,
        borderRadius: AppSpacing.roundedSm,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppSpacing.roundedSm,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 10,
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? destination.selectedIcon : destination.icon,
                  size: AppSpacing.iconMd,
                  color: isSelected
                      ? selectedColor
                      : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  destination.label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? selectedColor
                        : (isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
