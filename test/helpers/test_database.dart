import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libora/app/app.dart';
import 'package:libora/database/app_database.dart';

/// Creates an isolated in-memory Drift database instance for testing.
AppDatabase createTestDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(NativeDatabase.memory());
}

/// Wraps [LiboraApp] in a [ProviderScope] with an in-memory test database override.
Widget createTestApp(AppDatabase db) {
  return ProviderScope(
    overrides: [appDatabaseProvider.overrideWithValue(db)],
    child: const LiboraApp(),
  );
}

/// Flushes pending timers and safely closes the database after test execution.
Future<void> tearDownTestApp(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 10));
  await db.close();
}
