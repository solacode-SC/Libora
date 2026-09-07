import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';

/// Error state widget for the PDF reader.
///
/// Handles missing files, corrupted PDFs, and generic errors.
class ReaderErrorWidget extends StatelessWidget {
  final String? title;
  final String errorMessage;
  final bool isFileAvailable;
  final VoidCallback onBack;
  final VoidCallback? onRemoveFromLibrary;

  const ReaderErrorWidget({
    super.key,
    this.title,
    required this.errorMessage,
    this.isFileAvailable = true,
    required this.onBack,
    this.onRemoveFromLibrary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Error icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceSubtle
                        : AppColors.lightSurfaceSubtle,
                    borderRadius: AppSpacing.roundedMd,
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                      width: 1.0,
                    ),
                  ),
                  child: Icon(
                    isFileAvailable
                        ? Icons.error_outline_rounded
                        : Icons.file_present_rounded,
                    size: 24,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Title
                if (title != null) ...[
                  Text(
                    title!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],

                // Error message
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Actions
                if (!isFileAvailable && onRemoveFromLibrary != null) ...[
                  AppButton.primary(
                    label: 'Remove from Library',
                    icon: Icons.delete_outline_rounded,
                    onPressed: onRemoveFromLibrary,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                AppButton.secondary(
                  label: 'Back',
                  icon: Icons.arrow_back_rounded,
                  onPressed: onBack,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
