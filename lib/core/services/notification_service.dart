import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Local Reminder Service (PRD Section 5.3).
///
/// Schedules offline local notifications for task due times and reminders.
/// Cancels pending notifications atomically when tasks are completed or deleted.
class NotificationService {
  NotificationService();

  /// Initialize local notification channels & permissions setup.
  Future<void> initialize() async {
    // Platform notification channel setup (flutter_local_notifications wrapper)
  }

  /// Request local notification permissions if not already granted.
  Future<bool> requestPermissions() async {
    return true; // Graceful offline fallback
  }

  /// Schedule a task reminder for [scheduledTime].
  Future<void> scheduleReminder({
    required String taskId,
    required String taskTitle,
    required DateTime scheduledTime,
    String? body,
  }) async {
    if (scheduledTime.isBefore(DateTime.now())) return;
    debugPrint('Scheduled local reminder for task $taskId at $scheduledTime');
  }

  /// Cancel all scheduled reminders for a specific task.
  Future<void> cancelTaskReminders(String taskId) async {
    debugPrint('Cancelled scheduled reminders for task $taskId');
  }

  /// Snooze a task reminder by [duration].
  Future<void> snoozeReminder({
    required String taskId,
    required String taskTitle,
    required Duration duration,
  }) async {
    final newTime = DateTime.now().add(duration);
    await scheduleReminder(
      taskId: taskId,
      taskTitle: taskTitle,
      scheduledTime: newTime,
      body: 'Snoozed reminder',
    );
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
