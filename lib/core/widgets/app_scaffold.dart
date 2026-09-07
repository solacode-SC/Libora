import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import 'app_sidebar.dart';
import 'responsive_layout.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  static int _calculateBottomNavIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/library')) return 1;
    if (location.startsWith('/explore')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 1; // Default to Library
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return ResponsiveLayout(
      desktop: (context) =>
          _DesktopScaffold(currentRoute: location, child: child),
      tablet: (context) =>
          _MobileScaffold(currentRoute: location, child: child),
      mobile: (context) =>
          _MobileScaffold(currentRoute: location, child: child),
    );
  }
}

class _DesktopScaffold extends StatelessWidget {
  final String currentRoute;
  final Widget child;

  const _DesktopScaffold({required this.currentRoute, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Row(
        children: [
          AppSidebar(
            currentRoute: currentRoute,
            onNavigate: (route) => context.go(route),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _MobileScaffold extends StatelessWidget {
  final String currentRoute;
  final Widget child;

  const _MobileScaffold({required this.currentRoute, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final navIndex = AppScaffold._calculateBottomNavIndex(currentRoute);

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
        title: Row(
          children: [
            Container(
              width: 24,
              height: 24,
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
                size: 13,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Libora',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
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
                    Text(
                      'Libora',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: borderColor, height: 1.0),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.sm,
                  ),
                  children: [
                    for (final item in AppSidebar.mainDestinations)
                      ListTile(
                        dense: true,
                        leading: Icon(
                          currentRoute == item.route
                              ? item.selectedIcon
                              : item.icon,
                          size: AppSpacing.iconMd,
                          color: currentRoute == item.route
                              ? (isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.strongCharcoal)
                              : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary),
                        ),
                        title: Text(item.label),
                        selected: currentRoute == item.route,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppSpacing.roundedSm,
                        ),
                        selectedTileColor: isDark
                            ? AppColors.darkSurfaceSubtle
                            : AppColors.lightSurfaceSubtle,
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go(item.route);
                        },
                      ),
                    const SizedBox(height: AppSpacing.sm),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xxs,
                      ),
                      child: Text(
                        'COLLECTIONS',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.4,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ),
                    for (final item in AppSidebar.collectionDestinations)
                      ListTile(
                        dense: true,
                        leading: Icon(
                          currentRoute == item.route
                              ? item.selectedIcon
                              : item.icon,
                          size: AppSpacing.iconMd,
                          color: currentRoute == item.route
                              ? (isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.strongCharcoal)
                              : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary),
                        ),
                        title: Text(item.label),
                        selected: currentRoute == item.route,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppSpacing.roundedSm,
                        ),
                        selectedTileColor: isDark
                            ? AppColors.darkSurfaceSubtle
                            : AppColors.lightSurfaceSubtle,
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go(item.route);
                        },
                      ),
                    Divider(color: borderColor, height: AppSpacing.lg),
                    for (final item in AppSidebar.utilityDestinations)
                      ListTile(
                        dense: true,
                        leading: Icon(
                          currentRoute == item.route
                              ? item.selectedIcon
                              : item.icon,
                          size: AppSpacing.iconMd,
                          color: currentRoute == item.route
                              ? (isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.strongCharcoal)
                              : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary),
                        ),
                        title: Text(item.label),
                        selected: currentRoute == item.route,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppSpacing.roundedSm,
                        ),
                        selectedTileColor: isDark
                            ? AppColors.darkSurfaceSubtle
                            : AppColors.lightSurfaceSubtle,
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go(item.route);
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: borderColor, width: 1.0)),
        ),
        child: NavigationBar(
          height: 62,
          selectedIndex: navIndex,
          onDestinationSelected: (index) {
            switch (index) {
              case 0:
                context.go('/home');
                break;
              case 1:
                context.go('/library');
                break;
              case 2:
                context.go('/explore');
                break;
              case 3:
                context.go('/settings');
                break;
            }
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_library_outlined),
              selectedIcon: Icon(Icons.local_library_rounded),
              label: 'Library',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore_rounded),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
