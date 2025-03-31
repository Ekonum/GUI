import 'package:ekonum_app/config/colors.dart';
import 'package:ekonum_app/core/models/peer_model.dart';
import 'package:ekonum_app/core/providers/storage_provider.dart';
import 'package:ekonum_app/features/common/widgets/search_field.dart';
import 'package:ekonum_app/features/storage/widgets/peer_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PeerSelectionCard extends StatefulWidget {
  const PeerSelectionCard({super.key});

  @override
  State<PeerSelectionCard> createState() => _PeerSelectionCardState();
}

class _PeerSelectionCardState extends State<PeerSelectionCard> {
  // Search controller is local UI state
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize search controller if provider has an initial query
    _searchController.text = context.read<StorageProvider>().peerSearchQuery;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Watch the provider for changes in mode, peers, and query
    final storageProvider = context.watch<StorageProvider>();
    final selectionMode = storageProvider.peerSelectionMode;
    final filteredPeers =
        storageProvider.availablePeers; // Provider handles filtering

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Your Backup Peers',
              style: theme.textTheme.titleMedium,
            ),
            Text(
              'Select who will store your data',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),

            SegmentedButton<PeerSelectionMode>(
              segments: const <ButtonSegment<PeerSelectionMode>>[
                ButtonSegment(
                  value: PeerSelectionMode.specific,
                  label: Text('Choose Specific Peers'),
                ),
                ButtonSegment(
                  value: PeerSelectionMode.smart,
                  label: Text('Smart Selection'),
                ),
              ],
              selected: <PeerSelectionMode>{selectionMode},
              // Use context.read inside the callback
              onSelectionChanged: (newSelection) {
                context.read<StorageProvider>().setPeerSelectionMode(
                  newSelection.first,
                );
              },
              showSelectedIcon: false,
              style: theme.segmentedButtonTheme.style,
            ),
            const SizedBox(height: 16),

            // Content based on selection mode
            if (selectionMode == PeerSelectionMode.specific)
              _buildSpecificPeerSelection(context, theme, filteredPeers)
            else
              _buildSmartSelectionInfo(theme), // Smart selection explanation
          ],
        ),
      ),
    );
  }

  Widget _buildSpecificPeerSelection(
    BuildContext context,
    ThemeData theme,
    List<Peer> peers,
  ) {
    // Access provider via context.read for actions
    final storageProvider = context.read<StorageProvider>();

    return Column(
      children: [
        SearchField(
          controller: _searchController,
          hintText: 'Search peers by name or ID...',
          // Update provider's search query on change
          onChanged: (value) => storageProvider.searchPeers(value),
        ),
        const SizedBox(height: 12),
        // List of Peers - Use a constrained height container for scrollability
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300), // Limit height
          child:
              peers.isEmpty
                  ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(
                      child: Text(
                        storageProvider.peerSearchQuery.isEmpty
                            ? 'No available peers found.'
                            : 'No peers found matching "${storageProvider.peerSearchQuery}".',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                  : ListView.builder(
                    shrinkWrap: true,
                    itemCount: peers.length,
                    itemBuilder: (context, index) {
                      final peer = peers[index];
                      return PeerListItem(
                        name: peer.name,
                        syncStatus: peer.lastSync,
                        storageUsedPercent: peer.storageUsedPercent,
                        isAdded: peer.isSelected,
                        // Use isSelected from model
                        // Call provider method on toggle
                        onAddToggle:
                            () => storageProvider.togglePeerSelection(peer.id),
                      );
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildSmartSelectionInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, color: theme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'With Smart Selection, Ekonum automatically chooses the best peers for optimal performance and reliability based on latency and availability.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.primaryColor.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
