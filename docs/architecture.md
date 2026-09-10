# Libora Architecture

## 1. Overview & Product Concept

**Libora** is a simple, fast, local-first PDF reading and organization application built with Flutter.

The core product distinction is:
- **My Library**: PDFs downloaded or imported locally onto the device.
- **Explore**: PDFs available in connected remote GitHub repositories without downloading everything in advance.

The application acts like a **personal bookshelf**, where GitHub serves as a remote bookshelf and the local device stores only the PDFs the user has chosen to download or import.

---

## 2. Core Architectural Principles

### Local-First
- The local device is always the primary source of truth.
- Local SQLite (via Drift) stores all local metadata, reading progress, bookmarks, favorites, and folder structure.
- Full offline capability: reading, organizing, searching, and navigating work seamlessly without internet access.
- Remote data from GitHub is cached locally when queried, but distinct from local library items until downloaded.

### Client-Only Simplicity
- Libora is a self-contained Flutter client application.
- No heavy custom backends, microservices, or complex cloud dependencies (no Firebase, no GraphQL, no cloud databases).
- GitHub connectivity is handled directly from Flutter through a clean service and repository layer using the GitHub REST API.

### Multi-Platform & Responsive
- Target platforms: Windows, Linux, macOS, Android (with future iOS support).
- Adaptive user interface:
  - **Desktop (>1024px)**: Permanent/collapsible navigation sidebar, multi-column grids, keyboard navigation shortcuts.
  - **Tablet (600px - 1024px)**: Responsive navigation rail/bottom bar, balanced grid densities.
  - **Mobile (<600px)**: Compact bottom navigation bar, touch-first card layouts, compact app bars.

---

## 3. Layered Architecture

Libora follows a clean, feature-oriented architecture adhering to strict unidirectional dependency rules:

```
Presentation Layer (Widgets, Screens, Riverpod Controllers)
        ↓
Domain Layer (Entities, Models, Business Rules)
        ↓
Data Layer (Repositories, DAOs, SQLite / Drift)
        ↓
External Layer (Filesystem, GitHub API, Secure Storage)
```

Direct access across layers is prohibited:
- UI components **never** query SQLite, Drift DAOs, or the filesystem directly.
- UI components communicate exclusively with **Riverpod StateNotifiers / Notifiers / Providers**.
- Providers delegate persistence and networking to **Repositories** and **Services**.
- Sensitive tokens are stored solely in **FlutterSecureStorage** and never in SQLite, logs, or plain text.

---

## 4. Directory Structure

```text
lib/
├── app/
│   ├── app.dart                    # MaterialApp.router with Riverpod and Theme
│   ├── router.dart                 # Declarative go_router configuration
│   └── theme/
│       ├── app_theme.dart          # Light, Dark, System ThemeData
│       ├── app_colors.dart         # Semantic color palette
│       ├── app_typography.dart     # Material 3 typographic styles
│       └── app_spacing.dart        # Spacing scale, radii, elevation
│
├── core/
│   ├── constants/
│   │   ├── app_constants.dart      # Application constants
│   │   └── breakpoints.dart        # Responsive layout breakpoints
│   ├── errors/
│   │   ├── app_exception.dart      # Sealed exception hierarchy
│   │   └── failure.dart            # Presentation-friendly failure representation
│   ├── extensions/
│   │   ├── context_extensions.dart # Theme & MediaQuery helpers
│   │   └── string_extensions.dart
│   ├── utils/
│   │   └── app_logger.dart         # Safe logging with token redaction
│   ├── services/
│   │   ├── pdf_file_service.dart   # File import and validation
│   │   ├── pdf_thumbnail_service.dart # First-page cover extraction
│   │   ├── download_service.dart   # Background chunked downloads
│   │   ├── github_service.dart     # GitHub REST API interface
│   │   └── storage_service.dart    # App directory path resolution
│   └── widgets/
│       ├── responsive_layout.dart  # Adaptive layout builder
│       ├── app_scaffold.dart       # Shell scaffold (Sidebar vs BottomNav)
│       └── app_sidebar.dart        # Desktop navigation rail/sidebar
│
├── database/
│   ├── app_database.dart           # Drift database class & connection provider
│   ├── connection/                 # Native and in-memory connection strategies
│   ├── tables/
│   │   ├── pdfs_table.dart         # Pdfs SQLite schema
│   │   ├── folders_table.dart      # Folders SQLite schema
│   │   └── bookmarks_table.dart    # Bookmarks SQLite schema
│   └── daos/
│       ├── pdfs_dao.dart           # Typed operations for PDFs
│       ├── folders_dao.dart        # Typed operations for Folders
│       └── bookmarks_dao.dart      # Typed operations for Bookmarks
│
├── features/
│   ├── home/                       # Dashboard: Recent, stats, quick access
│   ├── library/                    # Local PDFs grid/list, sorting, filter
│   ├── explore/                    # Remote GitHub repository browser
│   ├── reader/                     # PDF viewer (pdfrx), page controls
│   ├── favorites/                  # Favorited items quick filter
│   ├── bookmarks/                  # Saved page markers
│   ├── folders/                    # User-defined folder collections
│   ├── downloads/                  # Active & completed download queue
│   ├── github/                     # Repository manager & credentials
│   └── settings/                   # Appearance, storage, and app options
│
└── main.dart                       # App entrypoint with ProviderScope
```

---

## 5. Domain Models & Distinction

### Local PDF vs Remote PDF

The domain model explicitly enforces the distinction between a local document and a remote document:

```dart
// Local PDF: downloaded, fully available on device
class PdfItem {
  final String id;
  final String title;
  final String fileName;
  final String? localPath;
  final String? remotePath;
  final String? coverPath;
  final int? pageCount;
  final int? fileSize;
  final String? folderId;
  final String source; // 'local' | 'github'
  final bool isFavorite;
  final int currentPage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastReadAt;
}

// Remote PDF: available in a connected GitHub repository, not yet downloaded
class RemotePdfItem {
  final String id;
  final String title;
  final String remotePath;
  final String? coverUrl;
  final int? fileSize;
  final String repositoryId;
  final bool isDownloaded;
}
```

---

## 6. Database Schema (Drift / SQLite — Schema v4)

### `pdfs` Table
- `id` (TEXT, Primary Key)
- `title` (TEXT, NOT NULL)
- `file_name` (TEXT, NOT NULL)
- `local_path` (TEXT, NULLABLE)
- `remote_path` (TEXT, NULLABLE)
- `cover_path` (TEXT, NULLABLE)
- `page_count` (INTEGER, NULLABLE)
- `file_size` (INTEGER, NULLABLE)
- `folder_id` (TEXT, NULLABLE, Foreign Key -> `folders.id`)
- `source` (TEXT, DEFAULT 'local')
- `is_favorite` (BOOLEAN, DEFAULT FALSE)
- `current_page` (INTEGER, DEFAULT 0)
- `created_at` (DATETIME, NOT NULL)
- `updated_at` (DATETIME, NOT NULL)
- `last_read_at` (DATETIME, NULLABLE)
- `file_hash` (TEXT, NULLABLE) — SHA-256 hash for fast deduplication

### `folders` Table
- `id` (TEXT, Primary Key)
- `name` (TEXT, NOT NULL)
- `parent_id` (TEXT, NULLABLE)
- `created_at` (DATETIME, NOT NULL)
- `updated_at` (DATETIME, NOT NULL)

### `bookmarks` Table
- `id` (TEXT, Primary Key)
- `pdf_id` (TEXT, NOT NULL, Foreign Key -> `pdfs.id`, `ON DELETE CASCADE`)
- `page_number` (INTEGER, NOT NULL)
- `label` (TEXT, NULLABLE)
- `note` (TEXT, NULLABLE)
- `created_at` (DATETIME, NOT NULL)
- `updated_at` (DATETIME, NULLABLE)
- **Constraint**: Unique on `(pdf_id, page_number)` — guarantees 1 bookmark per page per PDF.

### `git_hub_accounts` Table
- `id` (TEXT, Primary Key)
- `username` (TEXT, NOT NULL)
- `name` (TEXT, NULLABLE)
- `avatar_url` (TEXT, NULLABLE)
- `created_at` (DATETIME, NOT NULL)
- `updated_at` (DATETIME, NOT NULL)

### `git_hub_repositories` Table
- `id` (TEXT, Primary Key)
- `account_id` (TEXT, NOT NULL, Foreign Key -> `git_hub_accounts.id`, `ON DELETE CASCADE`)
- `name` (TEXT, NOT NULL)
- `full_name` (TEXT, NOT NULL)
- `default_branch` (TEXT, NOT NULL, DEFAULT 'main')
- `is_private` (BOOLEAN, NOT NULL, DEFAULT FALSE)
- `is_selected` (BOOLEAN, NOT NULL, DEFAULT FALSE)
- `last_synced_at` (DATETIME, NULLABLE)
- `created_at` (DATETIME, NOT NULL)
- `updated_at` (DATETIME, NOT NULL)

### `sync_metadata` Table
- `id` (TEXT, Primary Key)
- `pdf_id` (TEXT, NOT NULL, Unique, Foreign Key -> `pdfs.id`, `ON DELETE CASCADE`)
- `remote_path` (TEXT, NOT NULL)
- `remote_sha` (TEXT, NULLABLE)
- `local_hash` (TEXT, NULLABLE)
- `sync_status` (TEXT, NOT NULL, DEFAULT 'synced') — 'synced' | 'pending' | 'downloading' | 'conflicted'
- `last_synced_at` (DATETIME, NULLABLE)
- `created_at` (DATETIME, NOT NULL)
- `updated_at` (DATETIME, NOT NULL)

---

## 7. Managed Local Storage Architecture

Libora isolates all user-imported files in the application documents directory under a deterministic folder hierarchy:

```text
<app_documents_directory>/libora/
├── library/
│   ├── pdfs/
│   │   └── <uuid-v4>.pdf      # Immutable sandboxed copies of imported PDFs
│   └── covers/
│       └── <uuid-v4>.jpg      # High-density JPEG cover thumbnails rendered via pdfrx
└── libora.sqlite              # Drift SQLite relational database file
```

### Ingestion & Deduplication Pipeline
1. **Selection**: User selects one or multiple PDFs via `file_picker`.
2. **Validation**: Files are inspected for magic bytes `%PDF-` (`0x25, 0x50, 0x44, 0x46, 0x2D`) to ensure valid PDF headers.
3. **Hashing**: SHA-256 hash is computed.
4. **Deduplication**: Database is queried for matching `file_hash` (or matching `file_size` + normalized `file_name`). Existing items are skipped with clear user feedback.
5. **Storage**: File is copied into `<docs>/libora/library/pdfs/<uuid>.pdf`.
6. **Cover Generation**: Page 0 is rendered to high-quality JPEG using `pdfrx` and stored in `<docs>/libora/library/covers/<uuid>.jpg`.
7. **Metadata & Title Cleaning**: Page count is extracted. Underscores, hyphens, and extension artifacts in the filename are cleaned into a readable book title (e.g. `flutter_in_action.pdf` -> `Flutter In Action`).
8. **Persistence**: `PdfItem` record is saved to SQLite and automatically published across reactive Drift streams to Riverpod controllers.

---

## 9. PDF Reader Architecture (Phase 2)

### Overview
The reader provides a full-featured, offline, and visually quiet reading experience powered by the mature `pdfrx` rendering engine. It runs on a dedicated route (`/reader/:pdfId`) outside the shell scaffold to provide maximum reading area across desktop and mobile.

### Layer Separation & Responsibilities
- **Presentation**:
  - `ReaderScreen`: Hosts `PdfViewer.file`, animated toolbars, and keyboard shortcut dispatchers.
  - `ReaderToolbar`: Top bar with back button, truncated document title, page indicator, and actions menu.
  - `ReaderBottomBar`: Compact bottom bar with zoom in/out, zoom percentage, fit-to-width button, and page progress.
  - `GoToPageDialog`: Modal with validation (`1 <= page <= totalPages`).
  - `PdfInfoDialog`: Modal with metadata (pages, size, folder, dates, calculated progress).
  - `ReaderLoadingWidget` / `ReaderErrorWidget`: Controlled, friendly states for loading, missing files, and corrupt PDFs.
- **State Management**:
  - `ReaderController` (`Notifier<ReaderState>`): Resolves local paths via `PdfRepository`, handles debounced position persistence (500ms), and coordinates toolbar visibility.
  - `ReaderState`: Immutable state tracking `currentPage`, `totalPages`, `isToolbarVisible`, `status`, and computed `progress`.
- **Data & Persistence**:
  - `PdfRepository` & `PdfsDao`: Persist `currentPage` and `lastReadAt` via `updateReadingProgress(id, page)`.
  - Re-opening any document restores the last known page directly via `initialPageNumber`.

### Reading Position & Progress Persistence
- UI updates page numbers immediately on scroll.
- SQLite writes are debounced by 500ms to avoid disk thrashing during rapid scrolling.
- Exiting the reader (via Back button, system pop, or `Esc` key) triggers an immediate, non-debounced position write.
- Reading progress percentage is derived dynamically on-the-fly: `progress = currentPage / totalPages`.

### Keyboard Shortcuts (Desktop)
- `Arrow Up` / `Arrow Down`: Smooth vertical scrolling
- `Page Up` / `Page Down`: Page-by-page scrolling
- `Home` / `End`: First and last page navigation
- `+` / `=`: Zoom in
- `-`: Zoom out
- `0`: Fit width / reset zoom
- `Esc`: Persist reading position and exit reader

### Known Limitations (Intentionally Deferred)
- In-document text selection and copy
- Full-text search within PDF contents
- In-document highlights and annotations

---

## 10. Search, Favorites, Bookmarks & Continue Reading (Phase 3)

### Continue Reading Shelf
- **Query & Filter**: `watchContinueReading({int limit = 6})` streams records matching `currentPage > 0 AND lastReadAt IS NOT NULL`, ordered by `lastReadAt DESC`.
- **Dashboard Presentation**: Featured prominently at the top of the Home dashboard with custom cover thumbnail, document title, `Page X of Y`, visual progress bar, and percentage indicator.
- **Empty State**: Intentionally concealed completely if no documents are currently in progress to avoid UI clutter.

### In-Reader Bookmarks & Bookmark Manager
- **Domain Model**: `BookmarkItem` (`id`, `pdfId`, `pageNumber`, `label`, `note`, `createdAt`, `updatedAt`).
- **Database Rules**: Enforces SQLite table-level unique constraint on `(pdf_id, page_number)`. Cascades deletions on `pdf_id` foreign key.
- **Quick Action & Dialog**:
  - Star icon (`Icons.bookmark_outline` / `Icons.bookmark`) in `ReaderToolbar` and `B` keyboard shortcut.
  - Tapping opens `BookmarkDialog` to configure custom label and note.
  - In-reader `ReaderBookmarksPanel` slides in to list all bookmarks for current PDF with single-click jump to page, inline editing, and deletion.
- **Global Bookmark Manager**:
  - Route `/bookmarks` lists all saved bookmarks across all PDFs.
  - Displays document title, page badge, creation/update date, and note preview.
  - Tapping any bookmark opens the reader directly at the bookmarked page via GoRouter path `/reader/:pdfId?page=:pageNumber`.

### Favorites Workflow
- **Reusability**: Leverages existing `isFavorite` column in `pdfs` table.
- **Interactivity**: Star toggle available directly on library cards, within the reader toolbar action menu, and inside the dedicated `/favorites` screen.

### Global & Local Search
- **SQLite Optimization**: `searchPdfs(query, {folderId})` uses SQL `LIKE` with case-insensitive lowercase matching on `title` and `fileName`.
- **Filtering**: Combines with folder scopes when browsing inside collections.

---

## 11. GitHub Synchronization & Mirroring Architecture (Phase 4)

A connected GitHub repository adheres to the following structural convention:
### 11.1 Architectural Principles
- **Direct PAT Authentication**: Users authenticate by supplying a Personal Access Token (classic `repo` scope or fine-grained repository permissions) directly into the app. There are no third-party backends, OAuth callback servers, or cloud intermediaries.
- **Strict Credential Isolation**: The PAT is stored exclusively in OS-level secure storage (`FlutterSecureStorage` using `libsecret` on Linux, Keychain on macOS/iOS, KeyStore on Android, and DPAPI on Windows). Tokens are NEVER written to SQLite, persistent app settings, files, error logs, or debug console output.
- **Local-First Safety Invariant**: Disconnecting from GitHub, losing network connectivity, or encountering remote file deletions will NEVER automatically delete or corrupt local PDFs. Local documents remain fully intact. Remote deletions only affect local storage if explicitly selected by the user via the dual-choice deletion dialog.

```text
my-pdf-library/
│
├── library.json                 # Optional lightweight index
├── covers/                      # Cached or pre-rendered cover images
│   ├── clean-code.jpg
│   └── chapter-001.jpg
├── Books/
│   ├── Clean Code.pdf
│   └── Atomic Habits.pdf
└── Manga/
    └── One Piece/
        ├── Chapter 001.pdf
        └── Chapter 002.pdf
```
### 11.2 Deterministic Folder Mirroring (`FolderPathResolver`)
Libora establishes a 1-to-1 deterministic mapping between the local SQLite folder hierarchy and remote GitHub repository paths:
- **Local -> Remote**: `FolderPathResolver.resolveRemotePath(pdf, folderPath)`
  - Root documents map to `{fileName}.pdf` in the repository root (e.g. `Clean Code.pdf`).
  - Nested documents map to `{folderPath}/{fileName}.pdf` (e.g. `Books/Tech/Clean Code.pdf`).
- **Remote -> Local**: `FolderPathResolver.resolveFolderPath(remotePath)`
  - Reconstructs intermediate folder entities in the local database matching the path hierarchy (e.g. `Books/Tech/` -> creates or finds `Books` folder, then `Tech` child folder with `parentId`).
  - Leaves root files with `folderId = null`.

The Explore view downloads only metadata (or parses repository directory tree via GitHub Git Trees API) and cover images, allowing smooth browsing without pulling multi-gigabyte PDF archives until requested by the user.
### 11.3 Idempotent Two-Way Sync Engine (`LibrarySyncEngine`)
The sync engine performs an atomic, idempotent five-step synchronization cycle:
1. **Remote Tree Scan**: Fetches the recursive Git tree (`GET /repos/{owner}/{repo}/git/trees/{branch}?recursive=1`) and parses all `.pdf` blobs along with their Git SHA-1 hashes.
2. **Local-to-Remote Reconciliation**:
   - Compares local PDFs against remote tree paths and `sync_metadata` records.
   - New local files are uploaded to GitHub via the Contents API (`PUT /repos/{owner}/{repo}/contents/{path}`).
   - If a remote file was modified (`remote_sha` changed) while the local file also changed, conflict detection flags the record as `SyncStatus.conflicted` while preserving the local copy.
3. **Remote-to-Local Reconciliation**:
   - Detects remote PDFs not yet present locally.
   - Downloads PDF bytes, writes to sandboxed local storage (`<docs>/libora/library/pdfs/<uuid>.pdf`), computes SHA-256 hash, extracts page count, and generates high-res cover thumbnail via `PdfThumbnailService`.
   - Inserts local `PdfItem` record with `source = 'github'`.
4. **Path & Hierarchy Reconciliation**:
   - If a local file moved to another folder or was renamed, the sync engine updates `sync_metadata.remote_path` and schedules remote movement.
5. **Metadata Update & Zero-Write Idempotency**:
   - Updates `sync_metadata` with latest `remote_sha`, `local_hash`, `sync_status = 'synced'`, and `last_synced_at`.
   - On repeat syncs where no local or remote files changed, **0 API write calls and 0 disk writes** are executed.

### 11.4 Conflict Resolution & Deletion Workflows
- **Conflict Handling**: When a concurrent change occurs both locally and remotely, Libora marks the document as `SyncStatus.conflicted` in `sync_metadata`. Local modifications are never blindly overwritten.
- **Dual-Choice Deletion**: When deleting a PDF, the user is presented with two explicit choices:
  1. `Delete from Libora only`: Deletes local file and SQLite record; leaves the remote repository copy untouched.
  2. `Delete from Libora and GitHub`: Deletes local file, SQLite record, and sends a `DELETE /repos/{owner}/{repo}/contents/{path}` request to remove the file from GitHub.

### 11.5 State Management & UI Integration
- `gitHubConnectionControllerProvider` (`AsyncNotifier<GitHubConnectionState>`): Handles token validation against `GET /user`, saves token securely, and exposes connected account profile.
- `gitHubRepositoryControllerProvider` (`AsyncNotifier<GitHubRepositoryState>`): Lists accessible repositories (`GET /user/repos`), manages active repository selection, and creates new repositories if needed.
- `syncControllerProvider` (`AsyncNotifier<SyncProgress?>`): Manages sync execution, streams progress stages (`SyncStage.scanning`, `SyncStage.uploading`, `SyncStage.downloading`, etc.), and returns `SyncResult`.
- `gitHubSyncMetadataForPdfProvider(pdfId)`: Streams `SyncMetadataItem?` to render real-time status badges (`synced`, `pending`, `downloading`, `conflicted`) on `PdfCard` and in the Library toolbar.

---

## 12. Flutter Web Local PDF Storage & Reader Compatibility (Phase 3.5)

### 12.1 Web Storage Challenge & Design Strategy
Flutter Web executes in browser JavaScript / WASM sandbox environments where traditional desktop POSIX filesystem APIs (`dart:io` `File`, `Directory`) throw `UnsupportedError`. Previously, Libora checked `File(pdf.localPath).existsSync()`, which caused:
- Local PDF cards on Web to appear disabled or marked with missing-file warning badges.
- Imported PDFs to be lost on browser tab refresh.
- PDF reader crashes attempting to load via `PdfViewer.file()`.

To resolve this without branching presentation logic or compromising the desktop experience, Libora introduces a unified storage abstraction layer: `PdfStorageService`.

### 12.2 Unified Storage Abstraction (`PdfStorageService`)
`PdfStorageService` (`lib/core/storage/pdf_storage_service.dart`) provides an asynchronous binary storage contract for document files and generated cover images:
```dart
abstract class PdfStorageService {
  Future<void> initialize();
  Future<String> savePdf(String id, Uint8List bytes, {String? fileName});
  Future<Uint8List?> readPdf(String id);
  Future<bool> exists(String id);
  Future<void> deletePdf(String id);
  Future<void> movePdf(String oldId, String newId);
  Future<int?> getFileSize(String id);
  Future<String?> getFilePath(String id);

  Future<String> saveCover(String id, Uint8List bytes);
  Future<Uint8List?> readCover(String id);
  Future<void> deleteCover(String id);
  Future<String?> getCoverPath(String id);
}
```

### 12.3 Platform Implementations
Using Dart's conditional imports (`pdf_storage_factory.dart`):
1. **`WebPdfStorage` (`lib/core/storage/web/web_pdf_storage.dart`)**:
   - Backed by browser **IndexedDB** using modern `package:web` and `dart:js_interop`.
   - Uses dedicated database `libora_storage` (version 1) with two key-value object stores:
     - `pdfs`: Stores raw PDF binary bytes keyed by document `id`.
     - `covers`: Stores rendered JPEG thumbnail bytes keyed by cover/document `id`.
   - Fully persistent across browser reloads and sessions.
2. **`DesktopPdfStorage` (`lib/core/storage/desktop/desktop_pdf_storage.dart`)**:
   - Wraps the existing deterministic filesystem layout (`<docs>/libora/library/pdfs/<id>.pdf` and `covers/<id>.jpg`).
   - Ensures 100% backward compatibility for desktop paths and existing files.
3. **`MemoryPdfStorage` (`lib/core/storage/memory/memory_pdf_storage.dart`)**:
   - In-memory map storage used for fast, isolated unit and integration testing without disk or browser dependencies.

### 12.4 PDF Reader Compatibility on Web
- **Binary Stream Loading**: `ReaderController` loads the document into `ReaderState.pdfBytes` via `PdfStorageService.readPdf(id)`.
- **Dual Viewer Support**:
  - Web: Renders via `PdfViewer.data(readerState.pdfBytes)`.
  - Desktop/Mobile: Renders via `PdfViewer.file(localPath)`.
- **Initialization**: `pdfrxFlutterInitialize()` is invoked during `main()` setup to register web rendering workers and canvas decoders.
- **Reading Progress & Bookmarks**: Stored directly in Drift SQLite (Schema v4) with 500ms debouncing, identical to desktop.

### 12.5 Cover Rendering & UI Invariants
- `PdfCard` and `ContinueReadingCard` read cover image bytes asynchronously through `pdfStorageServiceProvider.readCover(coverId)`.
- When byte streams are returned, `Image.memory` displays the cached cover. On desktop fallback, `Image.file` is utilized.
- All cards remain interactive, selectable, and searchable on Web.

