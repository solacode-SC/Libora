import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_page.dart';

class GitHubScreen extends StatelessWidget {
  const GitHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'GitHub Repositories',
      description: 'Connect GitHub repositories to explore, preview, and selectively download documents.',
      icon: Icons.hub_rounded,
      actions: [
        FilledButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'GitHub repository connection will be implemented in Phase 4',
                ),
              ),
            );
          },
          icon: const Icon(Icons.link, size: 18),
          label: const Text('Connect Repository'),
        ),
      ],
    );
  }
}
