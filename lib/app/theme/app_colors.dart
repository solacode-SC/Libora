import 'package:flutter/material.dart';

/// Semantic palette for Libora.
/// Inspired by Japanese minimalist editorial design:
/// warm paper, charcoal, beige, subtle monochrome contrast, and thin rules.
class AppColors {
  AppColors._();

  // Light Palette (Warm Paper & Editorial Charcoal)
  static const Color lightBackground = Color(0xFFF6F4EE);
  static const Color lightSurface = Color(0xFFFBF9F4);
  static const Color lightSurfaceSubtle = Color(0xFFEAE6DD);
  static const Color lightBorder = Color(0xFFD3CEC3);
  static const Color lightBorderStrong = Color(0xFFA9A398);
  static const Color lightTextPrimary = Color(0xFF242321);
  static const Color lightTextSecondary = Color(0xFF77736B);
  static const Color lightTextMuted = Color(0xFFBDBAB3);

  // Accent & Warm Neutrals
  static const Color warmBeige = Color(0xFFD8D0C2);
  static const Color subtleAccent = Color(0xFFE3DED4);
  static const Color strongCharcoal = Color(0xFF3A3936);

  // Dark Palette (Warm Dark Charcoal & Soft Paper Tones)
  static const Color darkBackground = Color(0xFF1C1B19);
  static const Color darkSurface = Color(0xFF242320);
  static const Color darkSurfaceSubtle = Color(0xFF2D2C28);
  static const Color darkBorder = Color(0xFF44413B);
  static const Color darkBorderStrong = Color(0xFF5A564F);
  static const Color darkTextPrimary = Color(0xFFF2EEE6);
  static const Color darkTextSecondary = Color(0xFFAAA59B);
  static const Color darkTextMuted = Color(0xFF757169);
  static const Color darkSubtleAccent = Color(0xFF32302A);

  // Semantic Colors (Restrained, Muted, Non-Neon)
  static const Color primary = Color(0xFF242321); // Charcoal as primary
  static const Color primaryDark = Color(
    0xFFF2EEE6,
  ); // Light paper in dark mode

  static const Color favorite = Color(0xFFC48B36); // Warm Amber
  static const Color success = Color(0xFF4E8062); // Muted Sage
  static const Color error = Color(0xFFB84A39); // Muted Terracotta
  static const Color warning = Color(0xFFC48B36); // Warm Ochre
  static const Color info = Color(0xFF54738C); // Muted Slate
}
