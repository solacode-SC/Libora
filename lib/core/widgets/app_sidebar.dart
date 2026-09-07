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

  static const List<NavDestination> mainDestinations = [
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
  ];

  static const List<NavDestination> collectionDestinations = [
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

  static const List<NavDestination> utilityDestinations = [
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

  // Backward compatibility alias for tests
  static List<NavDestination> get primaryDestinations => [
    ...mainDestinations,
    ...collectionDestinations,
  ];
  static List<NavDestination> get secondaryDestinations => utilityDestinations;

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
        border: Border(right: BorderSide(color: borderColor, width: 1.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Minimalist Header / Brand
          Container(
            height: AppSpacing.topBarHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.strongCharcoal,
                    borderRadius: AppSpacing.roundedSm,
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: isDark
                        ? AppColors.darkBackground
                        : AppColors.lightSurface,
                    size: 15,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Libora',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'BOOKSHELF',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: borderColor, height: 1.0),

          // Main Navigation List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.md,
              ),
              children: [
                for (final item in mainDestinations)
                  _SidebarNavItem(
                    destination: item,
                    isSelected: currentRoute == item.route,
                    onTap: () => onNavigate(item.route),
                  ),

                const SizedBox(height: AppSpacing.md),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xxs,
                  ),
                  child: Text(
                    'COLLECTIONS',
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.4,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),

                for (final item in collectionDestinations)
                  _SidebarNavItem(
                    destination: item,
                    isSelected: currentRoute == item.route,
                    onTap: () => onNavigate(item.route),
                  ),
              ],
            ),
          ),

          Divider(color: borderColor, height: 1.0),
          // Utility Navigation (GitHub, Settings)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              children: [
                for (final item in utilityDestinations)
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

class _SidebarNavItem extends StatefulWidget {
  final NavDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarNavItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedBg = isDark
        ? AppColors.darkSurfaceSubtle
        : AppColors.lightSurfaceSubtle;
    final hoverBg = isDark
        ? AppColors.darkSurfaceSubtle.withAlpha(120)
        : AppColors.lightSurfaceSubtle.withAlpha(150);

    final bg = widget.isSelected
        ? selectedBg
        : (_isHovered ? hoverBg : Colors.transparent);

    final textColor = widget.isSelected
        ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);

    final iconColor = widget.isSelected
        ? (isDark ? AppColors.darkTextPrimary : AppColors.strongCharcoal)
        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            height: AppSpacing.navItemHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: AppSpacing.roundedSm,
              border: Border.all(
                color: widget.isSelected
                    ? (isDark
                          ? AppColors.darkBorderStrong
                          : AppColors.lightBorderStrong)
                    : Colors.transparent,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.isSelected
                      ? widget.destination.selectedIcon
                      : widget.destination.icon,
                  size: AppSpacing.iconMd,
                  color: iconColor,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  widget.destination.label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontSize: 13.5,
                    fontWeight: widget.isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: textColor,
                    letterSpacing: -0.1,
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
