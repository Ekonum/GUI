import 'package:ekonum_app/core/providers/storage_provider.dart';
import 'package:ekonum_app/features/common/widgets/info_banner.dart';
import 'package:ekonum_app/features/storage/widgets/backup_status_card.dart';
import 'package:ekonum_app/features/storage/widgets/peer_selection_card.dart';
import 'package:ekonum_app/features/storage/widgets/storage_plan_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StorageScreen extends StatelessWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use watch only if UI elements directly depend on frequent provider changes.
    // For things like callbacks (onCopiesChanged), use context.read inside the callback.
    final storageProvider = context.watch<StorageProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peer Storage'),
        actions: [
          Tooltip(
            // Added Tooltip
            message: 'Storage & Backup Help',
            child: IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('About Peer Storage'),
                        content: const SingleChildScrollView(
                          child: Text(
                            'Ekonum uses peer-to-peer technology for backups.\n\n'
                            'Your encrypted data can be stored across multiple devices (peers) for safety. To participate, you also dedicate some of your storage to help store others\' encrypted data.\n\n'
                            '- Backup Copies: Choose how many redundant copies of your data you want stored on peers.\n'
                            '- Storage Allocation: Shows how much storage you use vs. how much you share based on your chosen copy count.\n'
                            '- Backup Status: Monitor your latest backup and selected peers.\n'
                            '- Choose Peers: Select specific peers or let Ekonum choose the best ones automatically (Smart Selection).',
                          ),
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
        onRefresh: () => context.read<StorageProvider>().fetchStorageData(),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            // Explanation Banner
            const Padding(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              // Adjust padding
              child: InfoBanner(
                icon: Icons.info_outline,
                title: 'How Peer Storage Works',
                message:
                    'Your data is securely backed up to other users\' devices, and you help store their data too. The more backup copies you want, the more storage you share with others.',
              ),
            ),

            // Storage Plan Card - Pass data and callback
            StoragePlanCard(
              // Use data directly from provider
              storagePlan: storageProvider.storagePlan,
              maxCopies: 3, // Example maximum
              // Use context.read inside the callback
              onCopiesChanged: (newCopies) {
                if (newCopies != null) {
                  context.read<StorageProvider>().updateSelectedCopies(
                    newCopies,
                  );
                }
              },
            ),

            // Current Backup Status Card
            const BackupStatusCard(),
            // New Widget

            // Choose Peers Card - Uses provider internally or gets data passed
            const PeerSelectionCard(),

            // Ensure this widget uses provider internally
            const SizedBox(height: 60),
            // Bottom padding
          ],
        ),
      ),
    );
  }
}
