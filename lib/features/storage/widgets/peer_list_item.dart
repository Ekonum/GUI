import 'package:ekonum_app/config/colors.dart';
import 'package:ekonum_app/utils/formatters.dart';
import 'package:flutter/material.dart';

class PeerListItem extends StatelessWidget {
  final String name;
  final String syncStatus;
  final double storageUsedPercent;
  final bool isAdded; // Indicates if the 'Add' button should show 'Remove'
  final VoidCallback onAddToggle;

  const PeerListItem({
    super.key,
    required this.name,
    required this.syncStatus,
    required this.storageUsedPercent,
    required this.isAdded,
    required this.onAddToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      // Add padding between items
      child: Row(
        children: [
          // Status indicator (e.g., green dot for recently synced)
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              // Crude logic: Green if synced recently, gray otherwise
              color:
                  syncStatus.contains('minute')
                      ? AppColors.success
                      : AppColors.textDisabled,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: theme.textTheme.titleSmall),
                Row(
                  children: [
                    Icon(Icons.sync, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      'Synced $syncStatus',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.pie_chart_outline,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${Formatters.percentage(storageUsedPercent)} used',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          OutlinedButton.icon(
            icon: Icon(
              isAdded
                  ? Icons.person_remove_outlined
                  : Icons.person_add_alt_1_outlined,
              size: 18,
            ),
            label: Text(isAdded ? 'Remove' : 'Add'),
            onPressed: onAddToggle,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              foregroundColor: isAdded ? AppColors.error : AppColors.primary,
              side: BorderSide(
                color:
                    isAdded
                        ? AppColors.error.withValues(alpha: 0.5)
                        : AppColors.primary.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
