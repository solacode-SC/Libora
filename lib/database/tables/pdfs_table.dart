import 'package:drift/drift.dart';

@DataClassName('PdfEntry')
class Pdfs extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get fileName => text()();
  TextColumn get localPath => text().nullable()();
  TextColumn get remotePath => text().nullable()();
  TextColumn get coverPath => text().nullable()();
  IntColumn get pageCount => integer().nullable()();
  IntColumn get fileSize => integer().nullable()();
  TextColumn get folderId => text().nullable()();
  TextColumn get source => text().withDefault(const Constant('local'))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  IntColumn get currentPage => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get lastReadAt => dateTime().nullable()();
  TextColumn get fileHash => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
