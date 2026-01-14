import 'package:flutter/material.dart';
import '../../../core/services/usage_service.dart';

class PermissionPrompt extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const PermissionPrompt({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Permission Required',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _openSettings(context),
              icon: const Icon(Icons.settings),
              label: const Text('Open Settings'),
            ),
            const SizedBox(height: 8),
            TextButton(onPressed: onRetry, child: const Text('Check Again')),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _showInstructions(context),
              icon: const Icon(Icons.help_outline),
              label: const Text('Show Instructions'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSettings(BuildContext context) async {
    try {
      final success = await UsageService.openUsageSettings();
      if (!success) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open settings. Please open manually.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Instructions'),
        content: SingleChildScrollView(
          child: Text(_getPermissionInstructions()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _openSettings(context);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  String _getPermissionInstructions() {
    return '''To enable usage access:

Android:
1. Go to Settings > Apps & notifications
2. Tap "Special app access"
3. Tap "Usage access"
4. Find "The Lost Years" and enable it
5. Return to this app and refresh

iOS:
1. Go to Settings > Screen Time
2. Tap "App Limits"
3. Enable Screen Time permissions
4. Return to this app and refresh

Note: Screen Time API access requires additional setup.''';
  }
}
