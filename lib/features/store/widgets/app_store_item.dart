import 'package:ekonum_app/config/colors.dart';
import 'package:ekonum_app/core/providers/store_provider.dart'; // Import StoreApp model
import 'package:flutter/material.dart';

class AppStoreItem extends StatelessWidget {
  final StoreApp storeApp; // Receive the full StoreApp object
  final VoidCallback onInstall;
  final VoidCallback onUninstall;
  final VoidCallback onTap;

  const AppStoreItem({
    super.key,
    required this.storeApp,
    required this.onInstall,
    required this.onUninstall,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isInstalled = storeApp.isInstalled;
    final bool isProcessing = storeApp.isProcessing;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.extension_outlined,
                color: theme.primaryColor,
                size: 32,
              ), // Generic app icon
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(storeApp.name, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      storeApp.description,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Show resource requirements using Chips
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: [
                        Chip(
                          label: Text('CPU: ${storeApp.cpuRequirement}'),
                          labelStyle: theme.chipTheme.labelStyle?.copyWith(
                            fontSize: 11,
                          ),
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 0,
                          ),
                          backgroundColor: AppColors.background,
                          // Use lighter background
                          avatar: Icon(
                            Icons.memory,
                            size: 14,
                            color: theme.primaryColor.withValues(alpha: 0.7),
                          ),
                        ),
                        Chip(
                          label: Text('RAM: ${storeApp.ramRequirement}'),
                          labelStyle: theme.chipTheme.labelStyle?.copyWith(
                            fontSize: 11,
                          ),
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 0,
                          ),
                          backgroundColor: AppColors.background,
                          // Use lighter background
                          avatar: Icon(
                            Icons.sd_storage_outlined,
                            size: 14,
                            color: theme.primaryColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Install/Uninstall Button
              ElevatedButton(
                onPressed:
                    isProcessing
                        ? null
                        : (isInstalled ? onUninstall : onInstall),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  backgroundColor:
                      isInstalled
                          ? AppColors.textSecondary
                          : AppColors.primary, // Gray if installed, blue if not
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ).copyWith(
                  // Overlay color for visual feedback on press
                  overlayColor: WidgetStateProperty.resolveWith((states) {
                    return states.contains(WidgetState.pressed)
                        ? (isInstalled
                            ? AppColors.textDisabled
                            : AppColors.primary.withValues(alpha: 0.8))
                        : null;
                  }),
                ),
                child:
                    isProcessing
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : Text(
                          isInstalled ? 'Installed' : 'Install',
                        ), // Change text based on state
              ),
            ],
          ),
        ),
      ),
    );
  }
}
