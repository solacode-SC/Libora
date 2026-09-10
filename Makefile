.DEFAULT_GOAL := help

# Optional arguments to pass to flutter run / flutter build
# Example: make chrome ARGS="--debug --web-port=8080"
ARGS ?=

# GDK backend for Linux desktop (defaults to x11 to avoid Wayland Mesa/VMware EGL buffer freezes)
# Override anytime with: make linux GDK_BACKEND=wayland
GDK_BACKEND ?= x11

## --------------------------------------
## Run Targets
## --------------------------------------

.PHONY: chrome web linux linux-wayland windows windowns win macos mac android ios web-server run

chrome: ## Run on Google Chrome (web)
	flutter run -d chrome $(ARGS)

web: ## Alias for chrome
	flutter run -d chrome $(ARGS)

linux: ## Run on Linux desktop (stable rendering backend)
	GDK_BACKEND=$(GDK_BACKEND) flutter run -d linux $(ARGS)

linux-wayland: ## Run on Linux desktop forcing native Wayland backend
	GDK_BACKEND=wayland flutter run -d linux $(ARGS)

windows: ## Run on Windows desktop
	flutter run -d windows $(ARGS)

windowns: ## Alias for windows
	flutter run -d windows $(ARGS)

win: ## Alias for windows
	flutter run -d windows $(ARGS)

macos: ## Run on macOS desktop
	flutter run -d macos $(ARGS)

mac: ## Alias for macos
	flutter run -d macos $(ARGS)

android: ## Run on connected Android device / emulator
	flutter run -d android $(ARGS)

ios: ## Run on iOS simulator / device
	flutter run -d ios $(ARGS)

web-server: ## Run on local web server
	flutter run -d web-server $(ARGS)

run: ## Run with default device or prompt device selection
	flutter run $(ARGS)

## --------------------------------------
## Build Targets
## --------------------------------------

.PHONY: build-linux build-windows build-macos build-web build-apk build-appbundle build-ios

build-linux: ## Build Linux desktop release binary
	flutter build linux $(ARGS)

build-windows: ## Build Windows desktop release binary
	flutter build windows $(ARGS)

build-macos: ## Build macOS desktop release binary
	flutter build macos $(ARGS)

build-web: ## Build Web release bundle
	flutter build web $(ARGS)

build-apk: ## Build Android release APK
	flutter build apk $(ARGS)

build-appbundle: ## Build Android release App Bundle (AAB)
	flutter build appbundle $(ARGS)

build-ios: ## Build iOS release bundle
	flutter build ios $(ARGS)

## --------------------------------------
## Development & Code Generation
## --------------------------------------

.PHONY: get upgrade clean doctor devices codegen codegen-watch watch format analyze lint test check

get: ## Install dependencies (flutter pub get)
	flutter pub get

upgrade: ## Upgrade dependencies (flutter pub upgrade)
	flutter pub upgrade

clean: ## Clean build cache and temporary files
	flutter clean

doctor: ## Run Flutter Doctor diagnostic
	flutter doctor -v

devices: ## List all connected devices
	flutter devices

codegen: ## Run build_runner code generator (Drift, etc.)
	dart run build_runner build --delete-conflicting-outputs

codegen-watch: ## Watch and re-run build_runner on file changes
	dart run build_runner watch --delete-conflicting-outputs

watch: ## Alias for codegen-watch
	dart run build_runner watch --delete-conflicting-outputs

format: ## Format Dart code in lib and test
	dart format lib test

analyze: ## Analyze Dart code for errors and lint warnings
	flutter analyze

lint: ## Alias for analyze
	flutter analyze

test: ## Run unit and widget tests
	flutter test

check: ## Run analyzer and test suite together
	flutter analyze && flutter test

## --------------------------------------
## Help
## --------------------------------------

.PHONY: help

help: ## Show this help message
	@echo "Libora - Flutter Application Makefile"
	@echo ""
	@echo "Usage:"
	@echo "  make <target> [ARGS=\"...\"]"
	@echo ""
	@echo "Available Targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

