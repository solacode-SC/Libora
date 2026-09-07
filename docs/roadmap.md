# Libora Engineering Roadmap

This roadmap defines the iterative development plan for Libora from initial foundation to full release.

---

## Phase 0 — Foundation (Current)
- Establish Flutter project scaffolding for desktop and mobile targets.
- Feature-oriented clean architecture and unidirectional dependency rules.
- State management foundation with Riverpod.
- Declarative adaptive routing with go_router (Sidebar on Desktop, BottomBar on Mobile).
- Drift + SQLite reactive database foundation (Tables: `pdfs`, `folders`, `bookmarks`).
- Design system: centralized colors, typography, spacing, and Light / Dark / System themes.
- Base repositories, service contracts, safe logging, and error handling hierarchy.
- Unit and widget test suite foundation.

---

## Phase 1 — Local PDF Library
- Local file picking and importing via `file_picker`.
- Copying/linking files to sandboxed application documents directory.
- PDF metadata extraction (title, page count, file size).
- First-page cover image generation and caching (`pdfrx` / native renderer).
- Library view: grid and list views, sorting (date added, title, last read), responsive card layouts.
- Empty states and import feedback.

---

## Phase 2 — PDF Reader
- PDF rendering engine integration using `pdfrx`.
- Continuous vertical scrolling and single-page horizontal paging modes.
- Zoom, pan, and page navigation controls.
- Automatic reading progress tracking (saving `currentPage` and `lastReadAt`).
- Fullscreen immersive reading mode for desktop and mobile.

---

## Phase 3 — Search, Favorites & Bookmarks
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

