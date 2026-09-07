import 'package:drift/drift.dart';

import 'pdfs_table.dart';

@DataClassName('BookmarkEntry')
class Bookmarks extends Table {
  TextColumn get id => text()();
  TextColumn get pdfId =>
      text().references(Pdfs, #id, onDelete: KeyAction.cascade)();
  IntColumn get pageNumber => integer()();
  TextColumn get label => text().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {pdfId, pageNumber},
  ];
}
