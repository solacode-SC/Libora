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
    if (location.startsWith('/library')) return 0;
    if (location.startsWith('/explore')) return 1;
    if (location.startsWith('/favorites')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return ResponsiveLayout(
      desktop: (context) =>
          _DesktopScaffold(currentRoute: location, child: child),
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
    return Scaffold(
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
    final navIndex = AppScaffold._calculateBottomNavIndex(currentRoute);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppSpacing.roundedSm,
              ),
              child: const Icon(
                Icons.auto_stories_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text('Libora'),
          ],
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
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
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  children: [
                    for (final item in AppSidebar.primaryDestinations)
                      ListTile(
                        leading: Icon(
                          currentRoute == item.route
                              ? item.selectedIcon
                              : item.icon,
                          color: currentRoute == item.route
                              ? theme.colorScheme.primary
                              : null,
                        ),
                        title: Text(item.label),
                        selected: currentRoute == item.route,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppSpacing.roundedSm,
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go(item.route);
                        },
                      ),
                    const Divider(),
                    for (final item in AppSidebar.secondaryDestinations)
                      ListTile(
                        leading: Icon(
                          currentRoute == item.route
                              ? item.selectedIcon
                              : item.icon,
                          color: currentRoute == item.route
                              ? theme.colorScheme.primary
                              : null,
                        ),
                        title: Text(item.label),
                        selected: currentRoute == item.route,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppSpacing.roundedSm,
                        ),
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: navIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/library');
              break;
            case 1:
              context.go('/explore');
              break;
            case 2:
              context.go('/favorites');
              break;
            case 3:
              context.go('/settings');
              break;
          }
        },
        destinations: const [
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
            icon: Icon(Icons.star_outline_rounded),
            selectedIcon: Icon(Icons.star_rounded),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
