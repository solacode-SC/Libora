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

