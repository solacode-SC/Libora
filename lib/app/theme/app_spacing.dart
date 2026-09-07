import 'package:flutter/material.dart';

/// Centralized spacing, border radius, icon sizes, and elevation constants.
/// Designed for structured, generous whitespace and calm editorial alignment.
class AppSpacing {
  AppSpacing._();

  // Spacing Units (4, 8, 12, 16, 20, 24, 32, 40, 48, 64)
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 40.0;
  static const double section = 48.0;
  static const double massive = 64.0;

  // Insets
  static const EdgeInsets paddingXxs = EdgeInsets.all(xxs);
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  static const EdgeInsets paddingXxl = EdgeInsets.all(xxl);

  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(
    horizontal: md,
  );
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(
    horizontal: lg,
  );
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(
    horizontal: xl,
  );
  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(
    vertical: sm,
  );
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(
    vertical: md,
  );

  // Border Radii (Structured, restrained; no bubbly shapes)
  static const double radiusXs = 4.0;
  static const double radiusSm = 6.0; // Small controls, buttons, chips
  static const double radiusMd = 8.0; // Buttons, input boxes
  static const double radiusLg = 10.0; // Paper cards
  static const double radiusXl = 14.0; // Modals / Dialogs

  static const BorderRadius roundedXs = BorderRadius.all(
    Radius.circular(radiusXs),
  );
  static const BorderRadius roundedSm = BorderRadius.all(
    Radius.circular(radiusSm),
  );
  static const BorderRadius roundedMd = BorderRadius.all(
    Radius.circular(radiusMd),
  );
  static const BorderRadius roundedLg = BorderRadius.all(
    Radius.circular(radiusLg),
  );
  static const BorderRadius roundedXl = BorderRadius.all(
    Radius.circular(radiusXl),
  );

  // Icon Sizing (Monochrome, subtle)
  static const double iconSm = 16.0;
  static const double iconMd = 18.0;
  static const double iconLg = 22.0;
  static const double iconXl = 28.0;

  // Elevations (0 or pure 1px border lines; avoid floating shadows)
  static const double elevationNone = 0.0;
  static const double elevationSubtle = 1.0;

  // Sidebar / Desktop Dimensions
  static const double sidebarWidth = 248.0;
  static const double sidebarCollapsedWidth = 68.0;
  static const double topBarHeight = 56.0;
  static const double navItemHeight = 40.0;
}
