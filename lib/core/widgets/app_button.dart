import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

enum AppButtonVariant {
  primary,
  secondary,
  ghost,
}

enum AppButtonSize {
  small,
  medium,
}

/// A stable, editorial button that guarantees zero layout shifts across
/// default, hover, pressed, focused, and disabled states.
class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.secondary,
    this.size = AppButtonSize.medium,
    this.isFullWidth = false,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.size = AppButtonSize.medium,
    this.isFullWidth = false,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.size = AppButtonSize.medium,
    this.isFullWidth = false,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.size = AppButtonSize.medium,
    this.isFullWidth = false,
  }) : variant = AppButtonVariant.ghost;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  bool get _isEnabled => widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Resolve static dimensions (must never vary between states)
    final height = widget.size == AppButtonSize.small ? 32.0 : 38.0;
    final paddingHorizontal = widget.size == AppButtonSize.small ? 12.0 : 16.0;
    final fontSize = widget.size == AppButtonSize.small ? 12.5 : 13.5;
    const iconSize = 16.0;

    // Compute state-dependent colors
    final colors = _resolveColors(isDark);

    return FocusableActionDetector(
      enabled: _isEnabled,
      onShowFocusHighlight: (v) => setState(() => _isFocused = v),
      onShowHoverHighlight: (v) => setState(() => _isHovered = v),
      child: GestureDetector(
        onTapDown: _isEnabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: _isEnabled ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: _isEnabled ? () => setState(() => _isPressed = false) : null,
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          height: height,
          width: widget.isFullWidth ? double.infinity : null,
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: AppSpacing.roundedSm,
            // Border width is strictly 1.0 at all times to prevent layout shifts
            border: Border.all(
              color: colors.border,
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: iconSize,
                  color: colors.foreground,
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                  color: colors.foreground,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _ButtonColors _resolveColors(bool isDark) {
    if (!_isEnabled) {
      return _ButtonColors(
        background: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
        border: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        foreground: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
      );
    }

    switch (widget.variant) {
      case AppButtonVariant.primary:
        if (isDark) {
          if (_isPressed) {
            return const _ButtonColors(
              background: AppColors.warmBeige,
              border: AppColors.warmBeige,
              foreground: AppColors.darkBackground,
            );
          }
          if (_isHovered || _isFocused) {
            return const _ButtonColors(
              background: Colors.white,
              border: Colors.white,
              foreground: AppColors.darkBackground,
            );
          }
          return const _ButtonColors(
            background: AppColors.darkTextPrimary,
            border: AppColors.darkTextPrimary,
            foreground: AppColors.darkBackground,
          );
        } else {
          if (_isPressed) {
            return const _ButtonColors(
              background: Colors.black,
              border: Colors.black,
              foreground: Colors.white,
            );
          }
          if (_isHovered || _isFocused) {
            return const _ButtonColors(
              background: AppColors.lightTextPrimary,
              border: AppColors.lightTextPrimary,
              foreground: Colors.white,
            );
          }
          return const _ButtonColors(
            background: AppColors.strongCharcoal,
            border: AppColors.strongCharcoal,
            foreground: AppColors.lightSurface,
          );
        }

      case AppButtonVariant.secondary:
        if (isDark) {
          if (_isPressed) {
            return const _ButtonColors(
              background: AppColors.darkSubtleAccent,
              border: AppColors.darkTextSecondary,
              foreground: AppColors.darkTextPrimary,
            );
          }
          if (_isHovered || _isFocused) {
            return const _ButtonColors(
              background: AppColors.darkSurfaceSubtle,
              border: AppColors.darkBorderStrong,
              foreground: AppColors.darkTextPrimary,
            );
          }
          return const _ButtonColors(
            background: Colors.transparent,
            border: AppColors.darkBorder,
            foreground: AppColors.darkTextPrimary,
          );
        } else {
          if (_isPressed) {
            return const _ButtonColors(
              background: AppColors.warmBeige,
              border: AppColors.strongCharcoal,
              foreground: AppColors.lightTextPrimary,
            );
          }
          if (_isHovered || _isFocused) {
            return const _ButtonColors(
              background: AppColors.lightSurfaceSubtle,
              border: AppColors.lightBorderStrong,
              foreground: AppColors.lightTextPrimary,
            );
          }
          return const _ButtonColors(
            background: Colors.transparent,
            border: AppColors.lightBorder,
            foreground: AppColors.lightTextPrimary,
          );
        }

      case AppButtonVariant.ghost:
        if (isDark) {
          if (_isPressed) {
            return const _ButtonColors(
              background: AppColors.darkSubtleAccent,
              border: Colors.transparent,
              foreground: AppColors.darkTextPrimary,
            );
          }
          if (_isHovered || _isFocused) {
            return const _ButtonColors(
              background: AppColors.darkSurfaceSubtle,
              border: Colors.transparent,
              foreground: AppColors.darkTextPrimary,
            );
          }
          return const _ButtonColors(
            background: Colors.transparent,
            border: Colors.transparent,
            foreground: AppColors.darkTextSecondary,
          );
        } else {
          if (_isPressed) {
            return const _ButtonColors(
              background: AppColors.warmBeige,
              border: Colors.transparent,
              foreground: AppColors.lightTextPrimary,
            );
          }
          if (_isHovered || _isFocused) {
            return const _ButtonColors(
              background: AppColors.lightSurfaceSubtle,
              border: Colors.transparent,
              foreground: AppColors.lightTextPrimary,
            );
          }
          return const _ButtonColors(
            background: Colors.transparent,
            border: Colors.transparent,
            foreground: AppColors.lightTextSecondary,
          );
        }
    }
  }
}

/// An editorial icon button with stable square bounds and subtle transitions.
class AppIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.size = 36.0,
  });

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  bool get _isEnabled => widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color bg;
    Color border;
    Color fg;

    if (!_isEnabled) {
      bg = Colors.transparent;
      border = Colors.transparent;
      fg = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    } else if (_isPressed) {
      bg = isDark ? AppColors.darkSubtleAccent : AppColors.warmBeige;
      border = isDark ? AppColors.darkBorderStrong : AppColors.strongCharcoal;
      fg = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    } else if (_isHovered || _isFocused) {
      bg = isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle;
      border = isDark ? AppColors.darkBorderStrong : AppColors.lightBorderStrong;
      fg = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    } else {
      bg = Colors.transparent;
      border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
      fg = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    }

    Widget child = FocusableActionDetector(
      enabled: _isEnabled,
      onShowFocusHighlight: (v) => setState(() => _isFocused = v),
      onShowHoverHighlight: (v) => setState(() => _isHovered = v),
      child: GestureDetector(
        onTapDown: _isEnabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: _isEnabled ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: _isEnabled ? () => setState(() => _isPressed = false) : null,
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          width: widget.size,
          height: widget.size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: AppSpacing.roundedSm,
            border: Border.all(color: border, width: 1.0),
          ),
          child: Icon(
            widget.icon,
            size: widget.size * 0.5,
            color: fg,
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: child);
    }
    return child;
  }
}

class _ButtonColors {
  final Color background;
  final Color border;
  final Color foreground;

  const _ButtonColors({
    required this.background,
    required this.border,
    required this.foreground,
  });
}

