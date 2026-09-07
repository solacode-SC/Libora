import '../../../folders/domain/models/folder_item.dart';
import '../../domain/models/pdf_item.dart';

enum LibraryFilter { all, favorites, recent }

enum LibrarySort {
  recentlyAdded,
  recentlyOpened,
  nameAsc,
  nameDesc,
  largest,
  smallest,
}

extension LibrarySortExtension on LibrarySort {
  String get label {
    switch (this) {
      case LibrarySort.recentlyAdded:
        return 'Recently Added';
      case LibrarySort.recentlyOpened:
        return 'Recently Opened';
      case LibrarySort.nameAsc:
        return 'Name A–Z';
      case LibrarySort.nameDesc:
        return 'Name Z–A';
      case LibrarySort.largest:
        return 'Largest';
      case LibrarySort.smallest:
        return 'Smallest';
    }
  }
}

class LibraryState {
  final List<PdfItem> allPdfs;
  final List<FolderItem> folders;
  final String searchQuery;
  final LibraryFilter selectedFilter;
  final LibrarySort selectedSort;
  final String? selectedFolderId;
  final bool isLoading;
  final bool isImporting;
  final String? importProgress;
  final String? userNotice;
  final String? errorMessage;

  const LibraryState({
    this.allPdfs = const [],
    this.folders = const [],
    this.searchQuery = '',
    this.selectedFilter = LibraryFilter.all,
    this.selectedSort = LibrarySort.recentlyAdded,
    this.selectedFolderId,
    this.isLoading = false,
    this.isImporting = false,
    this.importProgress,
    this.userNotice,
    this.errorMessage,
  });

  LibraryState copyWith({
    List<PdfItem>? allPdfs,
    List<FolderItem>? folders,
    String? searchQuery,
    LibraryFilter? selectedFilter,
    LibrarySort? selectedSort,
    String? Function()? selectedFolderId,
    bool? isLoading,
    bool? isImporting,
    String? Function()? importProgress,
    String? Function()? userNotice,
    String? Function()? errorMessage,
  }) {
    return LibraryState(
      allPdfs: allPdfs ?? this.allPdfs,
      folders: folders ?? this.folders,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedSort: selectedSort ?? this.selectedSort,
      selectedFolderId: selectedFolderId != null
          ? selectedFolderId()
          : this.selectedFolderId,
      isLoading: isLoading ?? this.isLoading,
      isImporting: isImporting ?? this.isImporting,
      importProgress: importProgress != null
          ? importProgress()
          : this.importProgress,
      userNotice: userNotice != null ? userNotice() : this.userNotice,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  /// Evaluates and returns the visible documents according to folder, filter tab, search query, and sort order.
  List<PdfItem> get visiblePdfs {
    var result = List<PdfItem>.from(allPdfs);

    // 1. Folder filter
    if (selectedFolderId != null) {
      result = result.where((p) => p.folderId == selectedFolderId).toList();
    }

    // 2. Tab filter
    switch (selectedFilter) {
      case LibraryFilter.all:
        break;
      case LibraryFilter.favorites:
        result = result.where((p) => p.isFavorite).toList();
        break;
      case LibraryFilter.recent:
        result = result.where((p) => p.lastReadAt != null).toList();
        break;
    }

    // 3. Search query
    final query = searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where((p) {
        final matchTitle = p.title.toLowerCase().contains(query);
        final matchFile = p.fileName.toLowerCase().contains(query);
        return matchTitle || matchFile;
      }).toList();
    }

    // 4. Sort order
    result.sort((a, b) {
      switch (selectedSort) {
        case LibrarySort.recentlyAdded:
          return b.createdAt.compareTo(a.createdAt);
        case LibrarySort.recentlyOpened:
          final aDate = a.lastReadAt ?? a.createdAt;
          final bDate = b.lastReadAt ?? b.createdAt;
          return bDate.compareTo(aDate);
        case LibrarySort.nameAsc:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case LibrarySort.nameDesc:
          return b.title.toLowerCase().compareTo(a.title.toLowerCase());
        case LibrarySort.largest:
          return (b.fileSize ?? 0).compareTo(a.fileSize ?? 0);
        case LibrarySort.smallest:
          return (a.fileSize ?? 0).compareTo(b.fileSize ?? 0);
      }
    });

    return result;
  }
}
