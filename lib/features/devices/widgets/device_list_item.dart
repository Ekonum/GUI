import 'package:ekonum_app/config/colors.dart';
import 'package:ekonum_app/core/models/node_model.dart';
import 'package:ekonum_app/core/providers/devices_provider.dart';
import 'package:ekonum_app/features/common/widgets/resource_usage_bar.dart';
import 'package:ekonum_app/utils/formatters.dart';
import 'package:flutter/material.dart';

class DeviceListItem extends StatelessWidget {
  final Node node;
  final List<AppBasicInfo> runningApps;

  const DeviceListItem({
    super.key,
    required this.node,
    required this.runningApps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appCount = runningApps.length;

    return Card(
      child: ExpansionTile(
        // Maintain padding consistency
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        // Remove default expansion arrow, we use the row layout
        trailing: const SizedBox.shrink(),
        shape: const Border(),
        // Remove internal border of ExpansionTile when expanded
        title: Row(
          children: [
            Icon(Icons.dns, color: theme.primaryColor, size: 32),
            // Node icon
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(node.name, style: theme.textTheme.titleMedium),
                  Text(
                    '$appCount App${appCount == 1 ? '' : 's'} Running',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Chip(
              label: Text(
                '${node.appsRunningCount} App${node.appsRunningCount == 1 ? '' : 's'}',
              ),
              labelStyle: theme.chipTheme.labelStyle?.copyWith(fontSize: 11),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              visualDensity: VisualDensity.compact,
              backgroundColor: theme.chipTheme.backgroundColor,
            ),
            const Icon(Icons.expand_more, color: AppColors.textDisabled),
            // Explicit indicator
          ],
        ),
        // Content visible when expanded
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 16),
                Text('Node Resource Usage', style: theme.textTheme.titleSmall),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ResourceUsageBar(
                        label: 'CPU',
                        value: node.cpuUsage,
                        valueText: Formatters.percentage(node.cpuUsage),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ResourceUsageBar(
                        label: 'RAM',
                        value: node.ramUsage,
                        valueText: Formatters.percentage(node.ramUsage),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Applications Running on this Device',
                  style: theme.textTheme.titleSmall,
                ),
                const Divider(height: 16),
                if (runningApps.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'No applications running.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                else
                  ...runningApps.map(
                    (appInfo) => _buildAppRow(context, appInfo),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppRow(BuildContext context, AppBasicInfo appInfo) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.layers_outlined, size: 18, color: theme.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appInfo.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(appInfo.replicaId, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            // Constrain width of usage bars
            width: 100, // Adjust width as needed
            child: Column(
              children: [
                ResourceUsageBar(
                  label: 'CPU',
                  value: appInfo.cpuUsage,
                  valueText: Formatters.percentage(appInfo.cpuUsage),
                  color: Colors.orange.shade700,
                ),
                const SizedBox(height: 4),
                ResourceUsageBar(
                  label: 'RAM',
                  value: appInfo.ramUsage,
                  valueText: Formatters.percentage(appInfo.ramUsage),
                  color: Colors.teal.shade600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
