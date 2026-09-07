import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libora/core/widgets/app_button.dart';

void main() {
  group('AppButton Dimension Stability Tests', () {
    testWidgets('AppButton maintains exact dimensions during hover and press', (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppButton.secondary(
                label: 'Test Button',
                icon: Icons.add,
                onPressed: () => pressed = true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final initialBox = tester.renderObject<RenderBox>(find.byType(AppButton));
      final initialSize = initialBox.size;
      expect(initialSize.height, equals(38.0));

      // Simulate mouse hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(find.byType(AppButton)));
      await tester.pumpAndSettle();

      final hoveredBox = tester.renderObject<RenderBox>(find.byType(AppButton));
      expect(hoveredBox.size, equals(initialSize), reason: 'Button must not change size on hover');

      // Click button
      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
      final postClickBox = tester.renderObject<RenderBox>(find.byType(AppButton));
      expect(postClickBox.size, equals(initialSize), reason: 'Button must not change size after click');
    });

    testWidgets('AppIconButton maintains exact dimensions during hover', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppIconButton(
                icon: Icons.settings,
                onPressed: () {},
                size: 36.0,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final box = tester.renderObject<RenderBox>(find.byType(AppIconButton));
      expect(box.size, equals(const Size(36.0, 36.0)));

      // Hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(find.byType(AppIconButton)));
      await tester.pumpAndSettle();

      final hoveredBox = tester.renderObject<RenderBox>(find.byType(AppIconButton));
      expect(hoveredBox.size, equals(const Size(36.0, 36.0)));
    });
  });
}
