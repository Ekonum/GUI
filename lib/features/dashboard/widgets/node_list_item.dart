import 'package:ekonum_app/config/colors.dart';
import 'package:ekonum_app/features/common/widgets/resource_usage_bar.dart';
import 'package:ekonum_app/utils/formatters.dart';
import 'package:flutter/material.dart';

class NodeListItem extends StatelessWidget {
  final String nodeName;
  final double cpuUsage;
  final double ramUsage;
  final int appsRunningCount;
  final VoidCallback onTap;

  const NodeListItem({
    super.key,
    required this.nodeName,
    required this.cpuUsage,
    required this.ramUsage,
    required this.appsRunningCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      // Slightly less vertical margin
      child: InkWell(
        // Make the card tappable
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0), // Match card shape
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.dns_outlined, color: theme.primaryColor, size: 24),
                  // Node icon
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(nodeName, style: theme.textTheme.titleMedium),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textDisabled,
                  ),
                  // Navigation indicator
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ResourceUsageBar(
                      label: 'CPU',
                      value: cpuUsage,
                      valueText: Formatters.percentage(cpuUsage),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ResourceUsageBar(
                      label: 'RAM',
                      value: ramUsage,
                      valueText: Formatters.percentage(ramUsage),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '$appsRunningCount apps running',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
