import 'package:ekonum_app/config/colors.dart';
import 'package:ekonum_app/core/providers/app_provider.dart';
import 'package:ekonum_app/features/common/widgets/resource_usage_bar.dart';
import 'package:ekonum_app/features/my_apps/widgets/replica_node_item.dart';
import 'package:ekonum_app/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDetailScreen extends StatelessWidget {
  final String applicationId;

  const AppDetailScreen({super.key, required this.applicationId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Watch the specific app from the provider
    final app = context.select((AppProvider p) => p.getAppById(applicationId));
    // Read the provider for actions
    final appProvider = context.read<AppProvider>();

    if (app == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('App Details')),
        body: const Center(child: Text('Application not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(app.name),
        actions: [
          Tooltip(
            message: 'Application Information',
            child: IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text(app.name),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text('Version: ${app.version}'),
                              const SizedBox(height: 8),
                              Text(
                                'Total CPU Usage: ${Formatters.percentage(app.totalCpuUsage)}',
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Total RAM Usage: ${Formatters.percentage(app.totalRamUsage)}',
                              ),
                              const SizedBox(height: 8),
                              Text('Running Replicas: ${app.replicas.length}'),
                              const SizedBox(height: 16),
                              Text(app.description), // Show description
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
          // Overview Card
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(app.name, style: theme.textTheme.headlineSmall),
                          // App Name
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Chip(label: Text('Version ${app.version}')),
                              const SizedBox(width: 8),
                              Chip(
                                label: Text(
                                  '${app.replicas.length} Cop${app.replicas.length == 1 ? 'y' : 'ies'}',
                                ),
                                avatar: Icon(
                                  Icons.copy_all_outlined,
                                  size: 16,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Total Resource Usage Across All Replicas',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ResourceUsageBar(
                          label: 'Total CPU Usage',
                          value: app.totalCpuUsage,
                          valueText: Formatters.percentage(app.totalCpuUsage),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ResourceUsageBar(
                          label: 'Total RAM Usage',
                          value: app.totalRamUsage,
                          valueText: Formatters.percentage(app.totalRamUsage),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Replicas Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Where This App Is Running',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(width: 8),
                    Tooltip(
                      message:
                          'Each copy (replica) runs on a different device (node) for reliability.',
                      child: Icon(
                        Icons.help_outline,
                        size: 18,
                        color: AppColors.textDisabled,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  // TODO: Add logic to check if adding replica is possible
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Adding another copy of ${app.name}...'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    await appProvider.addReplica(app.id);
                    ScaffoldMessenger.of(
                      context,
                    ).hideCurrentSnackBar(); // Hide previous snackbar if still visible
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added copy of ${app.name}.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  label: const Text('Add Copy'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (app.replicas.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Center(
                child: Text('This application has no running replicas.'),
              ),
            )
          else
            ...app.replicas.map(
              (replica) => ReplicaNodeItem(
                replicaInfo: replica,
                onRemove:
                    app.replicas.length <= 1
                        ? null
                        : () async {
                          // Disable remove if only one replica
                          // Confirmation Dialog
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text('Remove ${replica.replicaId}?'),
                                  content: Text(
                                    'Are you sure you want to remove this copy of ${app.name} running on ${replica.nodeName}?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.error,
                                      ),
                                      child: const Text('Remove'),
                                    ),
                                  ],
                                ),
                          );
                          if (confirm == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Removing ${replica.replicaId}...',
                                ),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            await appProvider.removeReplica(
                              app.id,
                              replica.replicaId,
                            );
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Removed ${replica.replicaId}.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
              ),
            ),
        ],
      ),
    );
  }
}
