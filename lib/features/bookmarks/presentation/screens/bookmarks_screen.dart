import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_page.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Bookmarks',
      description: 'Your saved pages, reading markers, and highlights across all documents.',
      icon: Icons.bookmark_rounded,
    );
  }
}
