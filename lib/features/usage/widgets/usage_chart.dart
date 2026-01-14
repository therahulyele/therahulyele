import 'package:flutter/material.dart';
import '../../../core/models/app_usage.dart';
import '../../../core/utils/format_utils.dart';

class UsageChart extends StatelessWidget {
  final List<AppUsage> usage;

  const UsageChart({super.key, required this.usage});

  @override
  Widget build(BuildContext context) {
    if (usage.isEmpty) {
      return const SizedBox.shrink();
    }

    final topApps = usage.take(5).toList();
    final maxTime = topApps.isNotEmpty ? topApps.first.totalTimeForeground : 1;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Apps Usage',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...topApps.asMap().entries.map((entry) {
              final index = entry.key;
              final app = entry.value;
              final percentage = (app.totalTimeForeground / maxTime) * 100;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            app.appName,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          FormatUtils.formatDuration(app.totalTimeForeground),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getColorForIndex(index),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getColorForIndex(int index) {
    const colors = [
      Color(0xFF6366F1), // Primary
      Color(0xFF10B981), // Secondary
      Color(0xFFF59E0B), // Accent
      Color(0xFFEF4444), // Error
      Color(0xFF8B5CF6), // Purple
    ];
    return colors[index % colors.length];
  }
}
