# Libora Engineering Roadmap

This roadmap defines the iterative development plan for Libora from initial foundation to full release.

---

## Phase 0 — Foundation (Completed)
- Establish Flutter project scaffolding for desktop and mobile targets.
- Feature-oriented clean architecture and unidirectional dependency rules.
- State management foundation with Riverpod.
- Declarative adaptive routing with go_router (Sidebar on Desktop, BottomBar on Mobile).
- Drift + SQLite reactive database foundation (Tables: `pdfs`, `folders`, `bookmarks`).
- Design system: centralized colors, typography, spacing, and Light / Dark / System themes.
- Base repositories, service contracts, safe logging, and error handling hierarchy.
- Unit and widget test suite foundation.

---

## Phase 1 — Local PDF Library (Completed)
- Local file picking and importing via `file_picker` (supporting single and multi-file selection).
- Sandboxed application documents storage in `<docs>/libora/library/pdfs/` and `covers/`.
- PDF validation via magic bytes (`%PDF-`), page count extraction, and title formatting.
- SHA-256 file hashing and fast deduplication (rejecting re-imports gracefully).
- High-quality page-0 cover thumbnail extraction and disk caching via `pdfrx`.
- Responsive editorial `PdfCard` grid with missing-file detection badges.
- Dynamic instant search, tab filters (All, Favorites, Recent), and 6-way sorting.
- Folder creation, folder renaming, moving PDFs between folders, and safe folder deletion.
- In-place PDF renaming and safe deletion (removing managed PDF file, cover, and DB entry).
- Automated test suite covering DAOs, business logic, sorting, deduplication, responsive layout, and routing.

---

## Phase 2 — PDF Reader (Completed)
- Fullscreen immersive PDF reader route (`/reader/:pdfId`) decoupled from library UI.
- Native hardware-accelerated rendering, smooth vertical scrolling, and pinch/mouse zoom via `pdfrx`.
- Interactive toolbar with back button, truncated title, page indicators, and options menu.
- Fit Width, Fit Page, and reset zoom actions.
- Validated Go to Page dialog (`1 <= page <= totalPages`).
- PDF Information dialog showing title, file name, pages, size, folder, dates, and live progress bar.
- Automatic reading position persistence (`currentPage`, `lastReadAt`) with 500ms debounce.
- Instant position persistence on reader exit (`Esc` or Back).
- Restoration of reading position on document reopen.
- Controlled error states for missing local files (with "Remove from Library" option) and corrupted PDFs.
- Desktop keyboard shortcuts (arrows, Page Up/Down, Home/End, +/-, 0, Esc).
- Adaptive responsive layout across Desktop, Tablet, and Mobile.
- Full test coverage for reader state, progress calculations, and position persistence.

---

## Phase 3 — Search, Favorites, Bookmarks & Continue Reading (Completed)
- Drift Schema migration to v3 with `note`, `updatedAt`, foreign keys cascade, and unique `(pdfId, pageNumber)` constraint.
- Continue Reading shelf on Home screen with cover thumbnails, title, page progress, and visual progress bar.
- Auto-hiding Continue Reading section when no documents are in progress.
- Favorites workflow: toggle favorites from library cards, reader menu, and dedicated `/favorites` screen.
- In-reader bookmark creation and management (`B` shortcut, toolbar icon, custom label and note modal).
- In-reader slide-out bookmark drawer with instant page jumping, editing, and deletion.
- Dedicated `/bookmarks` screen aggregating all bookmarks across all documents with click-to-resume in reader.
- SQLite-level search query supporting case-insensitive matching across titles and filenames.
- Cascade deletion of bookmarks when a PDF is removed from the library.
- Automated tests covering bookmarking, continue reading queries, and search logic.

---

## Phase 3.5 — Flutter Web Local PDF Storage & Reader Compatibility (Completed)
- Cross-platform `PdfStorageService` abstraction isolating binary document and thumbnail storage from platform-specific IO APIs.
- Browser IndexedDB implementation (`WebPdfStorage`) using modern `package:web` and `dart:js_interop` with dedicated `pdfs` and `covers` object stores under `libora_storage`.
- In-memory test storage (`MemoryPdfStorage`) enabling fast and deterministic unit and widget testing without native dependencies.
- Multiplatform file picker refactoring using `PlatformFile.readAsBytes()` for seamless PDF imports across Web and Desktop without deprecated byte getters.
- Universal PDF Reader compatibility powered by `PdfViewer.data()` on Web and `PdfViewer.file()` on Desktop, with `pdfrxFlutterInitialize()` registered in `main.dart`.
- Memory-cached cover thumbnail rendering on `PdfCard` and `ContinueReadingCard` directly from IndexedDB byte streams.
- Full local PDF lifecycle on Web: Import -> IndexedDB storage -> Drift metadata persistence -> Search -> Open -> Read with 500ms debounced progress -> Bookmarks -> Delete (cascades to IndexedDB and Drift).
- Zero token leakage and zero regressions on desktop targets (Linux, Windows, macOS).

---

## Phase 4 — GitHub Repository Sync & Local Library Mirroring (Completed)
- Drift Schema migration to v4 introducing `git_hub_accounts`, `git_hub_repositories`, and `sync_metadata` tables.
- GitHub Personal Access Token (PAT) authentication with zero token leakage; credentials persisted exclusively in device keychain (`FlutterSecureStorage`).
- Robust GitHub REST API client (`GitHubApiClient`) with token validation, repository listing, Git trees, base64 content upload, direct binary streaming download, and deletion.
- Comprehensive GitHub error translation handling 401 unauthorized, 403/429 rate limits with reset timestamp, 404 not found, 409 empty repositories, 100MB file limit, and offline networks.
- Deterministic Folder Path Resolver (`FolderPathResolver`) bidirectionally mapping Libora's folder hierarchy to remote directory paths (e.g. `Books/Tech/Clean Code.pdf`).
- Two-Way Idempotent Synchronization Engine (`LibrarySyncEngine`):
  - Local Additions: Uploads local PDFs to GitHub and persists `SyncMetadata`.
  - Remote Additions: Downloads new PDFs from GitHub, validates PDF headers, resolves local folders, and imports into local library.
  - Idempotency: Subsequent sync with no changes executes 0 uploads, 0 downloads, and 0 writes.
  - Move/Rename Handling: Deletes old remote path and uploads to new path on local categorization changes.
  - Safe Remote Deletions: Remote deletions never wipe local files; marks them as detached/upload-pending.
  - Conflict Handling: Detects concurrent modifications on both ends without silent data loss.
- UI & Presentation Integration:
  - `GitHubScreen` featuring disconnected state (token input, scopes guide, security guarantees) and connected state (user avatar, repo switcher, sync status banner, last synced timestamp, live sync summary, mirror list).
  - Editorial `PdfCard` sync status indicators (`synced`, `uploadPending`, `downloadPending`, `conflict`, `error`, `syncing`).
  - `LibraryScreen` header sync button with live progress indicator.
  - Safe deletion dialog offering "Delete from Libora only" vs "Delete from Libora and GitHub".
- 105 automated unit and integration tests covering all features with zero regressions.

---

## Phase 5 — Explore (Remote Repositories)
- Remote repository browser: browse remote directories and files without downloading full PDFs.
- Parsing and display of remote PDF metadata (via `library.json` or directory inspection).
- Cover/thumbnail preview fetching for remote items.
- Distinction in UI between Remote vs Downloaded documents.

---

## Phase 6 — Downloads
- Background chunked PDF downloads via `Dio`.
- Download progress indicators (percentage, byte count, speed).
- Cancellation, pause, and retry capabilities.
- Automatic registration of downloaded files into local `pdfs` database table upon completion.
- Downloads queue and history screen.

---

## Phase 7 — Multi-Select & Batch Operations
- Multi-selection mode for local library and remote explore views.
- Batch downloading of multiple selected PDFs.
- Batch deletion and batch folder movement for local PDFs.
- Bulk favorite and tagging operations.

---

## Phase 8 — Series & Volume Organization
- Structural detection for multi-part publications (e.g. manga chapters, book volumes, journal issues).
- Series grouping model and hierarchical folder visualization.
- Auto-advancing reader (proceed to next chapter seamlessly).

---

## Phase 9 — Polish, Performance & Sync
- Optional bidirectional sync: upload local PDFs to connected GitHub repositories.
- Performance profiling for large libraries (10,000+ items).
- Keyboard shortcuts for desktop (reading shortcuts, navigation, search).
- Production release builds and packaging for Windows, Linux, macOS, and Android.

