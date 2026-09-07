import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/app_database.dart';
import '../../../../database/daos/bookmarks_dao.dart';
import '../../../../database/daos/pdfs_dao.dart';
import '../../domain/models/pdf_item.dart';

abstract class PdfRepository {
  Stream<List<PdfItem>> watchAllPdfs();
  Future<List<PdfItem>> getAllPdfs();
  Stream<List<PdfItem>> watchFavorites();
  Stream<List<PdfItem>> watchByFolder(String folderId);
  Stream<List<PdfItem>> watchContinueReading({int limit = 6});
  Stream<List<PdfItem>> watchRecentlyAdded({int limit = 6});
  Future<List<PdfItem>> searchPdfs(String query, {String? folderId});
  Future<PdfItem?> getPdfById(String id);
  Future<void> savePdf(PdfItem pdf);
  Future<void> deletePdf(String id);
  Future<void> toggleFavorite(String id, bool isFavorite);
  Future<void> updateReadingProgress(String id, int page, {DateTime? readAt});
  Future<PdfItem?> findDuplicate({
    String? hash,
    int? fileSize,
    String? fileName,
  });
  Future<void> updateTitle(String id, String title);
  Future<void> moveToFolder(String id, String? folderId);
}

class DriftPdfRepository implements PdfRepository {
  final PdfsDao _dao;
  final BookmarksDao? _bookmarksDao;

  DriftPdfRepository(this._dao, [this._bookmarksDao]);

  static PdfItem _toItem(PdfEntry entry) {
    return PdfItem(
      id: entry.id,
      title: entry.title,
      fileName: entry.fileName,
      localPath: entry.localPath,
      remotePath: entry.remotePath,
      coverPath: entry.coverPath,
      pageCount: entry.pageCount,
      fileSize: entry.fileSize,
      folderId: entry.folderId,
      source: entry.source,
      isFavorite: entry.isFavorite,
      currentPage: entry.currentPage,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
      lastReadAt: entry.lastReadAt,
      fileHash: entry.fileHash,
    );
  }

  @override
  Stream<List<PdfItem>> watchAllPdfs() {
    return _dao.watchAllPdfs().map((entries) => entries.map(_toItem).toList());
  }

  @override
  Future<List<PdfItem>> getAllPdfs() async {
    final entries = await _dao.getAllPdfs();
    return entries.map(_toItem).toList();
  }

  @override
  Stream<List<PdfItem>> watchFavorites() {
    return _dao.watchFavorites().map(
      (entries) => entries.map(_toItem).toList(),
    );
  }

  @override
  Stream<List<PdfItem>> watchByFolder(String folderId) {
    return _dao
        .watchByFolder(folderId)
        .map((entries) => entries.map(_toItem).toList());
  }

  @override
  Stream<List<PdfItem>> watchContinueReading({int limit = 6}) {
    return _dao
        .watchContinueReading(limit: limit)
        .map((entries) => entries.map(_toItem).toList());
  }

  @override
  Stream<List<PdfItem>> watchRecentlyAdded({int limit = 6}) {
    return _dao
        .watchRecentlyAdded(limit: limit)
        .map((entries) => entries.map(_toItem).toList());
  }

  @override
  Future<List<PdfItem>> searchPdfs(String query, {String? folderId}) async {
    final entries = await _dao.searchPdfs(query, folderId: folderId);
    return entries.map(_toItem).toList();
  }

  @override
  Future<PdfItem?> getPdfById(String id) async {
    final entry = await _dao.getPdfById(id);
    return entry != null ? _toItem(entry) : null;
  }

  @override
  Future<void> savePdf(PdfItem pdf) async {
    final companion = PdfsCompanion(
      id: Value(pdf.id),
      title: Value(pdf.title),
      fileName: Value(pdf.fileName),
      localPath: Value(pdf.localPath),
      remotePath: Value(pdf.remotePath),
      coverPath: Value(pdf.coverPath),
      pageCount: Value(pdf.pageCount),
      fileSize: Value(pdf.fileSize),
      folderId: Value(pdf.folderId),
      source: Value(pdf.source),
      isFavorite: Value(pdf.isFavorite),
      currentPage: Value(pdf.currentPage),
      createdAt: Value(pdf.createdAt),
      updatedAt: Value(pdf.updatedAt),
      lastReadAt: Value(pdf.lastReadAt),
      fileHash: Value(pdf.fileHash),
    );
    await _dao.insertPdf(companion);
  }

  @override
  Future<void> deletePdf(String id) async {
    if (_bookmarksDao != null) {
      await _bookmarksDao.deleteBookmarksForPdf(id);
    }
    await _dao.deletePdf(id);
  }

  @override
  Future<void> toggleFavorite(String id, bool isFavorite) async {
    await _dao.toggleFavorite(id, isFavorite);
  }

  @override
  Future<void> updateReadingProgress(
    String id,
    int page, {
    DateTime? readAt,
  }) async {
    await _dao.updateReadingProgress(id, page, readAt: readAt);
  }

  @override
  Future<PdfItem?> findDuplicate({
    String? hash,
    int? fileSize,
    String? fileName,
  }) async {
    final entry = await _dao.findDuplicate(
      hash: hash,
      fileSize: fileSize,
      fileName: fileName,
    );
    return entry != null ? _toItem(entry) : null;
  }

  @override
  Future<void> updateTitle(String id, String title) async {
    await _dao.updateTitle(id, title);
  }

  @override
  Future<void> moveToFolder(String id, String? folderId) async {
    await _dao.moveToFolder(id, folderId);
  }
}

final pdfRepositoryProvider = Provider<PdfRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftPdfRepository(db.pdfsDao, db.bookmarksDao);
});
