import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Centralized ThemeData definitions for Libora.
/// Calibrated for Japanese minimalist editorial warmth, paper surfaces, and stable geometry.
class AppTheme {
  AppTheme._();

  /// Light theme definition (Warm Paper & Editorial Charcoal)
  static ThemeData get lightTheme {
    final colorScheme = const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.lightSurfaceSubtle,
      onPrimaryContainer: AppColors.lightTextPrimary,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      surfaceContainerHighest: AppColors.lightSurfaceSubtle,
      outline: AppColors.lightBorder,
      outlineVariant: AppColors.lightBorderStrong,
      error: AppColors.error,
      onError: Colors.white,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBackground: AppColors.lightBackground,
      cardColor: AppColors.lightSurface,
      borderColor: AppColors.lightBorder,
      textPrimary: AppColors.lightTextPrimary,
      textSecondary: AppColors.lightTextSecondary,
      brightness: Brightness.light,
    );
  }

  /// Dark theme definition (Warm Dark Charcoal & Soft Paper Tones)
  static ThemeData get darkTheme {
    final colorScheme = const ColorScheme.dark(
      primary: AppColors.primaryDark,
      onPrimary: AppColors.darkBackground,
      primaryContainer: AppColors.darkSurfaceSubtle,
      onPrimaryContainer: AppColors.darkTextPrimary,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      surfaceContainerHighest: AppColors.darkSurfaceSubtle,
      outline: AppColors.darkBorder,
      outlineVariant: AppColors.darkBorderStrong,
      error: AppColors.error,
      onError: Colors.white,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBackground: AppColors.darkBackground,
      cardColor: AppColors.darkSurface,
      borderColor: AppColors.darkBorder,
      textPrimary: AppColors.darkTextPrimary,
      textSecondary: AppColors.darkTextSecondary,
      brightness: Brightness.dark,
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color scaffoldBackground,
    required Color cardColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required Brightness brightness,
  }) {
    final textTheme = AppTypography.textTheme(textPrimary, textSecondary);
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: textTheme,
      dividerTheme: DividerThemeData(
        color: borderColor,
        thickness: 1.0,
        space: 1.0,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: AppSpacing.elevationNone,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedLg,
          side: BorderSide(color: borderColor, width: 1.0),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        foregroundColor: textPrimary,
        elevation: AppSpacing.elevationNone,
        scrolledUnderElevation: AppSpacing.elevationNone,
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return isDark
                  ? AppColors.darkSurfaceSubtle
                  : AppColors.lightSurfaceSubtle;
            }
            if (states.contains(WidgetState.pressed)) {
              return isDark ? AppColors.warmBeige : Colors.black;
            }
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)) {
              return isDark ? Colors.white : AppColors.lightTextPrimary;
            }
            return isDark
                ? AppColors.darkTextPrimary
                : AppColors.strongCharcoal;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted;
            }
            return isDark ? AppColors.darkBackground : AppColors.lightSurface;
          }),
          elevation: const WidgetStatePropertyAll(AppSpacing.elevationNone),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppSpacing.roundedSm),
          ),
          textStyle: WidgetStatePropertyAll(
            textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          animationDuration: const Duration(milliseconds: 140),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.pressed)) {
              return isDark ? AppColors.darkSubtleAccent : AppColors.warmBeige;
            }
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)) {
              return isDark
                  ? AppColors.darkSurfaceSubtle
                  : AppColors.lightSurfaceSubtle;
            }
            return Colors.transparent;
          }),
          foregroundColor: WidgetStatePropertyAll(textPrimary),
          side: WidgetStateProperty.resolveWith<BorderSide>((states) {
            if (states.contains(WidgetState.pressed)) {
              return BorderSide(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.strongCharcoal,
                width: 1.0,
              );
            }
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)) {
              return BorderSide(
                color: isDark
                    ? AppColors.darkBorderStrong
                    : AppColors.lightBorderStrong,
                width: 1.0,
              );
            }
            return BorderSide(color: borderColor, width: 1.0);
          }),
          elevation: const WidgetStatePropertyAll(AppSpacing.elevationNone),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppSpacing.roundedSm),
          ),
          textStyle: WidgetStatePropertyAll(
            textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          animationDuration: const Duration(milliseconds: 140),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(textPrimary),
          overlayColor: WidgetStatePropertyAll(
            isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 8),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppSpacing.roundedSm),
          ),
          textStyle: WidgetStatePropertyAll(
            textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          animationDuration: const Duration(milliseconds: 140),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: AppSpacing.roundedSm,
          borderSide: BorderSide(color: borderColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedSm,
          borderSide: BorderSide(color: borderColor, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedSm,
          borderSide: BorderSide(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.strongCharcoal,
            width: 1.0,
          ),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scaffoldBackground,
        indicatorColor: isDark
            ? AppColors.darkSurfaceSubtle
            : AppColors.lightSurfaceSubtle,
        elevation: AppSpacing.elevationNone,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelMedium!.copyWith(
              color: textPrimary,
              fontWeight: FontWeight.w600,
            );
          }
          return textTheme.labelMedium!.copyWith(
            color: textSecondary,
            fontWeight: FontWeight.w400,
          );
        }),
      ),
    );
  }
}
