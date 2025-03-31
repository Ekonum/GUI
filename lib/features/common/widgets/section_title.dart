import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final EdgeInsets padding;

  const SectionTitle({
    super.key,
    required this.title,
    this.padding = const EdgeInsets.fromLTRB(
      16.0,
      20.0,
      16.0,
      8.0,
    ), // Default padding
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
