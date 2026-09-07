import 'package:flutter/material.dart';

/// Centralized typographic styles adhering to Japanese minimalist editorial scale.
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Roboto';

  static TextTheme textTheme(Color textPrimary, Color textSecondary) {
    return TextTheme(
      // Page Titles (28-32px, restrained medium weight)
      headlineLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.25,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        height: 1.3,
        color: textPrimary,
      ),
      headlineSmall: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.2,
        height: 1.35,
        color: textPrimary,
      ),

      // Section Titles (18-20px, medium)
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.4,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.1,
        height: 1.4,
        color: textPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: textSecondary,
      ),

      // Body (14-15px, generous line height)
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.55,
        color: textSecondary,
      ),
      bodySmall: TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: textSecondary,
      ),

      // Eyebrows, Labels & Metadata (10-13px)
      labelLarge: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
        color: textPrimary,
      ),
      labelMedium: TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.0, // Clean editorial letter-spacing for uppercase tags
        color: textSecondary,
      ),
      labelSmall: TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
        color: textSecondary,
      ),
    );
  }
}
