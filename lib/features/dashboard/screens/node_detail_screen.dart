import 'package:ekonum_app/core/providers/dashboard_provider.dart';
import 'package:ekonum_app/core/providers/devices_provider.dart';
import 'package:ekonum_app/features/common/widgets/resource_usage_bar.dart';
import 'package:ekonum_app/features/common/widgets/section_title.dart';
import 'package:ekonum_app/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NodeDetailScreen extends StatelessWidget {
  final String nodeId;
  final String nodeName;

  const NodeDetailScreen({
    super.key,
    required this.nodeId,
    required this.nodeName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Get node details from DashboardProvider
    final node = context.select((DashboardProvider p) => p.getNodeById(nodeId));
    // Get apps running on this node from DevicesProvider
    final runningApps = context.select(
      (DevicesProvider p) => p.getAppsRunningOnNode(nodeId),
    );

    if (node == null) {
      // Handle case where node is not found (e.g., navigated with invalid ID)
      return Scaffold(
        appBar: AppBar(title: Text(nodeName)), // Show passed name initially
        body: const Center(child: Text('Node not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(node.name), // Use the actual node name from provider
        actions: [
          Tooltip(
            message: 'Node Information',
            child: IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text(node.name),
                        content: SingleChildScrollView(
                          // Make content scrollable
                          child: ListBody(
                            children: <Widget>[
                              Text('ID: $nodeId'), // Show the ID
                              const SizedBox(height: 8),
                              Text(
                                'Current CPU Usage: ${Formatters.percentage(node.cpuUsage)}',
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Current RAM Usage: ${Formatters.percentage(node.ramUsage)}',
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Applications Running: ${runningApps.length}',
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                );
              },
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          // Node Overview Card (similar to Cluster Overview but for one node)
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Resource Usage', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 16),
                  ResourceUsageBar(
                    label: 'CPU Usage',
                    value: node.cpuUsage,
                    valueText: Formatters.percentage(node.cpuUsage),
                  ),
                  const SizedBox(height: 12),
                  ResourceUsageBar(
                    label: 'RAM Usage',
                    value: node.ramUsage,
                    valueText: Formatters.percentage(node.ramUsage),
                  ),
                ],
              ),
            ),
          ),

          // Applications running on this device
          SectionTitle(title: 'Applications Running on ${node.name}'),
          if (runningApps.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Center(
                child: Text(
                  'No applications are currently running on this node.',
                ),
              ),
            )
          else
            ...runningApps.map(
              (appInfo) => _buildAppListItem(context, appInfo),
            ),
        ],
      ),
    );
  }

  Widget _buildAppListItem(BuildContext context, AppBasicInfo appInfo) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.layers_outlined, color: theme.primaryColor, size: 24),
            // App/Replica icon
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appInfo.name, style: theme.textTheme.titleSmall),
                  Text(appInfo.replicaId, style: theme.textTheme.bodySmall),
                  // Show which copy
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ResourceUsageBar(
                          label: 'CPU',
                          value: appInfo.cpuUsage,
                          // Assuming usage is 0-1 scale per replica
                          valueText: Formatters.percentage(appInfo.cpuUsage),
                          color:
                              Colors
                                  .orange
                                  .shade700, // Different color for app usage?
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ResourceUsageBar(
                          label: 'RAM',
                          value: appInfo.ramUsage,
                          valueText: Formatters.percentage(appInfo.ramUsage),
                          color:
                              Colors
                                  .teal
                                  .shade600, // Different color for app usage?
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Add actions? e.g., Stop replica, view app details?
            // IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
          ],
        ),
      ),
    );
  }
}
