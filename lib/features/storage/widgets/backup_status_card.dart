import 'package:ekonum_app/config/colors.dart';
import 'package:ekonum_app/core/providers/storage_provider.dart';
import 'package:ekonum_app/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BackupStatusCard extends StatelessWidget {
  const BackupStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final storageProvider = context.watch<StorageProvider>();
    final selectedPeers = storageProvider.selectedPeers;
    final lastBackup = storageProvider.lastBackupTime;
    final isSyncing = storageProvider.isSyncing;

    String lastBackupText;
    if (lastBackup != null) {
      // Calculate difference for relative time (e.g., "5 minutes ago")
      final difference = DateTime.now().difference(lastBackup);
      if (difference.inSeconds < 60) {
        lastBackupText = 'few seconds ago';
      } else if (difference.inMinutes < 60) {
        lastBackupText =
            '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
      } else if (difference.inHours < 24) {
        lastBackupText =
            '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
      } else {
        lastBackupText = DateFormat.yMd().add_jm().format(
          lastBackup,
        ); // e.g., 10/26/2023, 5:30 PM
      }
    } else {
      lastBackupText = 'Never';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Backup Status', style: theme.textTheme.titleMedium),
            Text(
              'Your data is backed up to these peers',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),

            // Last Backup Status
            Row(
              children: [
                Icon(Icons.refresh, color: theme.primaryColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Last backup: $lastBackupText',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                OutlinedButton.icon(
                  icon:
                      isSyncing
                          ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.sync, size: 18),
                  label: const Text('Sync Now'),
                  onPressed:
                      isSyncing
                          ? null
                          : () {
                            context.read<StorageProvider>().syncNow();
                          },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide(
                      color: theme.primaryColor.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Backup Completion Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Backup Completion',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  Formatters.percentage(storageProvider.backupCompletion),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: storageProvider.backupCompletion,
              backgroundColor: theme.colorScheme.primary.withValues(
                alpha: 0.15,
              ),
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(4),
              minHeight: 6,
            ),
            const SizedBox(height: 16),

            // Your Backup Peers List (Read-only view)
            Text('Your Backup Peers', style: theme.textTheme.titleSmall),
            const Divider(height: 16),

            if (selectedPeers.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  storageProvider.peerSelectionMode == PeerSelectionMode.smart
                      ? 'Peers are managed by Smart Selection.'
                      : 'No peers selected.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            else
              // Limit the height if too many peers are selected
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 150),
                // Adjust as needed
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: selectedPeers.length,
                  itemBuilder: (context, index) {
                    final peer = selectedPeers[index];
                    // Display minimal peer info - maybe just name and a status icon?
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 18,
                            color: theme.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              peer.name,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          // Optionally show last sync for this specific peer if available
                          // Text(peer.lastSync, style: theme.textTheme.bodySmall),
                          // Add a copy button like in the design?
                          TextButton(
                            onPressed: () {
                              // Copy peer ID or some info?
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Copied info for ${peer.name} (mock)',
                                  ),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              visualDensity: VisualDensity.compact,
                              textStyle: const TextStyle(fontSize: 12),
                              foregroundColor: AppColors.textSecondary,
                              side: const BorderSide(color: AppColors.border),
                            ),
                            child: Text(
                              'Copy ${index + 1}',
                            ), // Show which copy it represents roughly
                          ),
                        ],
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
