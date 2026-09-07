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

  Future<PdfEntry?> getPdfByHash(String hash) =>
      (select(pdfs)..where((t) => t.fileHash.equals(hash))).getSingleOrNull();

  Future<PdfEntry?> findDuplicate({
    String? hash,
    int? fileSize,
    String? fileName,
  }) {
    return (select(pdfs)
          ..where((t) {
            final conditions = <Expression<bool>>[];
            if (hash != null && hash.isNotEmpty) {
              conditions.add(t.fileHash.equals(hash));
            }
            if (fileSize != null && fileName != null) {
              conditions.add(
                t.fileSize.equals(fileSize) & t.fileName.equals(fileName),
              );
            }
            if (conditions.isEmpty) return const Constant(false);
            return conditions.reduce((a, b) => a | b);
          })
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> updateTitle(String id, String title) =>
      (update(pdfs)..where((t) => t.id.equals(id))).write(
        PdfsCompanion(title: Value(title), updatedAt: Value(DateTime.now())),
      );

  Future<int> moveToFolder(String id, String? folderId) =>
      (update(pdfs)..where((t) => t.id.equals(id))).write(
        PdfsCompanion(
          folderId: Value(folderId),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<int> detachFromFolder(String folderId) =>
      (update(pdfs)..where((t) => t.folderId.equals(folderId))).write(
        const PdfsCompanion(folderId: Value(null)),
      );
}
