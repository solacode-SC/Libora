// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdfs_dao.dart';

// ignore_for_file: type=lint
mixin _$PdfsDaoMixin on DatabaseAccessor<AppDatabase> {
  $PdfsTable get pdfs => attachedDatabase.pdfs;
  PdfsDaoManager get managers => PdfsDaoManager(this);
}

class PdfsDaoManager {
  final _$PdfsDaoMixin _db;
  PdfsDaoManager(this._db);
  $$PdfsTableTableManager get pdfs =>
      $$PdfsTableTableManager(_db.attachedDatabase, _db.pdfs);
}
