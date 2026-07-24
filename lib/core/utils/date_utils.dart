import 'package:intl/intl.dart';

/// Date/time formatting utilities for Orbit Todo.
class OrbitDateUtils {
  OrbitDateUtils._();

  /// Returns a human-friendly due date string for task tiles.
  /// Examples: "Today", "Tomorrow", "Yesterday", "Monday", "14 Jan"
  static String formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    if (diff < 0) return '${diff.abs()}d overdue';
    if (diff < 7) return DateFormat('EEEE').format(date); // "Monday"
    if (date.year == now.year) return DateFormat('d MMM').format(date); // "14 Jan"
    return DateFormat('d MMM yyyy').format(date); // "14 Jan 2026"
  }

  /// Returns a relative timestamp string.
  /// Examples: "just now", "5m ago", "2h ago", "yesterday", "14 Jan"
  static String formatRelative(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('d MMM').format(dt);
  }

  /// Formats a full timestamp.
  static String formatFull(DateTime dt) {
    return DateFormat('d MMM yyyy, HH:mm').format(dt);
  }

  /// Returns true if [date] is today (local date comparison).
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Returns true if [date] is in the past (before today, local).
  static bool isPast(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    return d.isBefore(today);
  }

  /// Returns the start of today (midnight, local time).
  static DateTime get todayStart {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Returns the start of tomorrow (midnight, local time).
  static DateTime get tomorrowStart {
    return todayStart.add(const Duration(days: 1));
  }
}
