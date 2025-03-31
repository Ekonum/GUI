import 'package:ekonum_app/core/providers/dashboard_provider.dart';
import 'package:ekonum_app/features/common/widgets/ekonum_logo.dart';
import 'package:ekonum_app/features/common/widgets/section_title.dart';
import 'package:ekonum_app/features/dashboard/screens/node_detail_screen.dart'; // Import detail screen
import 'package:ekonum_app/features/dashboard/widgets/cluster_overview_card.dart';
import 'package:ekonum_app/features/dashboard/widgets/node_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the provider for changes
    final dashboardProvider = context.watch<DashboardProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const EkonumLogo(height: 28), // Logo in AppBar
        actions: [
          Tooltip(
            // Added Tooltip
            message: 'Dashboard Help',
            child: IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () {
                // Show help dialog or navigate to help page
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Dashboard Overview'),
                        content: const Text(
                          'This screen shows the overall health of your cluster and lists your active nodes.\n\nTap a node to see more details and the applications running on it.',
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
        onRefresh: () => context.read<DashboardProvider>().fetchDashboardData(),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 16.0), // Padding at the bottom
          children: [
            // Cluster Overview Card - Uses data from provider
            ClusterOverviewCard(
              cpuUsage: dashboardProvider.clusterCpuUsage,
              ramUsage: dashboardProvider.clusterRamUsage,
              totalAppsRunning: dashboardProvider.totalAppsRunning,
            ),

            // Nodes Section
            const SectionTitle(title: 'Nodes'),
            if (dashboardProvider.nodes.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Center(
                  child: Text('No nodes found.'),
                ), // Handle empty state
              )
            else
              ...dashboardProvider.nodes.map(
                (node) => NodeListItem(
                  // Use map with spread operator
                  nodeName: node.name,
                  cpuUsage: node.cpuUsage,
                  ramUsage: node.ramUsage,
                  appsRunningCount: node.appsRunningCount,
                  onTap: () {
                    // Navigate to Node Detail Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => NodeDetailScreen(
                              nodeId: node.id,
                              nodeName: node.name,
                            ), // Pass data
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 60), // Extra space if FAB is ever added
          ],
        ),
      ),
    );
  }
}
