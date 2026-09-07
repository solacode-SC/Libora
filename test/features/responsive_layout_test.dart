import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libora/app/app.dart';
import 'package:libora/core/widgets/app_sidebar.dart';

void main() {
  const testWidths = [
    375.0, // Compact Mobile
    390.0, // Standard Mobile
    600.0, // Tablet Boundary
    768.0, // Tablet
    1024.0, // Desktop Boundary
    1280.0, // Desktop Standard
    1440.0, // Desktop Wide
    1920.0, // Desktop Ultra-wide
  ];

  for (final width in testWidths) {
    testWidgets(
      'Renders Home and Library cleanly without overflow at ${width.toInt()}px width',
      (tester) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(const ProviderScope(child: LiboraApp()));
        await tester.pumpAndSettle();

        // Ensure no exceptions occurred during build/layout
        expect(tester.takeException(), isNull);

        if (width > 1024.0) {
          expect(find.byType(AppSidebar), findsOneWidget);
          await tester.tap(find.text('Home'));
        } else {
          expect(find.byType(NavigationBar), findsOneWidget);
          await tester.tap(find.text('Home'));
        }
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  }
}
