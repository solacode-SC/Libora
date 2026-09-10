import 'dart:typed_data';

/// Abstract storage contract for local PDF binaries and associated cover images.
///
/// Decouples Libora from physical desktop filesystem paths so that documents
/// can be stored in browser storage (IndexedDB) on Web and filesystem on Desktop.
abstract class PdfStorageService {
  /// Saves PDF bytes for document identified by [id].
  Future<void> savePdf({
    required String id,
    required Uint8List bytes,
    required String fileName,
  });

  /// Reads PDF bytes for document [id]. Returns null if not found.
  Future<Uint8List?> readPdf(String id);

  /// Checks if a PDF document [id] exists in storage.
  Future<bool> exists(String id);

  /// Deletes the PDF binary for [id].
  Future<void> deletePdf(String id);

  /// Moves or updates the logical path for [id] (used primarily for desktop organizing).
  Future<void> movePdf({
    required String id,
    required String newPath,
  });

  /// Returns the file size in bytes for document [id].
  Future<int?> getFileSize(String id);

  /// Returns the filesystem path for [id] if on Desktop, or null on Web.
  Future<String?> getFilePath(String id);

  /// Synchronously returns the filesystem path if cached, or null on Web.
  String? getFilePathOrNull(String id);

  /// Saves cached cover image bytes for document [id].
  Future<void> saveCover({
    required String id,
    required Uint8List bytes,
  });

  /// Reads cached cover image bytes for document [id]. Returns null if none.
  Future<Uint8List?> readCover(String id);

  /// Deletes cached cover image for document [id].
  Future<void> deleteCover(String id);

  /// Returns the filesystem cover path for [id] if on Desktop, or null on Web.
  Future<String?> getCoverPath(String id);

  /// Synchronously returns the filesystem cover path if cached, or null on Web.
  String? getCoverPathOrNull(String id);
}
