// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PdfsTable extends Pdfs with TableInfo<$PdfsTable, PdfEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PdfsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remotePathMeta = const VerificationMeta(
    'remotePath',
  );
  @override
  late final GeneratedColumn<String> remotePath = GeneratedColumn<String>(
    'remote_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverPathMeta = const VerificationMeta(
    'coverPath',
  );
  @override
  late final GeneratedColumn<String> coverPath = GeneratedColumn<String>(
    'cover_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pageCountMeta = const VerificationMeta(
    'pageCount',
  );
  @override
  late final GeneratedColumn<int> pageCount = GeneratedColumn<int>(
    'page_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _folderIdMeta = const VerificationMeta(
    'folderId',
  );
  @override
  late final GeneratedColumn<String> folderId = GeneratedColumn<String>(
    'folder_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('local'),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _currentPageMeta = const VerificationMeta(
    'currentPage',
  );
  @override
  late final GeneratedColumn<int> currentPage = GeneratedColumn<int>(
    'current_page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastReadAtMeta = const VerificationMeta(
    'lastReadAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastReadAt = GeneratedColumn<DateTime>(
    'last_read_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileHashMeta = const VerificationMeta(
    'fileHash',
  );
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
    'file_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    fileName,
    localPath,
    remotePath,
    coverPath,
    pageCount,
    fileSize,
    folderId,
    source,
    isFavorite,
    currentPage,
    createdAt,
    updatedAt,
    lastReadAt,
    fileHash,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pdfs';
  @override
  VerificationContext validateIntegrity(
    Insertable<PdfEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    }
    if (data.containsKey('remote_path')) {
      context.handle(
        _remotePathMeta,
        remotePath.isAcceptableOrUnknown(data['remote_path']!, _remotePathMeta),
      );
    }
    if (data.containsKey('cover_path')) {
      context.handle(
        _coverPathMeta,
        coverPath.isAcceptableOrUnknown(data['cover_path']!, _coverPathMeta),
      );
    }
    if (data.containsKey('page_count')) {
      context.handle(
        _pageCountMeta,
        pageCount.isAcceptableOrUnknown(data['page_count']!, _pageCountMeta),
      );
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    }
    if (data.containsKey('folder_id')) {
      context.handle(
        _folderIdMeta,
        folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('current_page')) {
      context.handle(
        _currentPageMeta,
        currentPage.isAcceptableOrUnknown(
          data['current_page']!,
          _currentPageMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_read_at')) {
      context.handle(
        _lastReadAtMeta,
        lastReadAt.isAcceptableOrUnknown(
          data['last_read_at']!,
          _lastReadAtMeta,
        ),
      );
    }
    if (data.containsKey('file_hash')) {
      context.handle(
        _fileHashMeta,
        fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PdfEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PdfEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      ),
      remotePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_path'],
      ),
      coverPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_path'],
      ),
      pageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_count'],
      ),
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      ),
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_id'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      currentPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_page'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastReadAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_read_at'],
      ),
      fileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_hash'],
      ),
    );
  }

  @override
  $PdfsTable createAlias(String alias) {
    return $PdfsTable(attachedDatabase, alias);
  }
}

class PdfEntry extends DataClass implements Insertable<PdfEntry> {
  final String id;
  final String title;
  final String fileName;
  final String? localPath;
  final String? remotePath;
  final String? coverPath;
  final int? pageCount;
  final int? fileSize;
  final String? folderId;
  final String source;
  final bool isFavorite;
  final int currentPage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastReadAt;
  final String? fileHash;
  const PdfEntry({
    required this.id,
    required this.title,
    required this.fileName,
    this.localPath,
    this.remotePath,
    this.coverPath,
    this.pageCount,
    this.fileSize,
    this.folderId,
    required this.source,
    required this.isFavorite,
    required this.currentPage,
    required this.createdAt,
    required this.updatedAt,
    this.lastReadAt,
    this.fileHash,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['file_name'] = Variable<String>(fileName);
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    if (!nullToAbsent || remotePath != null) {
      map['remote_path'] = Variable<String>(remotePath);
    }
    if (!nullToAbsent || coverPath != null) {
      map['cover_path'] = Variable<String>(coverPath);
    }
    if (!nullToAbsent || pageCount != null) {
      map['page_count'] = Variable<int>(pageCount);
    }
    if (!nullToAbsent || fileSize != null) {
      map['file_size'] = Variable<int>(fileSize);
    }
    if (!nullToAbsent || folderId != null) {
      map['folder_id'] = Variable<String>(folderId);
    }
    map['source'] = Variable<String>(source);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['current_page'] = Variable<int>(currentPage);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastReadAt != null) {
      map['last_read_at'] = Variable<DateTime>(lastReadAt);
    }
    if (!nullToAbsent || fileHash != null) {
      map['file_hash'] = Variable<String>(fileHash);
    }
    return map;
  }

  PdfsCompanion toCompanion(bool nullToAbsent) {
    return PdfsCompanion(
      id: Value(id),
      title: Value(title),
      fileName: Value(fileName),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      remotePath: remotePath == null && nullToAbsent
          ? const Value.absent()
          : Value(remotePath),
      coverPath: coverPath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverPath),
      pageCount: pageCount == null && nullToAbsent
          ? const Value.absent()
          : Value(pageCount),
      fileSize: fileSize == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSize),
      folderId: folderId == null && nullToAbsent
          ? const Value.absent()
          : Value(folderId),
      source: Value(source),
      isFavorite: Value(isFavorite),
      currentPage: Value(currentPage),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastReadAt: lastReadAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReadAt),
      fileHash: fileHash == null && nullToAbsent
          ? const Value.absent()
          : Value(fileHash),
    );
  }

  factory PdfEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PdfEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      fileName: serializer.fromJson<String>(json['fileName']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      remotePath: serializer.fromJson<String?>(json['remotePath']),
      coverPath: serializer.fromJson<String?>(json['coverPath']),
      pageCount: serializer.fromJson<int?>(json['pageCount']),
      fileSize: serializer.fromJson<int?>(json['fileSize']),
      folderId: serializer.fromJson<String?>(json['folderId']),
      source: serializer.fromJson<String>(json['source']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      currentPage: serializer.fromJson<int>(json['currentPage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastReadAt: serializer.fromJson<DateTime?>(json['lastReadAt']),
      fileHash: serializer.fromJson<String?>(json['fileHash']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'fileName': serializer.toJson<String>(fileName),
      'localPath': serializer.toJson<String?>(localPath),
      'remotePath': serializer.toJson<String?>(remotePath),
      'coverPath': serializer.toJson<String?>(coverPath),
      'pageCount': serializer.toJson<int?>(pageCount),
      'fileSize': serializer.toJson<int?>(fileSize),
      'folderId': serializer.toJson<String?>(folderId),
      'source': serializer.toJson<String>(source),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'currentPage': serializer.toJson<int>(currentPage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastReadAt': serializer.toJson<DateTime?>(lastReadAt),
      'fileHash': serializer.toJson<String?>(fileHash),
    };
  }

  PdfEntry copyWith({
    String? id,
    String? title,
    String? fileName,
    Value<String?> localPath = const Value.absent(),
    Value<String?> remotePath = const Value.absent(),
    Value<String?> coverPath = const Value.absent(),
    Value<int?> pageCount = const Value.absent(),
    Value<int?> fileSize = const Value.absent(),
    Value<String?> folderId = const Value.absent(),
    String? source,
    bool? isFavorite,
    int? currentPage,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> lastReadAt = const Value.absent(),
    Value<String?> fileHash = const Value.absent(),
  }) => PdfEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    fileName: fileName ?? this.fileName,
    localPath: localPath.present ? localPath.value : this.localPath,
    remotePath: remotePath.present ? remotePath.value : this.remotePath,
    coverPath: coverPath.present ? coverPath.value : this.coverPath,
    pageCount: pageCount.present ? pageCount.value : this.pageCount,
    fileSize: fileSize.present ? fileSize.value : this.fileSize,
    folderId: folderId.present ? folderId.value : this.folderId,
    source: source ?? this.source,
    isFavorite: isFavorite ?? this.isFavorite,
    currentPage: currentPage ?? this.currentPage,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastReadAt: lastReadAt.present ? lastReadAt.value : this.lastReadAt,
    fileHash: fileHash.present ? fileHash.value : this.fileHash,
  );
  PdfEntry copyWithCompanion(PdfsCompanion data) {
    return PdfEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      remotePath: data.remotePath.present
          ? data.remotePath.value
          : this.remotePath,
      coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
      pageCount: data.pageCount.present ? data.pageCount.value : this.pageCount,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      source: data.source.present ? data.source.value : this.source,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      currentPage: data.currentPage.present
          ? data.currentPage.value
          : this.currentPage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastReadAt: data.lastReadAt.present
          ? data.lastReadAt.value
          : this.lastReadAt,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PdfEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('fileName: $fileName, ')
          ..write('localPath: $localPath, ')
          ..write('remotePath: $remotePath, ')
          ..write('coverPath: $coverPath, ')
          ..write('pageCount: $pageCount, ')
          ..write('fileSize: $fileSize, ')
          ..write('folderId: $folderId, ')
          ..write('source: $source, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('currentPage: $currentPage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('fileHash: $fileHash')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    fileName,
    localPath,
    remotePath,
    coverPath,
    pageCount,
    fileSize,
    folderId,
    source,
    isFavorite,
    currentPage,
    createdAt,
    updatedAt,
    lastReadAt,
    fileHash,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PdfEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.fileName == this.fileName &&
          other.localPath == this.localPath &&
          other.remotePath == this.remotePath &&
          other.coverPath == this.coverPath &&
          other.pageCount == this.pageCount &&
          other.fileSize == this.fileSize &&
          other.folderId == this.folderId &&
          other.source == this.source &&
          other.isFavorite == this.isFavorite &&
          other.currentPage == this.currentPage &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastReadAt == this.lastReadAt &&
          other.fileHash == this.fileHash);
}

class PdfsCompanion extends UpdateCompanion<PdfEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> fileName;
  final Value<String?> localPath;
  final Value<String?> remotePath;
  final Value<String?> coverPath;
  final Value<int?> pageCount;
  final Value<int?> fileSize;
  final Value<String?> folderId;
  final Value<String> source;
  final Value<bool> isFavorite;
  final Value<int> currentPage;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastReadAt;
  final Value<String?> fileHash;
  final Value<int> rowid;
  const PdfsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.fileName = const Value.absent(),
    this.localPath = const Value.absent(),
    this.remotePath = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.folderId = const Value.absent(),
    this.source = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PdfsCompanion.insert({
    required String id,
    required String title,
    required String fileName,
    this.localPath = const Value.absent(),
    this.remotePath = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.folderId = const Value.absent(),
    this.source = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.currentPage = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.lastReadAt = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       fileName = Value(fileName),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PdfEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? fileName,
    Expression<String>? localPath,
    Expression<String>? remotePath,
    Expression<String>? coverPath,
    Expression<int>? pageCount,
    Expression<int>? fileSize,
    Expression<String>? folderId,
    Expression<String>? source,
    Expression<bool>? isFavorite,
    Expression<int>? currentPage,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastReadAt,
    Expression<String>? fileHash,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (fileName != null) 'file_name': fileName,
      if (localPath != null) 'local_path': localPath,
      if (remotePath != null) 'remote_path': remotePath,
      if (coverPath != null) 'cover_path': coverPath,
      if (pageCount != null) 'page_count': pageCount,
      if (fileSize != null) 'file_size': fileSize,
      if (folderId != null) 'folder_id': folderId,
      if (source != null) 'source': source,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (currentPage != null) 'current_page': currentPage,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastReadAt != null) 'last_read_at': lastReadAt,
      if (fileHash != null) 'file_hash': fileHash,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PdfsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? fileName,
    Value<String?>? localPath,
    Value<String?>? remotePath,
    Value<String?>? coverPath,
    Value<int?>? pageCount,
    Value<int?>? fileSize,
    Value<String?>? folderId,
    Value<String>? source,
    Value<bool>? isFavorite,
    Value<int>? currentPage,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? lastReadAt,
    Value<String?>? fileHash,
    Value<int>? rowid,
  }) {
    return PdfsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      fileName: fileName ?? this.fileName,
      localPath: localPath ?? this.localPath,
      remotePath: remotePath ?? this.remotePath,
      coverPath: coverPath ?? this.coverPath,
      pageCount: pageCount ?? this.pageCount,
      fileSize: fileSize ?? this.fileSize,
      folderId: folderId ?? this.folderId,
      source: source ?? this.source,
      isFavorite: isFavorite ?? this.isFavorite,
      currentPage: currentPage ?? this.currentPage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      fileHash: fileHash ?? this.fileHash,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (remotePath.present) {
      map['remote_path'] = Variable<String>(remotePath.value);
    }
    if (coverPath.present) {
      map['cover_path'] = Variable<String>(coverPath.value);
    }
    if (pageCount.present) {
      map['page_count'] = Variable<int>(pageCount.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<String>(folderId.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (currentPage.present) {
      map['current_page'] = Variable<int>(currentPage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastReadAt.present) {
      map['last_read_at'] = Variable<DateTime>(lastReadAt.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PdfsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('fileName: $fileName, ')
          ..write('localPath: $localPath, ')
          ..write('remotePath: $remotePath, ')
          ..write('coverPath: $coverPath, ')
          ..write('pageCount: $pageCount, ')
          ..write('fileSize: $fileSize, ')
          ..write('folderId: $folderId, ')
          ..write('source: $source, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('currentPage: $currentPage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('fileHash: $fileHash, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoldersTable extends Folders with TableInfo<$FoldersTable, FolderEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoldersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    parentId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'folders';
  @override
  VerificationContext validateIntegrity(
    Insertable<FolderEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FolderEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FolderEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FoldersTable createAlias(String alias) {
    return $FoldersTable(attachedDatabase, alias);
  }
}

class FolderEntry extends DataClass implements Insertable<FolderEntry> {
  final String id;
  final String name;
  final String? parentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FolderEntry({
    required this.id,
    required this.name,
    this.parentId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FoldersCompanion toCompanion(bool nullToAbsent) {
    return FoldersCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FolderEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FolderEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<String?>(parentId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FolderEntry copyWith({
    String? id,
    String? name,
    Value<String?> parentId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FolderEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    parentId: parentId.present ? parentId.value : this.parentId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FolderEntry copyWithCompanion(FoldersCompanion data) {
    return FolderEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FolderEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, parentId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FolderEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FoldersCompanion extends UpdateCompanion<FolderEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> parentId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FoldersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoldersCompanion.insert({
    required String id,
    required String name,
    this.parentId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FolderEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parentId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoldersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? parentId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return FoldersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoldersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, BookmarkEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pdfIdMeta = const VerificationMeta('pdfId');
  @override
  late final GeneratedColumn<String> pdfId = GeneratedColumn<String>(
    'pdf_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pdfs (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _pageNumberMeta = const VerificationMeta(
    'pageNumber',
  );
  @override
  late final GeneratedColumn<int> pageNumber = GeneratedColumn<int>(
    'page_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pdfId,
    pageNumber,
    label,
    note,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookmarkEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pdf_id')) {
      context.handle(
        _pdfIdMeta,
        pdfId.isAcceptableOrUnknown(data['pdf_id']!, _pdfIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pdfIdMeta);
    }
    if (data.containsKey('page_number')) {
      context.handle(
        _pageNumberMeta,
        pageNumber.isAcceptableOrUnknown(data['page_number']!, _pageNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_pageNumberMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {pdfId, pageNumber},
  ];
  @override
  BookmarkEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookmarkEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      pdfId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pdf_id'],
      )!,
      pageNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_number'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class BookmarkEntry extends DataClass implements Insertable<BookmarkEntry> {
  final String id;
  final String pdfId;
  final int pageNumber;
  final String? label;
  final String? note;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const BookmarkEntry({
    required this.id,
    required this.pdfId,
    required this.pageNumber,
    this.label,
    this.note,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pdf_id'] = Variable<String>(pdfId);
    map['page_number'] = Variable<int>(pageNumber);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      id: Value(id),
      pdfId: Value(pdfId),
      pageNumber: Value(pageNumber),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory BookmarkEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookmarkEntry(
      id: serializer.fromJson<String>(json['id']),
      pdfId: serializer.fromJson<String>(json['pdfId']),
      pageNumber: serializer.fromJson<int>(json['pageNumber']),
      label: serializer.fromJson<String?>(json['label']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'pdfId': serializer.toJson<String>(pdfId),
      'pageNumber': serializer.toJson<int>(pageNumber),
      'label': serializer.toJson<String?>(label),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  BookmarkEntry copyWith({
    String? id,
    String? pdfId,
    int? pageNumber,
    Value<String?> label = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => BookmarkEntry(
    id: id ?? this.id,
    pdfId: pdfId ?? this.pdfId,
    pageNumber: pageNumber ?? this.pageNumber,
    label: label.present ? label.value : this.label,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  BookmarkEntry copyWithCompanion(BookmarksCompanion data) {
    return BookmarkEntry(
      id: data.id.present ? data.id.value : this.id,
      pdfId: data.pdfId.present ? data.pdfId.value : this.pdfId,
      pageNumber: data.pageNumber.present
          ? data.pageNumber.value
          : this.pageNumber,
      label: data.label.present ? data.label.value : this.label,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkEntry(')
          ..write('id: $id, ')
          ..write('pdfId: $pdfId, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('label: $label, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, pdfId, pageNumber, label, note, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookmarkEntry &&
          other.id == this.id &&
          other.pdfId == this.pdfId &&
          other.pageNumber == this.pageNumber &&
          other.label == this.label &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BookmarksCompanion extends UpdateCompanion<BookmarkEntry> {
  final Value<String> id;
  final Value<String> pdfId;
  final Value<int> pageNumber;
  final Value<String?> label;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const BookmarksCompanion({
    this.id = const Value.absent(),
    this.pdfId = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.label = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookmarksCompanion.insert({
    required String id,
    required String pdfId,
    required int pageNumber,
    this.label = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       pdfId = Value(pdfId),
       pageNumber = Value(pageNumber),
       createdAt = Value(createdAt);
  static Insertable<BookmarkEntry> custom({
    Expression<String>? id,
    Expression<String>? pdfId,
    Expression<int>? pageNumber,
    Expression<String>? label,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pdfId != null) 'pdf_id': pdfId,
      if (pageNumber != null) 'page_number': pageNumber,
      if (label != null) 'label': label,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookmarksCompanion copyWith({
    Value<String>? id,
    Value<String>? pdfId,
    Value<int>? pageNumber,
    Value<String?>? label,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return BookmarksCompanion(
      id: id ?? this.id,
      pdfId: pdfId ?? this.pdfId,
      pageNumber: pageNumber ?? this.pageNumber,
      label: label ?? this.label,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (pdfId.present) {
      map['pdf_id'] = Variable<String>(pdfId.value);
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksCompanion(')
          ..write('id: $id, ')
          ..write('pdfId: $pdfId, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('label: $label, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GitHubAccountsTable extends GitHubAccounts
    with TableInfo<$GitHubAccountsTable, GitHubAccountEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GitHubAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _githubUserIdMeta = const VerificationMeta(
    'githubUserId',
  );
  @override
  late final GeneratedColumn<String> githubUserId = GeneratedColumn<String>(
    'github_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loginMeta = const VerificationMeta('login');
  @override
  late final GeneratedColumn<String> login = GeneratedColumn<String>(
    'login',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    githubUserId,
    login,
    avatarUrl,
    name,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'git_hub_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<GitHubAccountEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('github_user_id')) {
      context.handle(
        _githubUserIdMeta,
        githubUserId.isAcceptableOrUnknown(
          data['github_user_id']!,
          _githubUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_githubUserIdMeta);
    }
    if (data.containsKey('login')) {
      context.handle(
        _loginMeta,
        login.isAcceptableOrUnknown(data['login']!, _loginMeta),
      );
    } else if (isInserting) {
      context.missing(_loginMeta);
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GitHubAccountEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GitHubAccountEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      githubUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}github_user_id'],
      )!,
      login: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}login'],
      )!,
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GitHubAccountsTable createAlias(String alias) {
    return $GitHubAccountsTable(attachedDatabase, alias);
  }
}

class GitHubAccountEntry extends DataClass
    implements Insertable<GitHubAccountEntry> {
  final String id;
  final String githubUserId;
  final String login;
  final String? avatarUrl;
  final String? name;
  final DateTime createdAt;
  final DateTime updatedAt;
  const GitHubAccountEntry({
    required this.id,
    required this.githubUserId,
    required this.login,
    this.avatarUrl,
    this.name,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['github_user_id'] = Variable<String>(githubUserId);
    map['login'] = Variable<String>(login);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GitHubAccountsCompanion toCompanion(bool nullToAbsent) {
    return GitHubAccountsCompanion(
      id: Value(id),
      githubUserId: Value(githubUserId),
      login: Value(login),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GitHubAccountEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GitHubAccountEntry(
      id: serializer.fromJson<String>(json['id']),
      githubUserId: serializer.fromJson<String>(json['githubUserId']),
      login: serializer.fromJson<String>(json['login']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      name: serializer.fromJson<String?>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'githubUserId': serializer.toJson<String>(githubUserId),
      'login': serializer.toJson<String>(login),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'name': serializer.toJson<String?>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GitHubAccountEntry copyWith({
    String? id,
    String? githubUserId,
    String? login,
    Value<String?> avatarUrl = const Value.absent(),
    Value<String?> name = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GitHubAccountEntry(
    id: id ?? this.id,
    githubUserId: githubUserId ?? this.githubUserId,
    login: login ?? this.login,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    name: name.present ? name.value : this.name,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GitHubAccountEntry copyWithCompanion(GitHubAccountsCompanion data) {
    return GitHubAccountEntry(
      id: data.id.present ? data.id.value : this.id,
      githubUserId: data.githubUserId.present
          ? data.githubUserId.value
          : this.githubUserId,
      login: data.login.present ? data.login.value : this.login,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GitHubAccountEntry(')
          ..write('id: $id, ')
          ..write('githubUserId: $githubUserId, ')
          ..write('login: $login, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    githubUserId,
    login,
    avatarUrl,
    name,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GitHubAccountEntry &&
          other.id == this.id &&
          other.githubUserId == this.githubUserId &&
          other.login == this.login &&
          other.avatarUrl == this.avatarUrl &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GitHubAccountsCompanion extends UpdateCompanion<GitHubAccountEntry> {
  final Value<String> id;
  final Value<String> githubUserId;
  final Value<String> login;
  final Value<String?> avatarUrl;
  final Value<String?> name;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GitHubAccountsCompanion({
    this.id = const Value.absent(),
    this.githubUserId = const Value.absent(),
    this.login = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GitHubAccountsCompanion.insert({
    required String id,
    required String githubUserId,
    required String login,
    this.avatarUrl = const Value.absent(),
    this.name = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       githubUserId = Value(githubUserId),
       login = Value(login),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<GitHubAccountEntry> custom({
    Expression<String>? id,
    Expression<String>? githubUserId,
    Expression<String>? login,
    Expression<String>? avatarUrl,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (githubUserId != null) 'github_user_id': githubUserId,
      if (login != null) 'login': login,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GitHubAccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? githubUserId,
    Value<String>? login,
    Value<String?>? avatarUrl,
    Value<String?>? name,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GitHubAccountsCompanion(
      id: id ?? this.id,
      githubUserId: githubUserId ?? this.githubUserId,
      login: login ?? this.login,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (githubUserId.present) {
      map['github_user_id'] = Variable<String>(githubUserId.value);
    }
    if (login.present) {
      map['login'] = Variable<String>(login.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GitHubAccountsCompanion(')
          ..write('id: $id, ')
          ..write('githubUserId: $githubUserId, ')
          ..write('login: $login, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GitHubRepositoriesTable extends GitHubRepositories
    with TableInfo<$GitHubRepositoriesTable, GitHubRepositoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GitHubRepositoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _githubRepoIdMeta = const VerificationMeta(
    'githubRepoId',
  );
  @override
  late final GeneratedColumn<String> githubRepoId = GeneratedColumn<String>(
    'github_repo_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ownerMeta = const VerificationMeta('owner');
  @override
  late final GeneratedColumn<String> owner = GeneratedColumn<String>(
    'owner',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultBranchMeta = const VerificationMeta(
    'defaultBranch',
  );
  @override
  late final GeneratedColumn<String> defaultBranch = GeneratedColumn<String>(
    'default_branch',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('main'),
  );
  static const VerificationMeta _isPrivateMeta = const VerificationMeta(
    'isPrivate',
  );
  @override
  late final GeneratedColumn<bool> isPrivate = GeneratedColumn<bool>(
    'is_private',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_private" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isSelectedMeta = const VerificationMeta(
    'isSelected',
  );
  @override
  late final GeneratedColumn<bool> isSelected = GeneratedColumn<bool>(
    'is_selected',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_selected" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remoteHeadShaMeta = const VerificationMeta(
    'remoteHeadSha',
  );
  @override
  late final GeneratedColumn<String> remoteHeadSha = GeneratedColumn<String>(
    'remote_head_sha',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    githubRepoId,
    owner,
    name,
    fullName,
    defaultBranch,
    isPrivate,
    isSelected,
    lastSyncedAt,
    remoteHeadSha,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'git_hub_repositories';
  @override
  VerificationContext validateIntegrity(
    Insertable<GitHubRepositoryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('github_repo_id')) {
      context.handle(
        _githubRepoIdMeta,
        githubRepoId.isAcceptableOrUnknown(
          data['github_repo_id']!,
          _githubRepoIdMeta,
        ),
      );
    }
    if (data.containsKey('owner')) {
      context.handle(
        _ownerMeta,
        owner.isAcceptableOrUnknown(data['owner']!, _ownerMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('default_branch')) {
      context.handle(
        _defaultBranchMeta,
        defaultBranch.isAcceptableOrUnknown(
          data['default_branch']!,
          _defaultBranchMeta,
        ),
      );
    }
    if (data.containsKey('is_private')) {
      context.handle(
        _isPrivateMeta,
        isPrivate.isAcceptableOrUnknown(data['is_private']!, _isPrivateMeta),
      );
    }
    if (data.containsKey('is_selected')) {
      context.handle(
        _isSelectedMeta,
        isSelected.isAcceptableOrUnknown(data['is_selected']!, _isSelectedMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('remote_head_sha')) {
      context.handle(
        _remoteHeadShaMeta,
        remoteHeadSha.isAcceptableOrUnknown(
          data['remote_head_sha']!,
          _remoteHeadShaMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GitHubRepositoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GitHubRepositoryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      githubRepoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}github_repo_id'],
      ),
      owner: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      defaultBranch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_branch'],
      )!,
      isPrivate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_private'],
      )!,
      isSelected: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_selected'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      remoteHeadSha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_head_sha'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GitHubRepositoriesTable createAlias(String alias) {
    return $GitHubRepositoriesTable(attachedDatabase, alias);
  }
}

class GitHubRepositoryEntry extends DataClass
    implements Insertable<GitHubRepositoryEntry> {
  final String id;
  final String? githubRepoId;
  final String owner;
  final String name;
  final String fullName;
  final String defaultBranch;
  final bool isPrivate;
  final bool isSelected;
  final DateTime? lastSyncedAt;
  final String? remoteHeadSha;
  final DateTime createdAt;
  final DateTime updatedAt;
  const GitHubRepositoryEntry({
    required this.id,
    this.githubRepoId,
    required this.owner,
    required this.name,
    required this.fullName,
    required this.defaultBranch,
    required this.isPrivate,
    required this.isSelected,
    this.lastSyncedAt,
    this.remoteHeadSha,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || githubRepoId != null) {
      map['github_repo_id'] = Variable<String>(githubRepoId);
    }
    map['owner'] = Variable<String>(owner);
    map['name'] = Variable<String>(name);
    map['full_name'] = Variable<String>(fullName);
    map['default_branch'] = Variable<String>(defaultBranch);
    map['is_private'] = Variable<bool>(isPrivate);
    map['is_selected'] = Variable<bool>(isSelected);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || remoteHeadSha != null) {
      map['remote_head_sha'] = Variable<String>(remoteHeadSha);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GitHubRepositoriesCompanion toCompanion(bool nullToAbsent) {
    return GitHubRepositoriesCompanion(
      id: Value(id),
      githubRepoId: githubRepoId == null && nullToAbsent
          ? const Value.absent()
          : Value(githubRepoId),
      owner: Value(owner),
      name: Value(name),
      fullName: Value(fullName),
      defaultBranch: Value(defaultBranch),
      isPrivate: Value(isPrivate),
      isSelected: Value(isSelected),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      remoteHeadSha: remoteHeadSha == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteHeadSha),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GitHubRepositoryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GitHubRepositoryEntry(
      id: serializer.fromJson<String>(json['id']),
      githubRepoId: serializer.fromJson<String?>(json['githubRepoId']),
      owner: serializer.fromJson<String>(json['owner']),
      name: serializer.fromJson<String>(json['name']),
      fullName: serializer.fromJson<String>(json['fullName']),
      defaultBranch: serializer.fromJson<String>(json['defaultBranch']),
      isPrivate: serializer.fromJson<bool>(json['isPrivate']),
      isSelected: serializer.fromJson<bool>(json['isSelected']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      remoteHeadSha: serializer.fromJson<String?>(json['remoteHeadSha']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'githubRepoId': serializer.toJson<String?>(githubRepoId),
      'owner': serializer.toJson<String>(owner),
      'name': serializer.toJson<String>(name),
      'fullName': serializer.toJson<String>(fullName),
      'defaultBranch': serializer.toJson<String>(defaultBranch),
      'isPrivate': serializer.toJson<bool>(isPrivate),
      'isSelected': serializer.toJson<bool>(isSelected),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'remoteHeadSha': serializer.toJson<String?>(remoteHeadSha),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GitHubRepositoryEntry copyWith({
    String? id,
    Value<String?> githubRepoId = const Value.absent(),
    String? owner,
    String? name,
    String? fullName,
    String? defaultBranch,
    bool? isPrivate,
    bool? isSelected,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    Value<String?> remoteHeadSha = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GitHubRepositoryEntry(
    id: id ?? this.id,
    githubRepoId: githubRepoId.present ? githubRepoId.value : this.githubRepoId,
    owner: owner ?? this.owner,
    name: name ?? this.name,
    fullName: fullName ?? this.fullName,
    defaultBranch: defaultBranch ?? this.defaultBranch,
    isPrivate: isPrivate ?? this.isPrivate,
    isSelected: isSelected ?? this.isSelected,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    remoteHeadSha: remoteHeadSha.present
        ? remoteHeadSha.value
        : this.remoteHeadSha,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GitHubRepositoryEntry copyWithCompanion(GitHubRepositoriesCompanion data) {
    return GitHubRepositoryEntry(
      id: data.id.present ? data.id.value : this.id,
      githubRepoId: data.githubRepoId.present
          ? data.githubRepoId.value
          : this.githubRepoId,
      owner: data.owner.present ? data.owner.value : this.owner,
      name: data.name.present ? data.name.value : this.name,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      defaultBranch: data.defaultBranch.present
          ? data.defaultBranch.value
          : this.defaultBranch,
      isPrivate: data.isPrivate.present ? data.isPrivate.value : this.isPrivate,
      isSelected: data.isSelected.present
          ? data.isSelected.value
          : this.isSelected,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      remoteHeadSha: data.remoteHeadSha.present
          ? data.remoteHeadSha.value
          : this.remoteHeadSha,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GitHubRepositoryEntry(')
          ..write('id: $id, ')
          ..write('githubRepoId: $githubRepoId, ')
          ..write('owner: $owner, ')
          ..write('name: $name, ')
          ..write('fullName: $fullName, ')
          ..write('defaultBranch: $defaultBranch, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('isSelected: $isSelected, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('remoteHeadSha: $remoteHeadSha, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    githubRepoId,
    owner,
    name,
    fullName,
    defaultBranch,
    isPrivate,
    isSelected,
    lastSyncedAt,
    remoteHeadSha,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GitHubRepositoryEntry &&
          other.id == this.id &&
          other.githubRepoId == this.githubRepoId &&
          other.owner == this.owner &&
          other.name == this.name &&
          other.fullName == this.fullName &&
          other.defaultBranch == this.defaultBranch &&
          other.isPrivate == this.isPrivate &&
          other.isSelected == this.isSelected &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.remoteHeadSha == this.remoteHeadSha &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GitHubRepositoriesCompanion
    extends UpdateCompanion<GitHubRepositoryEntry> {
  final Value<String> id;
  final Value<String?> githubRepoId;
  final Value<String> owner;
  final Value<String> name;
  final Value<String> fullName;
  final Value<String> defaultBranch;
  final Value<bool> isPrivate;
  final Value<bool> isSelected;
  final Value<DateTime?> lastSyncedAt;
  final Value<String?> remoteHeadSha;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GitHubRepositoriesCompanion({
    this.id = const Value.absent(),
    this.githubRepoId = const Value.absent(),
    this.owner = const Value.absent(),
    this.name = const Value.absent(),
    this.fullName = const Value.absent(),
    this.defaultBranch = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.isSelected = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.remoteHeadSha = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GitHubRepositoriesCompanion.insert({
    required String id,
    this.githubRepoId = const Value.absent(),
    required String owner,
    required String name,
    required String fullName,
    this.defaultBranch = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.isSelected = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.remoteHeadSha = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       owner = Value(owner),
       name = Value(name),
       fullName = Value(fullName),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<GitHubRepositoryEntry> custom({
    Expression<String>? id,
    Expression<String>? githubRepoId,
    Expression<String>? owner,
    Expression<String>? name,
    Expression<String>? fullName,
    Expression<String>? defaultBranch,
    Expression<bool>? isPrivate,
    Expression<bool>? isSelected,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? remoteHeadSha,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (githubRepoId != null) 'github_repo_id': githubRepoId,
      if (owner != null) 'owner': owner,
      if (name != null) 'name': name,
      if (fullName != null) 'full_name': fullName,
      if (defaultBranch != null) 'default_branch': defaultBranch,
      if (isPrivate != null) 'is_private': isPrivate,
      if (isSelected != null) 'is_selected': isSelected,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (remoteHeadSha != null) 'remote_head_sha': remoteHeadSha,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GitHubRepositoriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? githubRepoId,
    Value<String>? owner,
    Value<String>? name,
    Value<String>? fullName,
    Value<String>? defaultBranch,
    Value<bool>? isPrivate,
    Value<bool>? isSelected,
    Value<DateTime?>? lastSyncedAt,
    Value<String?>? remoteHeadSha,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GitHubRepositoriesCompanion(
      id: id ?? this.id,
      githubRepoId: githubRepoId ?? this.githubRepoId,
      owner: owner ?? this.owner,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      defaultBranch: defaultBranch ?? this.defaultBranch,
      isPrivate: isPrivate ?? this.isPrivate,
      isSelected: isSelected ?? this.isSelected,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      remoteHeadSha: remoteHeadSha ?? this.remoteHeadSha,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (githubRepoId.present) {
      map['github_repo_id'] = Variable<String>(githubRepoId.value);
    }
    if (owner.present) {
      map['owner'] = Variable<String>(owner.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (defaultBranch.present) {
      map['default_branch'] = Variable<String>(defaultBranch.value);
    }
    if (isPrivate.present) {
      map['is_private'] = Variable<bool>(isPrivate.value);
    }
    if (isSelected.present) {
      map['is_selected'] = Variable<bool>(isSelected.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (remoteHeadSha.present) {
      map['remote_head_sha'] = Variable<String>(remoteHeadSha.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GitHubRepositoriesCompanion(')
          ..write('id: $id, ')
          ..write('githubRepoId: $githubRepoId, ')
          ..write('owner: $owner, ')
          ..write('name: $name, ')
          ..write('fullName: $fullName, ')
          ..write('defaultBranch: $defaultBranch, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('isSelected: $isSelected, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('remoteHeadSha: $remoteHeadSha, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataTable extends SyncMetadata
    with TableInfo<$SyncMetadataTable, SyncMetadataEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pdfIdMeta = const VerificationMeta('pdfId');
  @override
  late final GeneratedColumn<String> pdfId = GeneratedColumn<String>(
    'pdf_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repositoryIdMeta = const VerificationMeta(
    'repositoryId',
  );
  @override
  late final GeneratedColumn<String> repositoryId = GeneratedColumn<String>(
    'repository_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remotePathMeta = const VerificationMeta(
    'remotePath',
  );
  @override
  late final GeneratedColumn<String> remotePath = GeneratedColumn<String>(
    'remote_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remoteShaMeta = const VerificationMeta(
    'remoteSha',
  );
  @override
  late final GeneratedColumn<String> remoteSha = GeneratedColumn<String>(
    'remote_sha',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remoteSizeMeta = const VerificationMeta(
    'remoteSize',
  );
  @override
  late final GeneratedColumn<int> remoteSize = GeneratedColumn<int>(
    'remote_size',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localHashMeta = const VerificationMeta(
    'localHash',
  );
  @override
  late final GeneratedColumn<String> localHash = GeneratedColumn<String>(
    'local_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('upload_pending'),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pdfId,
    repositoryId,
    remotePath,
    remoteSha,
    remoteSize,
    localHash,
    lastSyncedAt,
    syncStatus,
    lastError,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetadataEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pdf_id')) {
      context.handle(
        _pdfIdMeta,
        pdfId.isAcceptableOrUnknown(data['pdf_id']!, _pdfIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pdfIdMeta);
    }
    if (data.containsKey('repository_id')) {
      context.handle(
        _repositoryIdMeta,
        repositoryId.isAcceptableOrUnknown(
          data['repository_id']!,
          _repositoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repositoryIdMeta);
    }
    if (data.containsKey('remote_path')) {
      context.handle(
        _remotePathMeta,
        remotePath.isAcceptableOrUnknown(data['remote_path']!, _remotePathMeta),
      );
    } else if (isInserting) {
      context.missing(_remotePathMeta);
    }
    if (data.containsKey('remote_sha')) {
      context.handle(
        _remoteShaMeta,
        remoteSha.isAcceptableOrUnknown(data['remote_sha']!, _remoteShaMeta),
      );
    }
    if (data.containsKey('remote_size')) {
      context.handle(
        _remoteSizeMeta,
        remoteSize.isAcceptableOrUnknown(data['remote_size']!, _remoteSizeMeta),
      );
    }
    if (data.containsKey('local_hash')) {
      context.handle(
        _localHashMeta,
        localHash.isAcceptableOrUnknown(data['local_hash']!, _localHashMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncMetadataEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      pdfId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pdf_id'],
      )!,
      repositoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repository_id'],
      )!,
      remotePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_path'],
      )!,
      remoteSha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_sha'],
      ),
      remoteSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remote_size'],
      ),
      localHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_hash'],
      ),
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SyncMetadataTable createAlias(String alias) {
    return $SyncMetadataTable(attachedDatabase, alias);
  }
}

class SyncMetadataEntry extends DataClass
    implements Insertable<SyncMetadataEntry> {
  final String id;
  final String pdfId;
  final String repositoryId;
  final String remotePath;
  final String? remoteSha;
  final int? remoteSize;
  final String? localHash;
  final DateTime? lastSyncedAt;
  final String syncStatus;
  final String? lastError;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SyncMetadataEntry({
    required this.id,
    required this.pdfId,
    required this.repositoryId,
    required this.remotePath,
    this.remoteSha,
    this.remoteSize,
    this.localHash,
    this.lastSyncedAt,
    required this.syncStatus,
    this.lastError,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pdf_id'] = Variable<String>(pdfId);
    map['repository_id'] = Variable<String>(repositoryId);
    map['remote_path'] = Variable<String>(remotePath);
    if (!nullToAbsent || remoteSha != null) {
      map['remote_sha'] = Variable<String>(remoteSha);
    }
    if (!nullToAbsent || remoteSize != null) {
      map['remote_size'] = Variable<int>(remoteSize);
    }
    if (!nullToAbsent || localHash != null) {
      map['local_hash'] = Variable<String>(localHash);
    }
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncMetadataCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataCompanion(
      id: Value(id),
      pdfId: Value(pdfId),
      repositoryId: Value(repositoryId),
      remotePath: Value(remotePath),
      remoteSha: remoteSha == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteSha),
      remoteSize: remoteSize == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteSize),
      localHash: localHash == null && nullToAbsent
          ? const Value.absent()
          : Value(localHash),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      syncStatus: Value(syncStatus),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncMetadataEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataEntry(
      id: serializer.fromJson<String>(json['id']),
      pdfId: serializer.fromJson<String>(json['pdfId']),
      repositoryId: serializer.fromJson<String>(json['repositoryId']),
      remotePath: serializer.fromJson<String>(json['remotePath']),
      remoteSha: serializer.fromJson<String?>(json['remoteSha']),
      remoteSize: serializer.fromJson<int?>(json['remoteSize']),
      localHash: serializer.fromJson<String?>(json['localHash']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'pdfId': serializer.toJson<String>(pdfId),
      'repositoryId': serializer.toJson<String>(repositoryId),
      'remotePath': serializer.toJson<String>(remotePath),
      'remoteSha': serializer.toJson<String?>(remoteSha),
      'remoteSize': serializer.toJson<int?>(remoteSize),
      'localHash': serializer.toJson<String?>(localHash),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncMetadataEntry copyWith({
    String? id,
    String? pdfId,
    String? repositoryId,
    String? remotePath,
    Value<String?> remoteSha = const Value.absent(),
    Value<int?> remoteSize = const Value.absent(),
    Value<String?> localHash = const Value.absent(),
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    String? syncStatus,
    Value<String?> lastError = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SyncMetadataEntry(
    id: id ?? this.id,
    pdfId: pdfId ?? this.pdfId,
    repositoryId: repositoryId ?? this.repositoryId,
    remotePath: remotePath ?? this.remotePath,
    remoteSha: remoteSha.present ? remoteSha.value : this.remoteSha,
    remoteSize: remoteSize.present ? remoteSize.value : this.remoteSize,
    localHash: localHash.present ? localHash.value : this.localHash,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncMetadataEntry copyWithCompanion(SyncMetadataCompanion data) {
    return SyncMetadataEntry(
      id: data.id.present ? data.id.value : this.id,
      pdfId: data.pdfId.present ? data.pdfId.value : this.pdfId,
      repositoryId: data.repositoryId.present
          ? data.repositoryId.value
          : this.repositoryId,
      remotePath: data.remotePath.present
          ? data.remotePath.value
          : this.remotePath,
      remoteSha: data.remoteSha.present ? data.remoteSha.value : this.remoteSha,
      remoteSize: data.remoteSize.present
          ? data.remoteSize.value
          : this.remoteSize,
      localHash: data.localHash.present ? data.localHash.value : this.localHash,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataEntry(')
          ..write('id: $id, ')
          ..write('pdfId: $pdfId, ')
          ..write('repositoryId: $repositoryId, ')
          ..write('remotePath: $remotePath, ')
          ..write('remoteSha: $remoteSha, ')
          ..write('remoteSize: $remoteSize, ')
          ..write('localHash: $localHash, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pdfId,
    repositoryId,
    remotePath,
    remoteSha,
    remoteSize,
    localHash,
    lastSyncedAt,
    syncStatus,
    lastError,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataEntry &&
          other.id == this.id &&
          other.pdfId == this.pdfId &&
          other.repositoryId == this.repositoryId &&
          other.remotePath == this.remotePath &&
          other.remoteSha == this.remoteSha &&
          other.remoteSize == this.remoteSize &&
          other.localHash == this.localHash &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.syncStatus == this.syncStatus &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncMetadataCompanion extends UpdateCompanion<SyncMetadataEntry> {
  final Value<String> id;
  final Value<String> pdfId;
  final Value<String> repositoryId;
  final Value<String> remotePath;
  final Value<String?> remoteSha;
  final Value<int?> remoteSize;
  final Value<String?> localHash;
  final Value<DateTime?> lastSyncedAt;
  final Value<String> syncStatus;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncMetadataCompanion({
    this.id = const Value.absent(),
    this.pdfId = const Value.absent(),
    this.repositoryId = const Value.absent(),
    this.remotePath = const Value.absent(),
    this.remoteSha = const Value.absent(),
    this.remoteSize = const Value.absent(),
    this.localHash = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataCompanion.insert({
    required String id,
    required String pdfId,
    required String repositoryId,
    required String remotePath,
    this.remoteSha = const Value.absent(),
    this.remoteSize = const Value.absent(),
    this.localHash = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.lastError = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       pdfId = Value(pdfId),
       repositoryId = Value(repositoryId),
       remotePath = Value(remotePath),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SyncMetadataEntry> custom({
    Expression<String>? id,
    Expression<String>? pdfId,
    Expression<String>? repositoryId,
    Expression<String>? remotePath,
    Expression<String>? remoteSha,
    Expression<int>? remoteSize,
    Expression<String>? localHash,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? syncStatus,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pdfId != null) 'pdf_id': pdfId,
      if (repositoryId != null) 'repository_id': repositoryId,
      if (remotePath != null) 'remote_path': remotePath,
      if (remoteSha != null) 'remote_sha': remoteSha,
      if (remoteSize != null) 'remote_size': remoteSize,
      if (localHash != null) 'local_hash': localHash,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataCompanion copyWith({
    Value<String>? id,
    Value<String>? pdfId,
    Value<String>? repositoryId,
    Value<String>? remotePath,
    Value<String?>? remoteSha,
    Value<int?>? remoteSize,
    Value<String?>? localHash,
    Value<DateTime?>? lastSyncedAt,
    Value<String>? syncStatus,
    Value<String?>? lastError,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncMetadataCompanion(
      id: id ?? this.id,
      pdfId: pdfId ?? this.pdfId,
      repositoryId: repositoryId ?? this.repositoryId,
      remotePath: remotePath ?? this.remotePath,
      remoteSha: remoteSha ?? this.remoteSha,
      remoteSize: remoteSize ?? this.remoteSize,
      localHash: localHash ?? this.localHash,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (pdfId.present) {
      map['pdf_id'] = Variable<String>(pdfId.value);
    }
    if (repositoryId.present) {
      map['repository_id'] = Variable<String>(repositoryId.value);
    }
    if (remotePath.present) {
      map['remote_path'] = Variable<String>(remotePath.value);
    }
    if (remoteSha.present) {
      map['remote_sha'] = Variable<String>(remoteSha.value);
    }
    if (remoteSize.present) {
      map['remote_size'] = Variable<int>(remoteSize.value);
    }
    if (localHash.present) {
      map['local_hash'] = Variable<String>(localHash.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataCompanion(')
          ..write('id: $id, ')
          ..write('pdfId: $pdfId, ')
          ..write('repositoryId: $repositoryId, ')
          ..write('remotePath: $remotePath, ')
          ..write('remoteSha: $remoteSha, ')
          ..write('remoteSize: $remoteSize, ')
          ..write('localHash: $localHash, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PdfsTable pdfs = $PdfsTable(this);
  late final $FoldersTable folders = $FoldersTable(this);
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  late final $GitHubAccountsTable gitHubAccounts = $GitHubAccountsTable(this);
  late final $GitHubRepositoriesTable gitHubRepositories =
      $GitHubRepositoriesTable(this);
  late final $SyncMetadataTable syncMetadata = $SyncMetadataTable(this);
  late final PdfsDao pdfsDao = PdfsDao(this as AppDatabase);
  late final FoldersDao foldersDao = FoldersDao(this as AppDatabase);
  late final BookmarksDao bookmarksDao = BookmarksDao(this as AppDatabase);
  late final GitHubDao gitHubDao = GitHubDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    pdfs,
    folders,
    bookmarks,
    gitHubAccounts,
    gitHubRepositories,
    syncMetadata,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'pdfs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bookmarks', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$PdfsTableCreateCompanionBuilder = PdfsCompanion Function({
  required String id,
  required String title,
  required String fileName,
  Value<String?> localPath,
  Value<String?> remotePath,
  Value<String?> coverPath,
  Value<int?> pageCount,
  Value<int?> fileSize,
  Value<String?> folderId,
  Value<String> source,
  Value<bool> isFavorite,
  Value<int> currentPage,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> lastReadAt,
  Value<String?> fileHash,
  Value<int> rowid,
});
typedef $$PdfsTableUpdateCompanionBuilder = PdfsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> fileName,
  Value<String?> localPath,
  Value<String?> remotePath,
  Value<String?> coverPath,
  Value<int?> pageCount,
  Value<int?> fileSize,
  Value<String?> folderId,
  Value<String> source,
  Value<bool> isFavorite,
  Value<int> currentPage,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> lastReadAt,
  Value<String?> fileHash,
  Value<int> rowid,
});

final class $$PdfsTableReferences
    extends BaseReferences<_$AppDatabase, $PdfsTable, PdfEntry> {
  $$PdfsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BookmarksTable, List<BookmarkEntry>>
  _bookmarksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bookmarks,
    aliasName: 'pdfs__id__bookmarks__pdf_id',
  );

  $$BookmarksTableProcessedTableManager get bookmarksRefs {
    final manager = $$BookmarksTableTableManager(
      $_db,
      $_db.bookmarks,
    ).filter((f) => f.pdfId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bookmarksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PdfsTableFilterComposer extends Composer<_$AppDatabase, $PdfsTable> {
  $$PdfsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remotePath => $composableBuilder(
    column: $table.remotePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get folderId => $composableBuilder(
    column: $table.folderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> bookmarksRefs(
    Expression<bool> Function($$BookmarksTableFilterComposer f) f,
  ) {
    final $$BookmarksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarks,
      getReferencedColumn: (t) => t.pdfId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookmarksTableFilterComposer(
            $db: $db,
            $table: $db.bookmarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PdfsTableOrderingComposer extends Composer<_$AppDatabase, $PdfsTable> {
  $$PdfsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remotePath => $composableBuilder(
    column: $table.remotePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get folderId => $composableBuilder(
    column: $table.folderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PdfsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PdfsTable> {
  $$PdfsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get remotePath => $composableBuilder(
    column: $table.remotePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coverPath =>
      $composableBuilder(column: $table.coverPath, builder: (column) => column);

  GeneratedColumn<int> get pageCount =>
      $composableBuilder(column: $table.pageCount, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<String> get folderId =>
      $composableBuilder(column: $table.folderId, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentPage => $composableBuilder(
    column: $table.currentPage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => column);

  Expression<T> bookmarksRefs<T extends Object>(
    Expression<T> Function($$BookmarksTableAnnotationComposer a) f,
  ) {
    final $$BookmarksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarks,
      getReferencedColumn: (t) => t.pdfId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookmarksTableAnnotationComposer(
            $db: $db,
            $table: $db.bookmarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PdfsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PdfsTable,
          PdfEntry,
          $$PdfsTableFilterComposer,
          $$PdfsTableOrderingComposer,
          $$PdfsTableAnnotationComposer,
          $$PdfsTableCreateCompanionBuilder,
          $$PdfsTableUpdateCompanionBuilder,
          (PdfEntry, $$PdfsTableReferences),
          PdfEntry,
          PrefetchHooks Function({bool bookmarksRefs})
        > {
  $$PdfsTableTableManager(_$AppDatabase db, $PdfsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PdfsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PdfsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PdfsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<String?> remotePath = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<int?> pageCount = const Value.absent(),
                Value<int?> fileSize = const Value.absent(),
                Value<String?> folderId = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> currentPage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastReadAt = const Value.absent(),
                Value<String?> fileHash = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PdfsCompanion(
                id: id,
                title: title,
                fileName: fileName,
                localPath: localPath,
                remotePath: remotePath,
                coverPath: coverPath,
                pageCount: pageCount,
                fileSize: fileSize,
                folderId: folderId,
                source: source,
                isFavorite: isFavorite,
                currentPage: currentPage,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastReadAt: lastReadAt,
                fileHash: fileHash,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String fileName,
                Value<String?> localPath = const Value.absent(),
                Value<String?> remotePath = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<int?> pageCount = const Value.absent(),
                Value<int?> fileSize = const Value.absent(),
                Value<String?> folderId = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> currentPage = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> lastReadAt = const Value.absent(),
                Value<String?> fileHash = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PdfsCompanion.insert(
                id: id,
                title: title,
                fileName: fileName,
                localPath: localPath,
                remotePath: remotePath,
                coverPath: coverPath,
                pageCount: pageCount,
                fileSize: fileSize,
                folderId: folderId,
                source: source,
                isFavorite: isFavorite,
                currentPage: currentPage,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastReadAt: lastReadAt,
                fileHash: fileHash,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PdfsTable, PdfEntry>(table),
                  $$PdfsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookmarksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (bookmarksRefs) db.bookmarks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (bookmarksRefs)
                    await $_getPrefetchedData<
                      PdfEntry,
                      $PdfsTable,
                      BookmarkEntry
                    >(
                      currentTable: table,
                      referencedTable: $$PdfsTableReferences
                          ._bookmarksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PdfsTableReferences(db, table, p0).bookmarksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.pdfId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PdfsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PdfsTable,
      PdfEntry,
      $$PdfsTableFilterComposer,
      $$PdfsTableOrderingComposer,
      $$PdfsTableAnnotationComposer,
      $$PdfsTableCreateCompanionBuilder,
      $$PdfsTableUpdateCompanionBuilder,
      (PdfEntry, $$PdfsTableReferences),
      PdfEntry,
      PrefetchHooks Function({bool bookmarksRefs})
    >;
typedef $$FoldersTableCreateCompanionBuilder = FoldersCompanion Function({
  required String id,
  required String name,
  Value<String?> parentId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$FoldersTableUpdateCompanionBuilder = FoldersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> parentId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$FoldersTableFilterComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoldersTableOrderingComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoldersTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FoldersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoldersTable,
          FolderEntry,
          $$FoldersTableFilterComposer,
          $$FoldersTableOrderingComposer,
          $$FoldersTableAnnotationComposer,
          $$FoldersTableCreateCompanionBuilder,
          $$FoldersTableUpdateCompanionBuilder,
          (
            FolderEntry,
            BaseReferences<_$AppDatabase, $FoldersTable, FolderEntry>,
          ),
          FolderEntry,
          PrefetchHooks Function()
        > {
  $$FoldersTableTableManager(_$AppDatabase db, $FoldersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoldersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoldersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoldersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoldersCompanion(
                id: id,
                name: name,
                parentId: parentId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> parentId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => FoldersCompanion.insert(
                id: id,
                name: name,
                parentId: parentId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FoldersTable, FolderEntry>(table),
                  BaseReferences<_$AppDatabase, $FoldersTable, FolderEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoldersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoldersTable,
      FolderEntry,
      $$FoldersTableFilterComposer,
      $$FoldersTableOrderingComposer,
      $$FoldersTableAnnotationComposer,
      $$FoldersTableCreateCompanionBuilder,
      $$FoldersTableUpdateCompanionBuilder,
      (FolderEntry, BaseReferences<_$AppDatabase, $FoldersTable, FolderEntry>),
      FolderEntry,
      PrefetchHooks Function()
    >;
typedef $$BookmarksTableCreateCompanionBuilder = BookmarksCompanion Function({
  required String id,
  required String pdfId,
  required int pageNumber,
  Value<String?> label,
  Value<String?> note,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$BookmarksTableUpdateCompanionBuilder = BookmarksCompanion Function({
  Value<String> id,
  Value<String> pdfId,
  Value<int> pageNumber,
  Value<String?> label,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

final class $$BookmarksTableReferences
    extends BaseReferences<_$AppDatabase, $BookmarksTable, BookmarkEntry> {
  $$BookmarksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PdfsTable _pdfIdTable(_$AppDatabase db) =>
      db.pdfs.createAlias('bookmarks__pdf_id__pdfs__id');

  $$PdfsTableProcessedTableManager get pdfId {
    final $_column = $_itemColumn<String>('pdf_id')!;

    final manager = $$PdfsTableTableManager(
      $_db,
      $_db.pdfs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pdfIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PdfsTableFilterComposer get pdfId {
    final $$PdfsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pdfId,
      referencedTable: $db.pdfs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PdfsTableFilterComposer(
            $db: $db,
            $table: $db.pdfs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PdfsTableOrderingComposer get pdfId {
    final $$PdfsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pdfId,
      referencedTable: $db.pdfs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PdfsTableOrderingComposer(
            $db: $db,
            $table: $db.pdfs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PdfsTableAnnotationComposer get pdfId {
    final $$PdfsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pdfId,
      referencedTable: $db.pdfs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PdfsTableAnnotationComposer(
            $db: $db,
            $table: $db.pdfs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookmarksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookmarksTable,
          BookmarkEntry,
          $$BookmarksTableFilterComposer,
          $$BookmarksTableOrderingComposer,
          $$BookmarksTableAnnotationComposer,
          $$BookmarksTableCreateCompanionBuilder,
          $$BookmarksTableUpdateCompanionBuilder,
          (BookmarkEntry, $$BookmarksTableReferences),
          BookmarkEntry,
          PrefetchHooks Function({bool pdfId})
        > {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> pdfId = const Value.absent(),
                Value<int> pageNumber = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookmarksCompanion(
                id: id,
                pdfId: pdfId,
                pageNumber: pageNumber,
                label: label,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String pdfId,
                required int pageNumber,
                Value<String?> label = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookmarksCompanion.insert(
                id: id,
                pdfId: pdfId,
                pageNumber: pageNumber,
                label: label,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BookmarksTable, BookmarkEntry>(table),
                  $$BookmarksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pdfId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (pdfId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.pdfId,
                        referencedTable: $$BookmarksTableReferences._pdfIdTable(
                          db,
                        ),
                        referencedColumn: $$BookmarksTableReferences
                            ._pdfIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BookmarksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookmarksTable,
      BookmarkEntry,
      $$BookmarksTableFilterComposer,
      $$BookmarksTableOrderingComposer,
      $$BookmarksTableAnnotationComposer,
      $$BookmarksTableCreateCompanionBuilder,
      $$BookmarksTableUpdateCompanionBuilder,
      (BookmarkEntry, $$BookmarksTableReferences),
      BookmarkEntry,
      PrefetchHooks Function({bool pdfId})
    >;
typedef $$GitHubAccountsTableCreateCompanionBuilder =
    GitHubAccountsCompanion Function({
      required String id,
      required String githubUserId,
      required String login,
      Value<String?> avatarUrl,
      Value<String?> name,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$GitHubAccountsTableUpdateCompanionBuilder =
    GitHubAccountsCompanion Function({
      Value<String> id,
      Value<String> githubUserId,
      Value<String> login,
      Value<String?> avatarUrl,
      Value<String?> name,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$GitHubAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $GitHubAccountsTable> {
  $$GitHubAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get githubUserId => $composableBuilder(
    column: $table.githubUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get login => $composableBuilder(
    column: $table.login,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GitHubAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $GitHubAccountsTable> {
  $$GitHubAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get githubUserId => $composableBuilder(
    column: $table.githubUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get login => $composableBuilder(
    column: $table.login,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GitHubAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GitHubAccountsTable> {
  $$GitHubAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get githubUserId => $composableBuilder(
    column: $table.githubUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get login =>
      $composableBuilder(column: $table.login, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GitHubAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GitHubAccountsTable,
          GitHubAccountEntry,
          $$GitHubAccountsTableFilterComposer,
          $$GitHubAccountsTableOrderingComposer,
          $$GitHubAccountsTableAnnotationComposer,
          $$GitHubAccountsTableCreateCompanionBuilder,
          $$GitHubAccountsTableUpdateCompanionBuilder,
          (
            GitHubAccountEntry,
            BaseReferences<
              _$AppDatabase,
              $GitHubAccountsTable,
              GitHubAccountEntry
            >,
          ),
          GitHubAccountEntry,
          PrefetchHooks Function()
        > {
  $$GitHubAccountsTableTableManager(
    _$AppDatabase db,
    $GitHubAccountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GitHubAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GitHubAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GitHubAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> githubUserId = const Value.absent(),
                Value<String> login = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GitHubAccountsCompanion(
                id: id,
                githubUserId: githubUserId,
                login: login,
                avatarUrl: avatarUrl,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String githubUserId,
                required String login,
                Value<String?> avatarUrl = const Value.absent(),
                Value<String?> name = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => GitHubAccountsCompanion.insert(
                id: id,
                githubUserId: githubUserId,
                login: login,
                avatarUrl: avatarUrl,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GitHubAccountsTable, GitHubAccountEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $GitHubAccountsTable,
                    GitHubAccountEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GitHubAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GitHubAccountsTable,
      GitHubAccountEntry,
      $$GitHubAccountsTableFilterComposer,
      $$GitHubAccountsTableOrderingComposer,
      $$GitHubAccountsTableAnnotationComposer,
      $$GitHubAccountsTableCreateCompanionBuilder,
      $$GitHubAccountsTableUpdateCompanionBuilder,
      (
        GitHubAccountEntry,
        BaseReferences<_$AppDatabase, $GitHubAccountsTable, GitHubAccountEntry>,
      ),
      GitHubAccountEntry,
      PrefetchHooks Function()
    >;
typedef $$GitHubRepositoriesTableCreateCompanionBuilder =
    GitHubRepositoriesCompanion Function({
      required String id,
      Value<String?> githubRepoId,
      required String owner,
      required String name,
      required String fullName,
      Value<String> defaultBranch,
      Value<bool> isPrivate,
      Value<bool> isSelected,
      Value<DateTime?> lastSyncedAt,
      Value<String?> remoteHeadSha,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$GitHubRepositoriesTableUpdateCompanionBuilder =
    GitHubRepositoriesCompanion Function({
      Value<String> id,
      Value<String?> githubRepoId,
      Value<String> owner,
      Value<String> name,
      Value<String> fullName,
      Value<String> defaultBranch,
      Value<bool> isPrivate,
      Value<bool> isSelected,
      Value<DateTime?> lastSyncedAt,
      Value<String?> remoteHeadSha,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$GitHubRepositoriesTableFilterComposer
    extends Composer<_$AppDatabase, $GitHubRepositoriesTable> {
  $$GitHubRepositoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get githubRepoId => $composableBuilder(
    column: $table.githubRepoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get owner => $composableBuilder(
    column: $table.owner,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultBranch => $composableBuilder(
    column: $table.defaultBranch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPrivate => $composableBuilder(
    column: $table.isPrivate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSelected => $composableBuilder(
    column: $table.isSelected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteHeadSha => $composableBuilder(
    column: $table.remoteHeadSha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GitHubRepositoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $GitHubRepositoriesTable> {
  $$GitHubRepositoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get githubRepoId => $composableBuilder(
    column: $table.githubRepoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get owner => $composableBuilder(
    column: $table.owner,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultBranch => $composableBuilder(
    column: $table.defaultBranch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPrivate => $composableBuilder(
    column: $table.isPrivate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSelected => $composableBuilder(
    column: $table.isSelected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteHeadSha => $composableBuilder(
    column: $table.remoteHeadSha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GitHubRepositoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GitHubRepositoriesTable> {
  $$GitHubRepositoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get githubRepoId => $composableBuilder(
    column: $table.githubRepoId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get owner =>
      $composableBuilder(column: $table.owner, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get defaultBranch => $composableBuilder(
    column: $table.defaultBranch,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPrivate =>
      $composableBuilder(column: $table.isPrivate, builder: (column) => column);

  GeneratedColumn<bool> get isSelected => $composableBuilder(
    column: $table.isSelected,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remoteHeadSha => $composableBuilder(
    column: $table.remoteHeadSha,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GitHubRepositoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GitHubRepositoriesTable,
          GitHubRepositoryEntry,
          $$GitHubRepositoriesTableFilterComposer,
          $$GitHubRepositoriesTableOrderingComposer,
          $$GitHubRepositoriesTableAnnotationComposer,
          $$GitHubRepositoriesTableCreateCompanionBuilder,
          $$GitHubRepositoriesTableUpdateCompanionBuilder,
          (
            GitHubRepositoryEntry,
            BaseReferences<
              _$AppDatabase,
              $GitHubRepositoriesTable,
              GitHubRepositoryEntry
            >,
          ),
          GitHubRepositoryEntry,
          PrefetchHooks Function()
        > {
  $$GitHubRepositoriesTableTableManager(
    _$AppDatabase db,
    $GitHubRepositoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GitHubRepositoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GitHubRepositoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GitHubRepositoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> githubRepoId = const Value.absent(),
                Value<String> owner = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> defaultBranch = const Value.absent(),
                Value<bool> isPrivate = const Value.absent(),
                Value<bool> isSelected = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<String?> remoteHeadSha = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GitHubRepositoriesCompanion(
                id: id,
                githubRepoId: githubRepoId,
                owner: owner,
                name: name,
                fullName: fullName,
                defaultBranch: defaultBranch,
                isPrivate: isPrivate,
                isSelected: isSelected,
                lastSyncedAt: lastSyncedAt,
                remoteHeadSha: remoteHeadSha,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> githubRepoId = const Value.absent(),
                required String owner,
                required String name,
                required String fullName,
                Value<String> defaultBranch = const Value.absent(),
                Value<bool> isPrivate = const Value.absent(),
                Value<bool> isSelected = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<String?> remoteHeadSha = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => GitHubRepositoriesCompanion.insert(
                id: id,
                githubRepoId: githubRepoId,
                owner: owner,
                name: name,
                fullName: fullName,
                defaultBranch: defaultBranch,
                isPrivate: isPrivate,
                isSelected: isSelected,
                lastSyncedAt: lastSyncedAt,
                remoteHeadSha: remoteHeadSha,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GitHubRepositoriesTable, GitHubRepositoryEntry>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $GitHubRepositoriesTable,
                    GitHubRepositoryEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GitHubRepositoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GitHubRepositoriesTable,
      GitHubRepositoryEntry,
      $$GitHubRepositoriesTableFilterComposer,
      $$GitHubRepositoriesTableOrderingComposer,
      $$GitHubRepositoriesTableAnnotationComposer,
      $$GitHubRepositoriesTableCreateCompanionBuilder,
      $$GitHubRepositoriesTableUpdateCompanionBuilder,
      (
        GitHubRepositoryEntry,
        BaseReferences<
          _$AppDatabase,
          $GitHubRepositoriesTable,
          GitHubRepositoryEntry
        >,
      ),
      GitHubRepositoryEntry,
      PrefetchHooks Function()
    >;
typedef $$SyncMetadataTableCreateCompanionBuilder =
    SyncMetadataCompanion Function({
      required String id,
      required String pdfId,
      required String repositoryId,
      required String remotePath,
      Value<String?> remoteSha,
      Value<int?> remoteSize,
      Value<String?> localHash,
      Value<DateTime?> lastSyncedAt,
      Value<String> syncStatus,
      Value<String?> lastError,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SyncMetadataTableUpdateCompanionBuilder =
    SyncMetadataCompanion Function({
      Value<String> id,
      Value<String> pdfId,
      Value<String> repositoryId,
      Value<String> remotePath,
      Value<String?> remoteSha,
      Value<int?> remoteSize,
      Value<String?> localHash,
      Value<DateTime?> lastSyncedAt,
      Value<String> syncStatus,
      Value<String?> lastError,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SyncMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pdfId => $composableBuilder(
    column: $table.pdfId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repositoryId => $composableBuilder(
    column: $table.repositoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remotePath => $composableBuilder(
    column: $table.remotePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteSha => $composableBuilder(
    column: $table.remoteSha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remoteSize => $composableBuilder(
    column: $table.remoteSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localHash => $composableBuilder(
    column: $table.localHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pdfId => $composableBuilder(
    column: $table.pdfId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repositoryId => $composableBuilder(
    column: $table.repositoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remotePath => $composableBuilder(
    column: $table.remotePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteSha => $composableBuilder(
    column: $table.remoteSha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remoteSize => $composableBuilder(
    column: $table.remoteSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localHash => $composableBuilder(
    column: $table.localHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pdfId =>
      $composableBuilder(column: $table.pdfId, builder: (column) => column);

  GeneratedColumn<String> get repositoryId => $composableBuilder(
    column: $table.repositoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remotePath => $composableBuilder(
    column: $table.remotePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remoteSha =>
      $composableBuilder(column: $table.remoteSha, builder: (column) => column);

  GeneratedColumn<int> get remoteSize => $composableBuilder(
    column: $table.remoteSize,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localHash =>
      $composableBuilder(column: $table.localHash, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetadataTable,
          SyncMetadataEntry,
          $$SyncMetadataTableFilterComposer,
          $$SyncMetadataTableOrderingComposer,
          $$SyncMetadataTableAnnotationComposer,
          $$SyncMetadataTableCreateCompanionBuilder,
          $$SyncMetadataTableUpdateCompanionBuilder,
          (
            SyncMetadataEntry,
            BaseReferences<
              _$AppDatabase,
              $SyncMetadataTable,
              SyncMetadataEntry
            >,
          ),
          SyncMetadataEntry,
          PrefetchHooks Function()
        > {
  $$SyncMetadataTableTableManager(_$AppDatabase db, $SyncMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> pdfId = const Value.absent(),
                Value<String> repositoryId = const Value.absent(),
                Value<String> remotePath = const Value.absent(),
                Value<String?> remoteSha = const Value.absent(),
                Value<int?> remoteSize = const Value.absent(),
                Value<String?> localHash = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataCompanion(
                id: id,
                pdfId: pdfId,
                repositoryId: repositoryId,
                remotePath: remotePath,
                remoteSha: remoteSha,
                remoteSize: remoteSize,
                localHash: localHash,
                lastSyncedAt: lastSyncedAt,
                syncStatus: syncStatus,
                lastError: lastError,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String pdfId,
                required String repositoryId,
                required String remotePath,
                Value<String?> remoteSha = const Value.absent(),
                Value<int?> remoteSize = const Value.absent(),
                Value<String?> localHash = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataCompanion.insert(
                id: id,
                pdfId: pdfId,
                repositoryId: repositoryId,
                remotePath: remotePath,
                remoteSha: remoteSha,
                remoteSize: remoteSize,
                localHash: localHash,
                lastSyncedAt: lastSyncedAt,
                syncStatus: syncStatus,
                lastError: lastError,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncMetadataTable, SyncMetadataEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SyncMetadataTable,
                    SyncMetadataEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetadataTable,
      SyncMetadataEntry,
      $$SyncMetadataTableFilterComposer,
      $$SyncMetadataTableOrderingComposer,
      $$SyncMetadataTableAnnotationComposer,
      $$SyncMetadataTableCreateCompanionBuilder,
      $$SyncMetadataTableUpdateCompanionBuilder,
      (
        SyncMetadataEntry,
        BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataEntry>,
      ),
      SyncMetadataEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PdfsTableTableManager get pdfs => $$PdfsTableTableManager(_db, _db.pdfs);
  $$FoldersTableTableManager get folders =>
      $$FoldersTableTableManager(_db, _db.folders);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
  $$GitHubAccountsTableTableManager get gitHubAccounts =>
      $$GitHubAccountsTableTableManager(_db, _db.gitHubAccounts);
  $$GitHubRepositoriesTableTableManager get gitHubRepositories =>
      $$GitHubRepositoriesTableTableManager(_db, _db.gitHubRepositories);
  $$SyncMetadataTableTableManager get syncMetadata =>
      $$SyncMetadataTableTableManager(_db, _db.syncMetadata);
}
