import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_page.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'My Library',
      description: 'PDFs downloaded or imported locally on this device.',
      icon: Icons.local_library_rounded,
      actions: [
        FilledButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Local PDF importing will be implemented in Phase 1',
                ),
              ),
            );
          },
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Import PDF'),
        ),
      ],
    );
  }
}
