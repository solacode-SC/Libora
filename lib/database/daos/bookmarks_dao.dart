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

  Future<BookmarkEntry?> getBookmarkByPage(String pdfId, int pageNumber) =>
      (select(bookmarks)..where(
            (t) => t.pdfId.equals(pdfId) & t.pageNumber.equals(pageNumber),
          ))
          .getSingleOrNull();

  Future<int> getBookmarkCountForPdf(String pdfId) async {
    final count = bookmarks.id.count();
    final query = selectOnly(bookmarks)
      ..addColumns([count])
      ..where(bookmarks.pdfId.equals(pdfId));
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  Future<int> insertBookmark(BookmarksCompanion bookmark) =>
      into(bookmarks).insert(bookmark);

  Future<bool> updateBookmark(BookmarksCompanion bookmark) =>
      update(bookmarks).replace(bookmark);

  Future<int> deleteBookmark(String id) =>
      (delete(bookmarks)..where((t) => t.id.equals(id))).go();

  Future<int> deleteBookmarksForPdf(String pdfId) =>
      (delete(bookmarks)..where((t) => t.pdfId.equals(pdfId))).go();
}
