import 'package:ekonum_app/config/colors.dart';
import 'package:ekonum_app/core/models/app_model.dart';
import 'package:ekonum_app/features/common/widgets/resource_usage_bar.dart';
import 'package:ekonum_app/utils/formatters.dart';
import 'package:flutter/material.dart';

class AppListItem extends StatelessWidget {
  final Application application;
  final VoidCallback onTap;

  const AppListItem({
    super.key,
    required this.application,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final replicaCount = application.replicas.length;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        // Match card shape for ripple effect
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.layers, color: theme.primaryColor, size: 24),
                  // Generic app icon
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      application.name,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Chip(
                    // Show replica count
                    label: Text(
                      '$replicaCount Cop${replicaCount == 1 ? 'y' : 'ies'}',
                    ),
                    labelStyle: theme.chipTheme.labelStyle?.copyWith(
                      fontSize: 11,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: theme.chipTheme.backgroundColor,
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textDisabled,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Total Usage Across All Copies',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ResourceUsageBar(
                      label: 'CPU',
                      value: application.totalCpuUsage,
                      valueText: Formatters.percentage(
                        application.totalCpuUsage,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ResourceUsageBar(
                      label: 'RAM',
                      value: application.totalRamUsage,
                      valueText: Formatters.percentage(
                        application.totalRamUsage,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
