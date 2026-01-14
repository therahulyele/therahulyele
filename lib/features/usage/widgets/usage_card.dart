import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../core/models/app_usage.dart';
import '../../../core/utils/format_utils.dart';

class UsageCard extends StatelessWidget {
  final AppUsage app;
  final VoidCallback? onTap;

  const UsageCard({super.key, required this.app, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (app.error != null) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: ListTile(
          leading: const Icon(Icons.error, color: Colors.red),
          title: const Text('Error'),
          subtitle: Text(app.error!),
        ),
      );
    }

    final duration = FormatUtils.formatDuration(app.totalTimeForeground);
    final lastUsed = FormatUtils.formatLastUsed(app.lastTimeUsed);

    // Decode app icon from Base64
    Widget appIcon;
    if (app.iconBase64.isNotEmpty) {
      try {
        final iconBytes = base64Decode(app.iconBase64);
        appIcon = Image.memory(
          iconBytes,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackIcon(context);
          },
        );
      } catch (e) {
        appIcon = _buildFallbackIcon(context);
      }
    } else {
      appIcon = _buildFallbackIcon(context);
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: appIcon,
        ),
        title: Text(
          app.appName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Used $duration'),
            Text(
              'Last used: $lastUsed',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              duration,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              '${FormatUtils.msToMinutes(app.totalTimeForeground)}m',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFallbackIcon(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.apps, color: Theme.of(context).primaryColor, size: 24),
    );
  }
}
