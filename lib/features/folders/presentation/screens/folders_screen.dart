import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_section_header.dart';

class FoldersScreen extends StatelessWidget {
  const FoldersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSectionHeader(
                eyebrow: 'COLLECTIONS',
                title: 'Folders',
                subtitle: 'Group your PDFs into reading lists, study topics, and series.',
                trailing: AppButton.primary(
                  label: 'New Folder',
                  icon: Icons.create_new_folder_outlined,
                  size: AppButtonSize.small,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Folder creation will be implemented in Phase 3',
                        ),
                      ),
                    );
                  },
                ),
                showBottomBorder: true,
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: AppEmptyState(
                  icon: Icons.folder_outlined,
                  title: 'No folders yet',
                  description: 'Create custom folders to organize series, volumes, and thematic book collections.',
                  actionLabel: 'Create Folder',
                  actionIcon: Icons.add_rounded,
                  onAction: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Folder creation will be implemented in Phase 3',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
