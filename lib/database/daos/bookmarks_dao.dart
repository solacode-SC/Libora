import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/bookmarks_table.dart';

part 'bookmarks_dao.g.dart';

@DriftAccessor(tables: [Bookmarks])
class BookmarksDao extends DatabaseAccessor<AppDatabase>
    with _$BookmarksDaoMixin {
  BookmarksDao(super.db);

  Stream<List<BookmarkEntry>> watchBookmarksForPdf(String pdfId) =>
      (select(bookmarks)
            ..where((t) => t.pdfId.equals(pdfId))
            ..orderBy([(t) => OrderingTerm.asc(t.pageNumber)]))
          .watch();

  Future<List<BookmarkEntry>> getBookmarksForPdf(String pdfId) =>
      (select(bookmarks)
            ..where((t) => t.pdfId.equals(pdfId))
            ..orderBy([(t) => OrderingTerm.asc(t.pageNumber)]))
          .get();

  Stream<List<BookmarkEntry>> watchAllBookmarks() => (select(
    bookmarks,
  )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();

  Future<int> insertBookmark(BookmarksCompanion bookmark) =>
      into(bookmarks).insert(bookmark);

  Future<int> deleteBookmark(String id) =>
      (delete(bookmarks)..where((t) => t.id.equals(id))).go();
}
