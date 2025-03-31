import 'package:ekonum_app/config/colors.dart';
import 'package:ekonum_app/core/providers/devices_provider.dart';
import 'package:ekonum_app/features/common/widgets/info_banner.dart';
import 'package:ekonum_app/features/common/widgets/section_title.dart';
import 'package:ekonum_app/features/devices/widgets/device_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final devicesProvider = context.watch<DevicesProvider>();
    final nodes = devicesProvider.nodes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nodes & Applications'),
        actions: [
          Tooltip(
            message: 'About Nodes & Replicas',
            child: IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('What are Nodes and Replicas?'),
                        content: const Text(
                          'Your cloud is made up of physical devices called Nodes.\n\nApplications run as Replicas on these nodes. Having multiple replicas of the same app on different nodes ensures your services stay available even if one device goes offline.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                );
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        // Added RefreshIndicator
        onRefresh: () async {
          await context.read<DevicesProvider>().fetchDeviceAndAppData(
            context.read(), // Pass DashboardProvider
            context.read(), // Pass AppProvider
          );
        },
        child: ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          children: [
            // Optional: Info Banner
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: InfoBanner(
                icon: Icons.info_outline,
                title: 'What are Nodes and Replicas?',
                message:
                    'Your cloud is made up of physical devices called Nodes. Applications run as Replicas on these nodes. Having multiple replicas of the same app on different nodes ensures your services stay available even if one device goes offline.',
              ),
            ),

            SectionTitle(title: 'Your Nodes (${nodes.length})'),

            if (devicesProvider.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (devicesProvider.error != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Error: ${devicesProvider.error}',
                    style: const TextStyle(color: AppColors.error),
                  ),
                ),
              )
            else if (nodes.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 48.0),
                child: Center(
                  child: Text('No active nodes found in your cluster.'),
                ),
              )
            else
              ...nodes.map((node) {
                final runningApps = devicesProvider.getAppsRunningOnNode(
                  node.id,
                );
                return DeviceListItem(node: node, runningApps: runningApps);
              }),
          ],
        ),
      ),
    );
  }
}
