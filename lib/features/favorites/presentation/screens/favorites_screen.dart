import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_section_header.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

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
                title: 'Favorites',
                subtitle: 'Your starred books, papers, and documents.',
                showBottomBorder: true,
              ),
              SizedBox(height: AppSpacing.xl),
              Expanded(
                child: AppEmptyState(
                  icon: Icons.star_outline_rounded,
                  title: 'No favorites yet',
                  description: 'Tap the star icon on any document in your library to keep it pinned here.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
