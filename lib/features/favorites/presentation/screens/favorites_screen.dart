import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_page.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Favorites',
      description:
          'Quickly access your starred and favorite reading materials.',
      icon: Icons.star_rounded,
    );
  }
}
