import 'package:ekonum_app/config/colors.dart';
import 'package:ekonum_app/core/models/storage_plan.dart';
import 'package:ekonum_app/utils/formatters.dart';
import 'package:flutter/material.dart';

enum StorageShareMode { forPeers, forYou }

class StoragePlanCard extends StatefulWidget {
  final StoragePlan storagePlan; // Pass the whole model
  final int maxCopies;
  final ValueChanged<int?> onCopiesChanged;

  const StoragePlanCard({
    super.key,
    required this.storagePlan,
    required this.maxCopies,
    required this.onCopiesChanged,
  });

  @override
  State<StoragePlanCard> createState() => _StoragePlanCardState();
}

class _StoragePlanCardState extends State<StoragePlanCard> {
  // Local state for the segmented button view only
  StorageShareMode _selectedMode = StorageShareMode.forPeers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final plan = widget.storagePlan; // Use the passed model

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Storage Plan', style: theme.textTheme.titleMedium),
            Text(
              'Choose how many backup copies you want',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),

            // Backup Copies Dropdown
            Row(
              children: [
                Icon(Icons.shield_outlined, color: theme.primaryColor),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Backup Copies',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'More copies = better protection',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Dropdown styling improvement
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: plan.backupCopies,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.textSecondary,
                      ),
                      elevation: 2,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.primaryColor,
                      ),
                      // Use the callback directly
                      onChanged: widget.onCopiesChanged,
                      items: List<DropdownMenuItem<int>>.generate(
                        widget.maxCopies + 1, // Include 0 copies
                        (index) => DropdownMenuItem<int>(
                          value: index,
                          child: Text('$index Cop${index == 1 ? 'y' : 'ies'}'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Storage Allocation Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Storage Allocation', style: theme.textTheme.titleSmall),
                Text(
                  '${Formatters.percentage(plan.allocationPercent)} shared with peers',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Segmented Button for View
            SegmentedButton<StorageShareMode>(
              segments: const <ButtonSegment<StorageShareMode>>[
                ButtonSegment<StorageShareMode>(
                  value: StorageShareMode.forPeers,
                  label: Text('For peers'),
                ),
                ButtonSegment<StorageShareMode>(
                  value: StorageShareMode.forYou,
                  label: Text('For you'),
                ),
              ],
              selected: <StorageShareMode>{_selectedMode},
              onSelectionChanged: (Set<StorageShareMode> newSelection) {
                setState(() {
                  _selectedMode = newSelection.first;
                });
              },
              showSelectedIcon: false,
              style: theme.segmentedButtonTheme.style,
            ),
            const SizedBox(height: 16),

            // Display Allocation based on selected mode
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Your Usable Storage',
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Formatters.storage(plan.usableStorageGB),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: AppColors.border,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Dedicated to Peers',
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Formatters.storage(plan.dedicatedToPeersGB),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            // Feature List
            _buildFeatureItem(
              context,
              Icons.lock_outline,
              'Your data is encrypted before being stored on peers\' devices',
            ),
            _buildFeatureItem(
              context,
              Icons.sync,
              'Backups sync automatically every few minutes',
            ),
            _buildFeatureItem(
              context,
              Icons.cloud_off_outlined,
              'Your data remains available even if your device is offline',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.success, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
