import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_page.dart';

class FoldersScreen extends StatelessWidget {
  const FoldersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Folders',
      description: 'Organize your PDFs into custom categories, series, and study folders.',
      icon: Icons.folder_rounded,
    );
  }
}
