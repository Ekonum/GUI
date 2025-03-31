import 'package:ekonum_app/features/common/widgets/resource_usage_bar.dart';
import 'package:ekonum_app/utils/formatters.dart';
import 'package:flutter/material.dart';

class ClusterOverviewCard extends StatelessWidget {
  final double cpuUsage; // 0.0 to 1.0
  final double ramUsage; // 0.0 to 1.0
  final int totalAppsRunning;

  const ClusterOverviewCard({
    super.key,
    required this.cpuUsage,
    required this.ramUsage,
    required this.totalAppsRunning,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      // elevation: 1, // Slightly more prominent if needed
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cluster Overview', style: theme.textTheme.titleMedium),
            Text(
              'Total resource usage across all nodes',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16.0),
            ResourceUsageBar(
              label: 'CPU Usage',
              value: cpuUsage,
              valueText: Formatters.percentage(cpuUsage),
            ),
            const SizedBox(height: 12.0),
            ResourceUsageBar(
              label: 'RAM Usage',
              value: ramUsage,
              valueText: Formatters.percentage(ramUsage),
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Apps Running', style: theme.textTheme.bodyMedium),
                Text(
                  totalAppsRunning.toString(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.primaryColor,
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
