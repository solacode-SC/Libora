import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// A paper card container with thin borders, clean padding, and subtle hover states.
class AppCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? customBackground;
  final bool isSelected;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.onTap,
    this.customBackground,
    this.isSelected = false,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultBg = widget.customBackground ??
        (isDark ? AppColors.darkSurface : AppColors.lightSurface);
    final defaultBorder = widget.isSelected
        ? (isDark ? AppColors.darkTextPrimary : AppColors.strongCharcoal)
        : (isDark ? AppColors.darkBorder : AppColors.lightBorder);

    final hoverBorder = widget.isSelected
        ? (isDark ? AppColors.darkTextPrimary : AppColors.strongCharcoal)
        : (isDark ? AppColors.darkBorderStrong : AppColors.lightBorderStrong);

    return MouseRegion(
      onEnter: widget.onTap != null ? (_) => setState(() => _isHovered = true) : null,
      onExit: widget.onTap != null ? (_) => setState(() => _isHovered = false) : null,
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: defaultBg,
            borderRadius: AppSpacing.roundedLg,
            border: Border.all(
              color: _isHovered ? hoverBorder : defaultBorder,
              width: 1.0,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

