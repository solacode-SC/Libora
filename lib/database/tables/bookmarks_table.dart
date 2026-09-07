import 'package:drift/drift.dart';

@DataClassName('BookmarkEntry')
class Bookmarks extends Table {
  TextColumn get id => text()();
  TextColumn get pdfId => text()();
  IntColumn get pageNumber => integer()();
  TextColumn get label => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
