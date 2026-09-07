import 'package:flutter/material.dart';

/// Semantic palette for Libora.
/// Calibrated for calm, reading-focused visual comfort with clean contrast.
class AppColors {
  AppColors._();

  // Light Palette
  static const Color lightBackground = Color(0xFFF9F9FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSubtle = Color(0xFFF2F3F5);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightBorderSubtle = Color(0xFFEFF0F2);
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF4B5563);
  static const Color lightTextMuted = Color(0xFF9CA3AF);

  // Dark Palette
  static const Color darkBackground = Color(0xFF121418);
  static const Color darkSurface = Color(0xFF1A1D23);
  static const Color darkSurfaceSubtle = Color(0xFF22262E);
  static const Color darkBorder = Color(0xFF2D323C);
  static const Color darkBorderSubtle = Color(0xFF232730);
  static const Color darkTextPrimary = Color(0xFFF3F4F6);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkTextMuted = Color(0xFF6B7280);

  // Accents (Muted Indigo & Warm Amber for reading focus)
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4338CA);

  static const Color favorite = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
}
