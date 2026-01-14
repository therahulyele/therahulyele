class FormatUtils {
  static String msToMinutes(int ms) => (ms / 60000).toStringAsFixed(1);

  static String formatDuration(int milliseconds) {
    if (milliseconds < 0) return '0m';

    final seconds = milliseconds ~/ 1000;
    final minutes = seconds ~/ 60;
    final hours = minutes ~/ 60;
    final days = hours ~/ 24;

    if (days > 0) {
      return '${days}d ${hours % 24}h ${minutes % 60}m';
    } else if (hours > 0) {
      return '${hours}h ${minutes % 60}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds % 60}s';
    } else {
      return '${seconds}s';
    }
  }

  static String formatMinutes(int milliseconds) {
    final minutes = (milliseconds / 60000).round();
    return '${minutes}m';
  }

  static String formatHours(int milliseconds) {
    final hours = (milliseconds / 3600000).toStringAsFixed(1);
    return '${hours}h';
  }

  static String formatLastUsed(int timestamp) {
    if (timestamp == 0) return 'Never';

    final now = DateTime.now().millisecondsSinceEpoch;
    final diff = now - timestamp;

    if (diff < 60000) {
      return 'Just now';
    } else if (diff < 3600000) {
      final minutes = (diff / 60000).round();
      return '${minutes}m ago';
    } else if (diff < 86400000) {
      final hours = (diff / 3600000).round();
      return '${hours}h ago';
    } else {
      final days = (diff / 86400000).round();
      return '${days}d ago';
    }
  }

  static String formatTimestamp(int timestamp) {
    if (timestamp == 0) return 'Never';

    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
