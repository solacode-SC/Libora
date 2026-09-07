# Libora

A simple, fast, local-first PDF reading and organization app for Desktop and Mobile, with connected GitHub repository exploration.

---

## The Concept

> **My Library** = PDFs I have downloaded or imported locally on my device.  
> **Explore** = PDFs available from connected GitHub repositories without downloading everything in advance.

Libora is designed like a personal bookshelf: your local device contains only the books you want to read right now, while GitHub acts as an optional remote library.

---

## Features (Phase 0 Foundation)

- **Local-First**: Complete offline capability powered by Drift & SQLite.
- **Cross-Platform**: Desktop (Linux, Windows, macOS) and Mobile (Android, iOS-ready).
- **Responsive Layout**: Adaptive navigation (desktop sidebar vs mobile bottom navigation).
- **Clean Architecture**: Feature-oriented architecture with unidirectional data flow.
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

