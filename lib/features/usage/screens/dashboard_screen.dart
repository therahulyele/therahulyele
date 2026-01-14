import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/usage_provider.dart';
import '../widgets/usage_card.dart';
import '../widgets/permission_prompt.dart';
import '../widgets/usage_chart.dart';
import 'app_details_screen.dart';
import '../../../core/utils/format_utils.dart';
import '../../../core/services/usage_service.dart';
import '../../../theme/theme_notifier.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usage Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<UsageProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: provider.loading ? null : provider.refreshUsage,
              );
            },
          ),
          Consumer<ThemeNotifier>(
            builder: (context, themeNotifier, child) {
              return IconButton(
                icon: Icon(
                  themeNotifier.isDark ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () => themeNotifier.toggleTheme(),
                tooltip: themeNotifier.isDark
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _openSettings(context),
          ),
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () => _debugPermissions(context),
          ),
        ],
      ),
      body: Consumer<UsageProvider>(
        builder: (context, provider, child) {
          if (provider.loading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading usage statistics...'),
                ],
              ),
            );
          }

          if (provider.error != null && !provider.hasPermission) {
            return PermissionPrompt(
              error: provider.error!,
              onRetry: provider.refreshUsage,
            );
          }

          if (provider.usage.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone_android,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Usage Data',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No app usage data found for the last 24 hours.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: provider.refreshUsage,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.refreshUsage,
            child: ListView(
              children: [
                // Summary Card
                if (provider.summary != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today\'s Summary',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildSummaryItem(
                                  context,
                                  'Total Apps',
                                  '${provider.summary!.totalApps}',
                                  Icons.apps,
                                ),
                                _buildSummaryItem(
                                  context,
                                  'Total Time',
                                  FormatUtils.formatDuration(
                                    provider.summary!.totalUsageTime,
                                  ),
                                  Icons.access_time,
                                ),
                                _buildSummaryItem(
                                  context,
                                  'Avg per App',
                                  FormatUtils.formatDuration(
                                    provider.summary!.averageUsagePerApp,
                                  ),
                                  Icons.trending_up,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],

                // Usage Chart
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: UsageChart(usage: provider.usage),
                ),

                const SizedBox(height: 16),

                // Apps List
                Text(
                  'App Usage Details',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.usage.length,
                  itemBuilder: (context, index) {
                    final app = provider.usage[index];
                    return UsageCard(
                      app: app,
                      onTap: () => _showAppDetails(context, app),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  void _showAppDetails(BuildContext context, app) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AppDetailsScreen(app: app)),
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

  Future<void> _debugPermissions(BuildContext context) async {
    try {
      final debugInfo = await UsageService.debugPermissions();
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Debug Permissions'),
            content: SingleChildScrollView(
              child: Text(
                debugInfo.entries.map((e) => '${e.key}: ${e.value}').join('\n'),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Debug error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
