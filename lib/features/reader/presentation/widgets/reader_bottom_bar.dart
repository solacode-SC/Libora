import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../controllers/reader_state.dart';

/// Compact bottom control bar for the PDF reader.
///
/// Contains zoom controls, zoom percentage, and page indicator.
class ReaderBottomBar extends StatelessWidget {
  final ReaderState readerState;
  final double currentZoom;
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onResetZoom;
  final VoidCallback? onFitWidth;

  const ReaderBottomBar({
    super.key,
    required this.readerState,
    this.currentZoom = 1.0,
    this.onZoomIn,
    this.onZoomOut,
    this.onResetZoom,
    this.onFitWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final bgColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    final zoomPercent = (currentZoom * 100).round();

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.95),
        border: Border(top: BorderSide(color: borderColor, width: 1.0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        children: [
          // Zoom controls
          AppIconButton(
            icon: Icons.remove_rounded,
            tooltip: 'Zoom out',
            onPressed: onZoomOut,
            size: 30,
          ),
          const SizedBox(width: AppSpacing.xxs),

          // Zoom percentage
          GestureDetector(
            onTap: onResetZoom,
            child: Container(
              width: 54,
              alignment: Alignment.center,
              child: Text(
                '$zoomPercent%',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: secondaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),

          AppIconButton(
            icon: Icons.add_rounded,
            tooltip: 'Zoom in',
            onPressed: onZoomIn,
            size: 30,
          ),

          const SizedBox(width: AppSpacing.sm),

          // Fit width button
          AppButton.ghost(
            label: 'Fit Width',
            size: AppButtonSize.small,
            onPressed: onFitWidth,
          ),

          const Spacer(),

          // Page indicator
          if (readerState.totalPages > 0)
            Text(
              readerState.pageIndicator,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                fontFeatures: const [FontFeature.tabularFigures()],
                color: secondaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
