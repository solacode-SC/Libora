/// Domain entity representing a PDF found in a connected GitHub repository.
/// Distinct from [PdfItem] which represents an imported or downloaded PDF.
class RemotePdfItem {
  final String id;
  final String title;
  final String remotePath;
  final String? coverUrl;
  final int? fileSize;
  final String repositoryId;
  final String repositoryName;
  final String downloadUrl;
  final bool isDownloaded;
  final String? localPdfId;

  const RemotePdfItem({
    required this.id,
    required this.title,
    required this.remotePath,
    this.coverUrl,
    this.fileSize,
    required this.repositoryId,
    required this.repositoryName,
    required this.downloadUrl,
    this.isDownloaded = false,
    this.localPdfId,
  });

  RemotePdfItem copyWith({
    String? id,
    String? title,
    String? remotePath,
    String? coverUrl,
    int? fileSize,
    String? repositoryId,
    String? repositoryName,
    String downloadUrl = '',
    bool? isDownloaded,
    String? localPdfId,
  }) {
    return RemotePdfItem(
      id: id ?? this.id,
      title: title ?? this.title,
      remotePath: remotePath ?? this.remotePath,
      coverUrl: coverUrl ?? this.coverUrl,
      fileSize: fileSize ?? this.fileSize,
      repositoryId: repositoryId ?? this.repositoryId,
      repositoryName: repositoryName ?? this.repositoryName,
      downloadUrl: downloadUrl.isNotEmpty ? downloadUrl : this.downloadUrl,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      localPdfId: localPdfId ?? this.localPdfId,
    );
  }
}
