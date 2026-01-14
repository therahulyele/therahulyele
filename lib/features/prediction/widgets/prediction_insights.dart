import 'package:flutter/material.dart';
import '../../../core/models/app_usage.dart';

class PredictionInsights extends StatelessWidget {
  final List<AppUsage> usage;

  const PredictionInsights({super.key, required this.usage});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Predictive Insights',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(Icons.construction, size: 48, color: Colors.blue[700]),
                  const SizedBox(height: 12),
                  Text(
                    'ML-Powered Insights Coming Soon!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'re working on machine learning models that will help you:\n\n'
                    '• Predict your daily app usage patterns\n'
                    '• Suggest optimal break times\n'
                    '• Identify productivity trends\n'
                    '• Recommend usage optimizations',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.blue[700]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Future Features:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ..._buildFeatureList(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFeatureList(BuildContext context) {
    final features = [
      'Usage Pattern Recognition',
      'Productivity Score Calculation',
      'Break Time Recommendations',
      'Weekly Usage Reports',
      'Goal Setting & Tracking',
      'Distraction Alerts',
    ];

    return features
        .map(
          (feature) => Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(feature, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        )
        .toList();
  }
}
