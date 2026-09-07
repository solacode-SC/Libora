import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/pdfs_table.dart';

part 'pdfs_dao.g.dart';

@DriftAccessor(tables: [Pdfs])
class PdfsDao extends DatabaseAccessor<AppDatabase> with _$PdfsDaoMixin {
  PdfsDao(super.db);

  Stream<List<PdfEntry>> watchAllPdfs() =>
      (select(pdfs)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();

  Future<List<PdfEntry>> getAllPdfs() =>
      (select(pdfs)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();

  Stream<List<PdfEntry>> watchFavorites() =>
      (select(pdfs)
            ..where((t) => t.isFavorite.equals(true))
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .watch();

  Stream<List<PdfEntry>> watchByFolder(String folderId) =>
      (select(pdfs)..where((t) => t.folderId.equals(folderId))).watch();

  Future<PdfEntry?> getPdfById(String id) =>
      (select(pdfs)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertPdf(PdfsCompanion pdf) => into(pdfs).insert(pdf);

  Future<bool> updatePdf(PdfsCompanion pdf) => update(pdfs).replace(pdf);

  Future<int> deletePdf(String id) =>
      (delete(pdfs)..where((t) => t.id.equals(id))).go();

  Future<int> toggleFavorite(String id, bool isFavorite) =>
      (update(pdfs)..where((t) => t.id.equals(id))).write(
        PdfsCompanion(isFavorite: Value(isFavorite)),
      );

  Future<int> updateReadingProgress(String id, int page) =>
      (update(pdfs)..where((t) => t.id.equals(id))).write(
        PdfsCompanion(
          currentPage: Value(page),
          lastReadAt: Value(DateTime.now()),
        ),
      );
}
