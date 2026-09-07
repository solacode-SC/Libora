import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/utils/app_logger.dart';

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        AppLogger.error(
          'Flutter Framework Error: ${details.exceptionAsString()}',
          tag: 'FlutterError',
          error: details.exception,
          stackTrace: details.stack,
        );
      };

      runApp(const ProviderScope(child: LiboraApp()));
    },
    (error, stackTrace) {
      AppLogger.error(
        'Unhandled Root Error: $error',
        tag: 'RootBoundary',
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
}
