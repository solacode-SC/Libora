import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_database.dart';

void main() {
  testWidgets(
    'App launches with ProviderScope and mounts Library screen by default',
    (tester) async {
      final db = createTestDatabase();
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestApp(db));
      await tester.pumpAndSettle();

      // Verify app title in desktop sidebar
      expect(find.text('Libora'), findsOneWidget);
      // Verify default screen is Library
      expect(find.text('My Library'), findsWidgets);
      // Verify sidebar navigation items
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('Favorites'), findsWidgets);
      expect(find.text('Settings'), findsOneWidget);

      await tearDownTestApp(tester, db);
    },
  );

  testWidgets('Navigation switches destinations when clicked in sidebar', (
    tester,
  ) async {
    final db = createTestDatabase();
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createTestApp(db));
    await tester.pumpAndSettle();

    // Click on Explore in sidebar
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();

    expect(find.text('Sync Repositories'), findsOneWidget);

    // Click on Settings in sidebar
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('APPEARANCE'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);

    await tearDownTestApp(tester, db);
  });

  testWidgets('Mobile view renders bottom navigation bar and drawer', (
    tester,
  ) async {
    final db = createTestDatabase();
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createTestApp(db));
    await tester.pumpAndSettle();

    // Verify mobile navigation bar is present
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);

    await tearDownTestApp(tester, db);
  });
}
