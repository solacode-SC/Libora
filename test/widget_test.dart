import 'package:flutter_test/flutter_test.dart';
import 'package:libora/app/app.dart';

import 'helpers/test_database.dart';

void main() {
  testWidgets('LiboraApp root widget smoke test', (WidgetTester tester) async {
    final db = createTestDatabase();

    await tester.pumpWidget(createTestApp(db));
    await tester.pumpAndSettle();

    expect(find.byType(LiboraApp), findsOneWidget);

    await tearDownTestApp(tester, db);
  });
}
