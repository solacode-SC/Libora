import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_section_header.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSectionHeader(
                eyebrow: 'COLLECTIONS',
                title: 'Bookmarks',
                subtitle: 'Saved page markers, quotes, and reading references.',
                showBottomBorder: true,
              ),
              SizedBox(height: AppSpacing.xl),
              Expanded(
                child: AppEmptyState(
                  icon: Icons.bookmark_outline_rounded,
                  title: 'No bookmarks yet',
                  description: 'Pages you bookmark while reading documents will be preserved here.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
