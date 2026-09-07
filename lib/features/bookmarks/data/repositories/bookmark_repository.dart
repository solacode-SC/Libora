import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/app_database.dart';
import '../../../../database/daos/bookmarks_dao.dart';
import '../../domain/models/bookmark_item.dart';

abstract class BookmarkRepository {
  Stream<List<BookmarkItem>> watchBookmarksForPdf(String pdfId);
  Future<List<BookmarkItem>> getBookmarksForPdf(String pdfId);
  Stream<List<BookmarkItem>> watchAllBookmarks();
  Future<void> addBookmark(BookmarkItem bookmark);
  Future<void> deleteBookmark(String id);
}

class DriftBookmarkRepository implements BookmarkRepository {
  final BookmarksDao _dao;

  DriftBookmarkRepository(this._dao);

  static BookmarkItem _toItem(BookmarkEntry entry) {
    return BookmarkItem(
      id: entry.id,
      pdfId: entry.pdfId,
      pageNumber: entry.pageNumber,
      label: entry.label,
      createdAt: entry.createdAt,
    );
  }

  @override
  Stream<List<BookmarkItem>> watchBookmarksForPdf(String pdfId) {
    return _dao
        .watchBookmarksForPdf(pdfId)
        .map((entries) => entries.map(_toItem).toList());
  }

  @override
  Future<List<BookmarkItem>> getBookmarksForPdf(String pdfId) async {
    final entries = await _dao.getBookmarksForPdf(pdfId);
    return entries.map(_toItem).toList();
  }

  @override
  Stream<List<BookmarkItem>> watchAllBookmarks() {
    return _dao.watchAllBookmarks().map(
      (entries) => entries.map(_toItem).toList(),
    );
  }

  @override
  Future<void> addBookmark(BookmarkItem bookmark) async {
    final companion = BookmarksCompanion(
      id: Value(bookmark.id),
      pdfId: Value(bookmark.pdfId),
      pageNumber: Value(bookmark.pageNumber),
      label: Value(bookmark.label),
      createdAt: Value(bookmark.createdAt),
    );
    await _dao.insertBookmark(companion);
  }

  @override
  Future<void> deleteBookmark(String id) async {
    await _dao.deleteBookmark(id);
  }
}

final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftBookmarkRepository(db.bookmarksDao);
});
