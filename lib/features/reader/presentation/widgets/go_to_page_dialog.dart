import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

/// Dialog allowing the user to jump to a specific page in the PDF.
///
/// Validates that the entered page number is between 1 and [totalPages].
class GoToPageDialog extends StatefulWidget {
  final int currentPage;
  final int totalPages;

  const GoToPageDialog({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  /// Shows the dialog and returns the selected page number (1-indexed),
  /// or null if the user cancelled.
  static Future<int?> show(
    BuildContext context, {
    required int currentPage,
    required int totalPages,
  }) {
    return showDialog<int>(
      context: context,
      builder: (context) =>
          GoToPageDialog(currentPage: currentPage, totalPages: totalPages),
    );
  }

  @override
  State<GoToPageDialog> createState() => _GoToPageDialogState();
}

class _GoToPageDialogState extends State<GoToPageDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.currentPage}');
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onGo() {
    final text = _controller.text.trim();
    final page = int.tryParse(text);

    if (page == null) {
      setState(() => _errorText = 'Please enter a valid page number.');
      return;
    }

    if (page < 1 || page > widget.totalPages) {
      setState(
        () => _errorText = 'Enter a page between 1 and ${widget.totalPages}.',
      );
      return;
    }

    Navigator.of(context).pop(page);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedXl),
      title: Text(
        'Go to page',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter a page number (1–${widget.totalPages})',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Page number',
              errorText: _errorText,
              errorMaxLines: 2,
            ),
            onSubmitted: (_) => _onGo(),
            onChanged: (_) {
              if (_errorText != null) {
                setState(() => _errorText = null);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
        TextButton(
          onPressed: _onGo,
          child: Text(
            'Go',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
