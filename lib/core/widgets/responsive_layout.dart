import 'package:flutter/material.dart';

import '../constants/breakpoints.dart';

/// Builder widget that renders different layouts based on window width.
class ResponsiveLayout extends StatelessWidget {
  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context) desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (Breakpoints.isDesktop(width)) {
          return desktop(context);
        } else if (Breakpoints.isTablet(width)) {
          return (tablet ?? desktop)(context);
        } else {
          return mobile(context);
        }
      },
    );
  }
}
