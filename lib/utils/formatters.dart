import 'package:intl/intl.dart'; // Add intl package to pubspec.yaml

class Formatters {
  static String percentage(double value) {
    // Handle potential NaN or infinite values gracefully
    if (value.isNaN || value.isInfinite) {
      return '- %'; // Or return 'N/A' or '0%'
    }
    final format = NumberFormat.percentPattern();
    return format.format(value.clamp(0.0, 1.0)); // Clamp value between 0 and 1
  }

  static String storage(double gigabytes) {
    if (gigabytes.isNaN || gigabytes.isInfinite) return '- GB';
    if (gigabytes >= 1000) {
      return '${(gigabytes / 1000).toStringAsFixed(1)} TB';
    } else if (gigabytes >= 1) {
      return '${gigabytes.toStringAsFixed(1)} GB';
    } else {
      return '${(gigabytes * 1024).toStringAsFixed(0)} MB'; // Show MB if less than 1GB
    }
  }

  static String relativeTime(DateTime? dateTime) {
    if (dateTime == null) return 'Never';

    final difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 5) {
      return 'just now';
    } else if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      // Use a standard date format for older dates
      return DateFormat.MMMd().format(dateTime); // e.g., Oct 26
    }
  }

  // Add other formatters as needed
}
