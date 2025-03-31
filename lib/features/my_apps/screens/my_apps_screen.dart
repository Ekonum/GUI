import 'package:ekonum_app/config/colors.dart';
import 'package:ekonum_app/core/providers/app_provider.dart';
import 'package:ekonum_app/features/common/widgets/info_banner.dart';
import 'package:ekonum_app/features/my_apps/screens/app_detail_screen.dart';
import 'package:ekonum_app/features/my_apps/widgets/app_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppsScreen extends StatelessWidget {
  const MyAppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final installedApps = appProvider.installedApps;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Applications'),
        actions: [
          Tooltip(
            message: 'About Applications',
            child: IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('How Applications Work'),
                        content: const Text(
                          'Each application can have multiple copies (replicas) running across different devices (nodes) in your network.\n\nMore replicas mean better reliability and performance, but use more resources.',
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
        onRefresh: () => context.read<AppProvider>().fetchInstalledApps(),
        child: ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          children: [
            // Optional: Info Banner
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: InfoBanner(
                icon: Icons.info_outline,
                title: 'How Applications Work in Your Cloud',
                message:
                    'Each application can have multiple copies (replicas) running across different devices (nodes) in your network. More replicas mean better reliability and performance, but use more resources.',
              ),
            ),

            // List of installed applications
            if (installedApps.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 48.0),
                child: Center(
                  child: Text(
                    'You have no applications installed.\nVisit the Store to add some!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              )
            else
              ...installedApps.map(
                (app) => AppListItem(
                  application: app,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => AppDetailScreen(applicationId: app.id),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
