import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/app_database.dart';
import '../../../../database/daos/bookmarks_dao.dart';
import '../../domain/models/bookmark_item.dart';

abstract class BookmarkRepository {
  Stream<List<BookmarkItem>> watchBookmarksForPdf(String pdfId);
  Future<List<BookmarkItem>> getBookmarksForPdf(String pdfId);
  Stream<List<BookmarkItem>> watchAllBookmarks();
  Future<BookmarkItem?> getBookmarkByPage(String pdfId, int pageNumber);
  Future<int> getBookmarkCountForPdf(String pdfId);
  Future<void> addBookmark(BookmarkItem bookmark);
  Future<void> updateBookmark(BookmarkItem bookmark);
  Future<void> deleteBookmark(String id);
  Future<void> deleteBookmarksForPdf(String pdfId);
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
      note: entry.note,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
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
  Future<BookmarkItem?> getBookmarkByPage(String pdfId, int pageNumber) async {
    final entry = await _dao.getBookmarkByPage(pdfId, pageNumber);
    return entry != null ? _toItem(entry) : null;
  }

  @override
  Future<int> getBookmarkCountForPdf(String pdfId) {
    return _dao.getBookmarkCountForPdf(pdfId);
  }

  @override
  Future<void> addBookmark(BookmarkItem bookmark) async {
    final companion = BookmarksCompanion(
      id: Value(bookmark.id),
      pdfId: Value(bookmark.pdfId),
      pageNumber: Value(bookmark.pageNumber),
      label: Value(bookmark.label),
      note: Value(bookmark.note),
      createdAt: Value(bookmark.createdAt),
      updatedAt: Value(bookmark.updatedAt),
    );
    await _dao.insertBookmark(companion);
  }

  @override
  Future<void> updateBookmark(BookmarkItem bookmark) async {
    final companion = BookmarksCompanion(
      id: Value(bookmark.id),
      pdfId: Value(bookmark.pdfId),
      pageNumber: Value(bookmark.pageNumber),
      label: Value(bookmark.label),
      note: Value(bookmark.note),
      createdAt: Value(bookmark.createdAt),
      updatedAt: Value(DateTime.now()),
    );
    await _dao.updateBookmark(companion);
  }

  @override
  Future<void> deleteBookmark(String id) async {
    await _dao.deleteBookmark(id);
  }

  @override
  Future<void> deleteBookmarksForPdf(String pdfId) async {
    await _dao.deleteBookmarksForPdf(pdfId);
  }
}

final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftBookmarkRepository(db.bookmarksDao);
});
