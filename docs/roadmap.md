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

## Phase 3 — Search, Favorites, Bookmarks & Continue Reading
- Instant real-time search across local PDF library titles.
- Favorite toggling with persistent state in SQLite.
- Favorites dedicated view with filter options.
- In-reader page bookmarking with optional notes/labels.
- Bookmarks management view and quick-jump navigation.

---

## Phase 4 — GitHub Integration
- GitHub repository connection flow via Personal Access Token (PAT).
- Secure token storage using `flutter_secure_storage`.
- GitHub REST API service: fetch tree, commits, and repository metadata.
- Repository configuration management (add, edit, remove repositories).
- Token validation, rate-limiting handling, and connection state checks.

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

