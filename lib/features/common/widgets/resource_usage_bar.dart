import 'package:flutter/material.dart';

class ResourceUsageBar extends StatelessWidget {
  final String label;
  final double value; // 0.0 to 1.0
  final String valueText; // e.g., "65%
  final Color? color;

  const ResourceUsageBar({
    super.key,
    required this.label,
    required this.value,
    required this.valueText,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final barColor = color ?? theme.colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              valueText,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          backgroundColor: barColor.withValues(alpha: 0.15),
          valueColor: AlwaysStoppedAnimation<Color>(barColor),
          borderRadius: BorderRadius.circular(4),
          // Rounded corners for the bar
          minHeight: 6, // Make the bar slightly thicker
        ),
      ],
    );
  }
}
