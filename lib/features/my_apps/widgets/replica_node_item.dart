import 'package:ekonum_app/config/colors.dart';
import 'package:ekonum_app/core/models/replica_info.dart';
import 'package:ekonum_app/features/common/widgets/resource_usage_bar.dart';
import 'package:ekonum_app/utils/formatters.dart';
import 'package:flutter/material.dart';

class ReplicaNodeItem extends StatelessWidget {
  final ReplicaInfo replicaInfo;
  final VoidCallback? onRemove; // Make remove optional

  const ReplicaNodeItem({super.key, required this.replicaInfo, this.onRemove});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.dns_outlined, color: theme.primaryColor, size: 20),
                // Node icon
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        replicaInfo.nodeName,
                        style: theme.textTheme.titleSmall,
                      ), // Node name
                      Text(
                        replicaInfo.replicaId,
                        style: theme.textTheme.bodySmall,
                      ), // e.g., "Copy 1"
                    ],
                  ),
                ),
                if (onRemove != null)
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: AppColors.error,
                    ),
                    tooltip: 'Remove this copy',
                    onPressed: onRemove,
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(), // Remove extra padding
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ResourceUsageBar(
                    label: 'CPU',
                    value: replicaInfo.cpuUsage,
                    valueText: Formatters.percentage(replicaInfo.cpuUsage),
                    color: Colors.orange.shade700,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ResourceUsageBar(
                    label: 'RAM',
                    value: replicaInfo.ramUsage,
                    valueText: Formatters.percentage(replicaInfo.ramUsage),
                    color: Colors.teal.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
