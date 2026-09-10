# Libora Development Guide

This guide provides instructions on setting up the local environment, building, testing, and contributing to Libora.

---

## 1. Prerequisites

- **Flutter SDK**: `>= 3.24.0` (Stable channel)
- **Dart SDK**: `>= 3.5.0`
- **Platforms Supported**: Linux, Windows, macOS, Android

Ensure Flutter is available in your PATH:

```bash
flutter --version
dart --version
flutter doctor
```

---

## 2. Getting Started

### Clone and Enter Directory
```bash
cd /home/solacode/Desktop/Projects/Libora
```

### Install Dependencies
```bash
flutter pub get
```

### Run Code Generation
The project uses Drift for type-safe SQLite database operations. Whenever database tables or DAOs are modified, run:

```bash
# One-time build
dart run build_runner build --delete-conflicting-outputs

# Continuous watch during development
dart run build_runner watch --delete-conflicting-outputs
```

---

## 3. Running the Application

### Linux Desktop
```bash
flutter run -d linux
```

### Windows Desktop
```bash
flutter run -d windows
```

### macOS Desktop
```bash
flutter run -d macos
```

### Android Device / Emulator
```bash
flutter run -d android
```

### Web / Chrome
```bash
flutter run -d chrome
# or using Makefile:
make chrome
```

---

## 4. Code Quality & Formatting

Before committing code, verify all three checks:

### 1. Code Formatting
Format all Dart files according to the official style guide:

```bash
dart format .
```

To verify formatting in CI:
```bash
dart format --output=none --set-exit-if-changed .
```

### 2. Static Analysis
Run the analyzer to catch potential bugs and enforce linter rules:

```bash
flutter analyze
```

Ensure zero errors and zero warnings.

### 3. Automated Tests
Run the unit and widget test suite:

```bash
flutter test
```

---

## 5. Directory Structure Conventions

- When adding a new feature, place it under `lib/features/<feature_name>/` with subfolders:
  - `domain/` for pure Dart business models and entity logic.
  - `data/` for repositories and data sources.
  - `presentation/` for UI screens, widgets, and Riverpod providers.
- Never import UI widgets in domain or data layers.
- Always use `AppLogger` instead of `print` or `debugPrint`.
- Never commit secrets, GitHub tokens, or `.env` files.

---

## 6. PDF Reader Notes (Phase 2)

- The reader is accessed via `/reader/:pdfId` and renders using the native `pdfrx` package backed by `pdfium`.
- Navigation state and position are managed via `readerControllerProvider(pdfId)`.
- All reading positions (`currentPage`) and `lastReadAt` timestamps are persisted to Drift SQLite.
- Keyboard shortcuts for Linux/Desktop:
  - `Arrow Up` / `Arrow Down`: scroll up / down
  - `Page Up` / `Page Down`: previous / next page
  - `Home` / `End`: jump to page 1 / end
  - `+` / `=`: zoom in
  - `-`: zoom out
  - `0`: fit width
  - `B`: toggle bookmark modal for current page
  - `Esc`: exit reader and return to library

---

## 7. Search, Favorites, Bookmarks & Continue Reading Notes (Phase 3)

- **Database Migration (Schema v3)**: Bookmarks table includes `note`, `updatedAt`, foreign key cascade to `pdfs`, and unique constraint on `(pdfId, pageNumber)`.
- **Continue Reading**: Computed on the fly via `watchContinueReading` (`currentPage > 0 && lastReadAt != null`). If the list is empty, the continue reading section on the Home dashboard is concealed.
- **Bookmarks Management**:
  - In-reader: Quick bookmark icon in toolbar or `B` key opens `BookmarkDialog`. All PDF bookmarks can be viewed via the slide-out `ReaderBookmarksPanel`.
  - Global: `/bookmarks` displays all bookmarks across all documents. Clicking opens the reader at that exact page via route query parameter `?page=N`.
- **Favorites**: Toggle `isFavorite` directly via `PdfRepository.toggleFavorite(id, isFavorite)`. Reuses existing `pdfs` table column.
- **Search**: `PdfRepository.searchPdfs(query, {folderId})` enables case-insensitive substring search matching against `title` and `fileName`.

---

## 8. GitHub Repository Sync Notes (Phase 4)

- **Database Migration (Schema v4)**: Added `git_hub_accounts`, `git_hub_repositories`, and `sync_metadata` tables. Run `make codegen` or `dart run build_runner build` after modifying DAOs or schemas.
- **Security & Tokens**:
  - Personal Access Tokens (PAT) must never be logged or stored in SQLite. Use `GitHubTokenStorage` (`FlutterSecureStorage`).
  - All token usage is restricted to Authorization headers via `GitHubApiClient`.
- **Testing GitHub Sync Components**:
  - Run all GitHub-related tests:
    ```bash
    flutter test test/features/github/
    ```
  - Test suites include:
    - `folder_path_resolver_test.dart`: Deterministic bi-directional path mapping.
    - `github_token_storage_test.dart`: Secure storage read, write, and clear operations.
    - `github_api_client_test.dart`: Dio HTTP client handling of 200, 401, 403 (rate limit reset), 404, 409, and file size limits (>100MB).
    - `library_sync_engine_test.dart`: End-to-end sync, two-way uploads and downloads, folder movements, conflict detection, and zero-write repeat sync idempotency.
    - `github_controllers_test.dart`: Riverpod connection, repository, and sync controller state flows.
- **Local-First Verification**:
  - Verify that disconnecting or running offline does not alter local files.
  - Verify that dual-choice deletion correctly deletes remote or preserves remote according to user choice.

---

## 9. Flutter Web Development & Testing (Phase 3.5)

### Running on Chrome
```bash
# Direct Flutter CLI
flutter run -d chrome

# Using Makefile shortcut
make chrome
```

### Building for Web
```bash
flutter build web
# Output directory: build/web/
```

### Inspecting Local IndexedDB Storage
During Web development in Google Chrome:
1. Open Chrome DevTools (`F12` or `Ctrl+Shift+I`).
2. Navigate to the **Application** tab.
3. In the left panel, expand **Storage** -> **IndexedDB** -> **libora_storage**.
4. Inspect:
   - **`pdfs`**: Holds raw binary PDF blobs keyed by UUID.
   - **`covers`**: Holds generated JPEG thumbnail bytes.
5. In **IndexedDB** -> **libora_db**: Inspect SQLite tables managed by Drift WASM/web workers (`pdfs`, `folders`, `bookmarks`, `sync_metadata`).

### Web Testing & Provider Overrides
- Unit and widget tests run in a headless Dart VM environment where browser IndexedDB is not present.
- Use `MemoryPdfStorage` in unit and widget tests to isolate storage operations:
  ```dart
  final container = ProviderContainer(
    overrides: [
      pdfStorageServiceProvider.overrideWithValue(MemoryPdfStorage()),
    ],
  );
  ```
- All file picking in `PdfFileService` uses `PlatformFile.readAsBytes()` to ensure cross-platform compatibility across both desktop filesystem and browser memory blobs.


