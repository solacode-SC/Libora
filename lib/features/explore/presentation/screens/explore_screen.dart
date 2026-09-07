import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_page.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'Explore',
      description: 'Explore and preview PDFs available in connected GitHub repositories without downloading everything.',
      icon: Icons.explore_rounded,
      actions: [
        OutlinedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Repository exploration will be implemented in Phase 5',
                ),
              ),
            );
          },
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Sync Repositories'),
        ),
      ],
    );
  }
}
