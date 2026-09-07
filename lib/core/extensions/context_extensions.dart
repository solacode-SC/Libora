import 'package:flutter/material.dart';

import '../constants/breakpoints.dart';

/// Ergonomic BuildContext extensions for theme and layout queries.
extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  bool get isMobile => Breakpoints.isMobile(screenWidth);
  bool get isTablet => Breakpoints.isTablet(screenWidth);
  bool get isDesktop => Breakpoints.isDesktop(screenWidth);
}
