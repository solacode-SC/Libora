import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';
import 'package:web/web.dart' as web;

import '../pdf_storage_service.dart';

PdfStorageService createPdfStorage({dynamic localStorage}) => WebPdfStorage();

/// Concrete web implementation of [PdfStorageService] using browser IndexedDB.
class WebPdfStorage implements PdfStorageService {
  static const String _dbName = 'libora_storage';
  static const int _dbVersion = 1;
  static const String _pdfStore = 'pdfs';
  static const String _coverStore = 'covers';

  web.IDBDatabase? _db;

  Future<web.IDBDatabase> _getDb() async {
    if (_db != null) return _db!;

    final completer = Completer<web.IDBDatabase>();
    final request = web.window.indexedDB.open(_dbName, _dbVersion);

    request.onupgradeneeded = ((web.IDBVersionChangeEvent event) {
      final db = request.result as web.IDBDatabase;
      if (!db.objectStoreNames.contains(_pdfStore)) {
        db.createObjectStore(_pdfStore);
      }
      if (!db.objectStoreNames.contains(_coverStore)) {
        db.createObjectStore(_coverStore);
      }
    }).toJS;

    request.onsuccess = ((web.Event event) {
      _db = request.result as web.IDBDatabase;
      completer.complete(_db!);
    }).toJS;

    request.onerror = ((web.Event event) {
      completer.completeError(
        'Failed to open IndexedDB: ${request.error?.name ?? "unknown error"}',
      );
    }).toJS;

    return completer.future;
  }

  Future<void> _put(String storeName, String key, Uint8List bytes) async {
    final db = await _getDb();
    final completer = Completer<void>();
    final tx = db.transaction(storeName.toJS, 'readwrite');
    final store = tx.objectStore(storeName);
    final request = store.put(bytes.toJS, key.toJS);

    request.onsuccess = ((web.Event event) {
      completer.complete();
    }).toJS;

    request.onerror = ((web.Event event) {
      completer.completeError(
        'Failed to put in $storeName: ${request.error?.name ?? "unknown error"}',
      );
    }).toJS;

    return completer.future;
  }

  Future<Uint8List?> _get(String storeName, String key) async {
    final db = await _getDb();
    final completer = Completer<Uint8List?>();
    final tx = db.transaction(storeName.toJS, 'readonly');
    final store = tx.objectStore(storeName);
    final request = store.get(key.toJS);

    request.onsuccess = ((web.Event event) {
      final res = request.result;
      if (res == null || res.isUndefinedOrNull) {
        completer.complete(null);
        return;
      }
      if (res.typeofEquals('object')) {
        try {
          final jsArray = res as JSUint8Array;
          completer.complete(jsArray.toDart);
          return;
        } catch (_) {
          try {
            final buffer = res as JSArrayBuffer;
            completer.complete(buffer.toDart.asUint8List());
            return;
          } catch (e) {
            completer.completeError('Failed to convert IndexedDB result to bytes: $e');
            return;
          }
        }
      }
      completer.complete(null);
    }).toJS;

    request.onerror = ((web.Event event) {
      completer.completeError(
        'Failed to get from $storeName: ${request.error?.name ?? "unknown error"}',
      );
    }).toJS;

    return completer.future;
  }

  Future<bool> _exists(String storeName, String key) async {
    final db = await _getDb();
    final completer = Completer<bool>();
    final tx = db.transaction(storeName.toJS, 'readonly');
    final store = tx.objectStore(storeName);
    final request = store.count(key.toJS);

    request.onsuccess = ((web.Event event) {
      final count = (request.result as JSNumber).toDartInt;
      completer.complete(count > 0);
    }).toJS;

    request.onerror = ((web.Event event) {
      completer.complete(false);
    }).toJS;

    return completer.future;
  }

  Future<void> _delete(String storeName, String key) async {
    final db = await _getDb();
    final completer = Completer<void>();
    final tx = db.transaction(storeName.toJS, 'readwrite');
    final store = tx.objectStore(storeName);
    final request = store.delete(key.toJS);

    request.onsuccess = ((web.Event event) {
      completer.complete();
    }).toJS;

    request.onerror = ((web.Event event) {
      completer.completeError(
        'Failed to delete from $storeName: ${request.error?.name ?? "unknown error"}',
      );
    }).toJS;

    return completer.future;
  }

  @override
  Future<void> savePdf({
    required String id,
    required Uint8List bytes,
    required String fileName,
  }) async {
    await _put(_pdfStore, id, bytes);
  }

  @override
  Future<Uint8List?> readPdf(String id) async {
    return await _get(_pdfStore, id);
  }

  @override
  Future<bool> exists(String id) async {
    return await _exists(_pdfStore, id);
  }

  @override
  Future<void> deletePdf(String id) async {
    await _delete(_pdfStore, id);
  }

  @override
  Future<void> movePdf({
    required String id,
    required String newPath,
  }) async {
    // In browser IndexedDB, keys are identifiers. No physical folder structure.
  }

  @override
  Future<int?> getFileSize(String id) async {
    final bytes = await readPdf(id);
    return bytes?.length;
  }

  @override
  Future<String?> getFilePath(String id) async => null;

  @override
  String? getFilePathOrNull(String id) => null;

  @override
  Future<void> saveCover({
    required String id,
    required Uint8List bytes,
  }) async {
    await _put(_coverStore, id, bytes);
  }

  @override
  Future<Uint8List?> readCover(String id) async {
    return await _get(_coverStore, id);
  }

  @override
  Future<void> deleteCover(String id) async {
    await _delete(_coverStore, id);
  }

  @override
  Future<String?> getCoverPath(String id) async => null;

  @override
  String? getCoverPathOrNull(String id) => null;
}
