import 'package:drift/native.dart';
import 'package:libora/database/app_database.dart';

/// Creates an isolated in-memory Drift database instance for testing.
AppDatabase createTestDatabase() {
  return AppDatabase(NativeDatabase.memory());
}
