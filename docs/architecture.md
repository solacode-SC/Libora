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

## 6. Database Schema (Drift / SQLite)

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

### `folders` Table
- `id` (TEXT, Primary Key)
- `name` (TEXT, NOT NULL)
- `parent_id` (TEXT, NULLABLE)
- `created_at` (DATETIME, NOT NULL)
- `updated_at` (DATETIME, NOT NULL)

### `bookmarks` Table
- `id` (TEXT, Primary Key)
- `pdf_id` (TEXT, NOT NULL, Foreign Key -> `pdfs.id`)
- `page_number` (INTEGER, NOT NULL)
- `label` (TEXT, NULLABLE)
- `created_at` (DATETIME, NOT NULL)

---

## 7. Future GitHub Integration

A connected GitHub repository adheres to the following structural convention:

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

The Explore view downloads only metadata (or parses repository directory tree via GitHub Git Trees API) and cover images, allowing smooth browsing without pulling multi-gigabyte PDF archives until requested by the user.

