import 'dart:io';

typedef DownloadProgressCallback = void Function(
  int receivedBytes,
  int totalBytes,
);

/// Abstract service contract for background file downloading.
abstract class DownloadService {
  /// Downloads a file from [url] to [destinationPath] with progress updates.
  Future<File> downloadFile({
    required String url,
    required String destinationPath,
    Map<String, String>? headers,
    DownloadProgressCallback? onProgress,
  });

  /// Cancels an in-progress download task by ID.
  Future<void> cancelDownload(String taskId);
}
