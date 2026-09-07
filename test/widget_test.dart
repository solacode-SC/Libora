import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libora/app/app.dart';

void main() {
  testWidgets('LiboraApp root widget smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: LiboraApp()));
    await tester.pumpAndSettle();

    expect(find.byType(LiboraApp), findsOneWidget);
  });
}
