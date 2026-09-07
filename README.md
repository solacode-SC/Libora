# Libora

A simple, fast, local-first PDF reading and organization app for Desktop and Mobile, with connected GitHub repository exploration.

---

## The Concept

> **My Library** = PDFs I have downloaded or imported locally on my device.  
> **Explore** = PDFs available from connected GitHub repositories without downloading everything in advance.

Libora is designed like a personal bookshelf: your local device contains only the books you want to read right now, while GitHub acts as an optional remote library.

---

## Features

### Search, Favorites, Bookmarks & Continue Reading (Phase 3)
- **Continue Reading Section**: Prominent visual shelf on the Home screen showing in-progress documents (`currentPage > 0`), progress bar, and percentage. Automatically hides when empty.
- **In-Reader Bookmarks**: Quick bookmark toggle (`B` shortcut and toolbar button) to mark pages with custom labels and notes. Enforces single bookmark per page.
- **Bookmark Manager**: Dedicated `/bookmarks` screen listing all saved bookmarks with direct jump into the reader at the target page.
- **Favorites Workflow**: Instant star/unstar toggle across library cards, reader actions, and dedicated `/favorites` screen.
- **Global & Local Search**: Fast SQLite-level queries indexing document titles and file names with case-insensitive matching.
- **Drift Schema v3**: Relational integrity with foreign key cascades, notes support, and unique page constraints.

### PDF Reader (Phase 2)
- **Dedicated Reader Route**: Decoupled `/reader/:pdfId` route loading documents through `PdfRepository`.
- **Native PDF Rendering**: Hardware-accelerated smooth vertical scrolling and zoom powered by `pdfrx`.
- **Reading Position Persistence**: Automatically saves and restores last-read page and timestamp to local SQLite.
- **Visual Controls**: Subtle auto-hiding top toolbar and bottom control bar with zoom percentage, page jump, and fit-width actions.
- **Go To Page & PDF Info**: Validated page jumping dialog and detailed document metadata dialog.
- **Desktop Keyboard Navigation**: Arrow keys, Page Up/Down, Home/End, +/- zoom, 0 fit width, and Esc back.
- **Controlled Error States**: Graceful missing-file handling with library cleanup action and corrupted PDF warnings.

### Local PDF Library (Phase 1)
- **Local PDF Import**: Import individual or batches of PDFs with file validation and SHA-256 deduplication.
- **Sandboxed Storage**: Managed documents storage in `<docs>/libora/library/pdfs/` and `covers/`.
- **Editorial Bookshelf View**: Clean, calm Japanese-editorial card grid with cover thumbnails, page counts, and missing-file badges.
- **Organization & Folders**: Create, rename, and manage folders with seamless PDF categorization and cascade detachment.
- **Search & 6-Way Sorting**: Instant real-time filtering, tab toggling (All, Favorites, Recent), and multiple sort orders.
- **Document Management**: Quick actions to favorite, rename, move to folder, or safely delete documents.

### Foundation & Architecture (Phase 0)
- **Local-First & Offline**: Complete offline capability powered by Drift & SQLite (Schema v2).
- **Cross-Platform**: Desktop (Linux, Windows, macOS) and Mobile (Android, iOS-ready).
- **Responsive Layout**: Adaptive navigation (desktop sidebar vs mobile bottom navigation).
- **Design System**: Content-first, reading-focused theme with Light, Dark, and System mode support.
- **Secure Token Storage**: GitHub credentials securely handled via OS keychain/keystore.

---

## Quickstart

### Prerequisites
- [Flutter SDK](https://flutter.dev) (>= 3.24.0)
- [Dart SDK](https://dart.dev) (>= 3.5.0)

### Setup & Run
```bash
# Get packages
flutter pub get

# Generate Drift database code
dart run build_runner build --delete-conflicting-outputs

# Run on desktop (Linux)
flutter run -d linux

# Run tests
flutter test

# Static analysis
flutter analyze
```

---

## Project Structure

```text
lib/
├── app/                  # Application root, theme, and router
├── core/                 # Constants, errors, logging, services, widgets
├── database/             # Drift database, tables, DAOs
├── features/             # Feature modules (home, library, explore, reader, etc.)
└── main.dart             # Main entrypoint with ProviderScope
```

See [docs/architecture.md](docs/architecture.md) for detailed architecture documentation and [docs/roadmap.md](docs/roadmap.md) for the development roadmap.

