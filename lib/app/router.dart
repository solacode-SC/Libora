import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/app_scaffold.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/library/presentation/screens/library_screen.dart';
import '../features/explore/presentation/screens/explore_screen.dart';
import '../features/favorites/presentation/screens/favorites_screen.dart';
import '../features/bookmarks/presentation/screens/bookmarks_screen.dart';
import '../features/folders/presentation/screens/folders_screen.dart';
import '../features/github/presentation/screens/github_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/reader/presentation/screens/reader_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/library',
  routes: [
    GoRoute(path: '/', redirect: (context, state) => '/library'),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppScaffold(child: child);
      },
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/library',
          builder: (context, state) => const LibraryScreen(),
          routes: [
            GoRoute(
              path: 'folder/:folderId',
              builder: (context, state) {
                final folderId = state.pathParameters['folderId'];
                return LibraryScreen(initialFolderId: folderId);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/explore',
          builder: (context, state) => const ExploreScreen(),
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) => const FavoritesScreen(),
        ),
        GoRoute(
          path: '/bookmarks',
          builder: (context, state) => const BookmarksScreen(),
        ),
        GoRoute(
          path: '/folders',
          builder: (context, state) => const FoldersScreen(),
        ),
        GoRoute(
          path: '/github',
          builder: (context, state) => const GitHubScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
    // Fullscreen reader route (outside main AppScaffold shell)
    GoRoute(
      path: '/reader/:pdfId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final pdfId = state.pathParameters['pdfId'] ?? '';
        return ReaderScreen(pdfId: pdfId);
      },
    ),
  ],
);
