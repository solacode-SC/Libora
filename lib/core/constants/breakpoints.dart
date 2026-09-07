/// Layout breakpoints for responsive design.
/// - Mobile: < 600px
/// - Tablet: 600px - 1024px
/// - Desktop: > 1024px
class Breakpoints {
  Breakpoints._();

  static const double mobileMax = 600.0;
  static const double tabletMax = 1024.0;

  static bool isMobile(double width) => width < mobileMax;
  static bool isTablet(double width) =>
      width >= mobileMax && width <= tabletMax;
  static bool isDesktop(double width) => width > tabletMax;
}
