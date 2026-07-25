import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../../tasks/data/task_repository.dart';
import '../../tasks/domain/task_entity.dart';
import '../../tasks/application/tasks_provider.dart';
import '../domain/widget_snapshot_model.dart';
import 'widget_diagnostics_service.dart';

/// Service responsible for building, validating, and persisting atomic widget snapshots (PRD Sections 7, 9, 10).
class WidgetSnapshotService {
  final TaskRepository _taskRepo;
  final WidgetDiagnosticsService _diagnostics;

  WidgetSnapshotService(this._taskRepo, this._diagnostics);

  /// Builds and persists fresh snapshots for all 4 widget types (Today, Quick Add, Inbox, Focus).
  Future<void> rebuildAllSnapshots() async {
    final stopwatch = Stopwatch()..start();
    try {
      if (_diagnostics.simulateStorageFailure) {
        _diagnostics.logEvent(
          eventType: 'snapshot_build',
          widgetType: 'all',
          durationMs: stopwatch.elapsedMilliseconds,
          outcome: 'failure',
          reasonCode: 'WIDGET_STORAGE_WRITE_FAILED',
        );
        return;
      }

      final activeTasks = await _taskRepo.getAllActiveTasks();
      final now = DateTime.now();

      await _buildTodaySnapshot(activeTasks, now);
      await _buildInboxSnapshot(activeTasks);
      await _buildQuickAddSnapshot(activeTasks);
      await _buildFocusSnapshot(activeTasks, now);

      _diagnostics.logEvent(
        eventType: 'snapshot_build',
        widgetType: 'all',
        durationMs: stopwatch.elapsedMilliseconds,
        outcome: 'success',
      );
    } catch (e) {
      _diagnostics.logEvent(
        eventType: 'snapshot_build',
        widgetType: 'all',
        durationMs: stopwatch.elapsedMilliseconds,
        outcome: 'failure',
        reasonCode: 'WIDGET_SNAPSHOT_BUILD_EXCEPTION',
      );
    }
  }

  Future<void> _buildTodaySnapshot(List<TaskEntity> allActive, DateTime now) async {
    final nowDate = DateTime(now.year, now.month, now.day);

    final todayTasks = <TaskEntity>[];
    final overdueTasks = <TaskEntity>[];

    for (final task in allActive) {
      if (task.isCompleted) continue;

      if (task.dueDate != null) {
        final localDueDate = task.dueDate!.toLocal();
        final taskDate = DateTime(localDueDate.year, localDueDate.month, localDueDate.day);

        if (taskDate.isBefore(nowDate)) {
          overdueTasks.add(task);
        } else if (taskDate.isAtSameMomentAs(nowDate)) {
          todayTasks.add(task);
        }
      }
    }

    final combinedTasks = [...todayTasks, ...overdueTasks];
    final widgetItems = combinedTasks.map(_toWidgetTaskItem).toList();

    WidgetSnapshotData snapshot;
    if (_diagnostics.simulateMissingSnapshot) {
      snapshot = WidgetSnapshotData.fallback(
        widgetType: 'today',
        reasonCode: 'WIDGET_SNAPSHOT_MISSING',
      );
    } else if (_diagnostics.simulateInvalidSchema) {
      snapshot = WidgetSnapshotData(
        timestamp: DateTime.now().toIso8601String(),
        schemaVersion: 999, // Invalid future schema
        widgetType: 'today',
        totalCount: -1, // Invalid
        overdueCount: overdueTasks.length,
        items: widgetItems,
      );
    } else if (combinedTasks.isEmpty) {
      snapshot = WidgetSnapshotData.empty(widgetType: 'today');
    } else {
      snapshot = WidgetSnapshotData(
        timestamp: DateTime.now().toIso8601String(),
        widgetType: 'today',
        totalCount: combinedTasks.length,
        overdueCount: overdueTasks.length,
        items: widgetItems,
      );
    }

    await _saveAndRegisterSnapshot('today', snapshot, 'TodayWidgetProvider');
  }

  Future<void> _buildInboxSnapshot(List<TaskEntity> allActive) async {
    final inboxTasks = allActive.where((t) => t.projectId == null && !t.isCompleted).toList();
    final widgetItems = inboxTasks.map(_toWidgetTaskItem).toList();

    final snapshot = inboxTasks.isEmpty
        ? WidgetSnapshotData.empty(widgetType: 'inbox')
        : WidgetSnapshotData(
            timestamp: DateTime.now().toIso8601String(),
            widgetType: 'inbox',
            totalCount: inboxTasks.length,
            overdueCount: 0,
            items: widgetItems,
          );

    await _saveAndRegisterSnapshot('inbox', snapshot, 'InboxWidgetProvider');
  }

  Future<void> _buildQuickAddSnapshot(List<TaskEntity> allActive) async {
    final inboxCount = allActive.where((t) => t.projectId == null && !t.isCompleted).length;

    final snapshot = WidgetSnapshotData(
      timestamp: DateTime.now().toIso8601String(),
      widgetType: 'quick_add',
      totalCount: inboxCount,
      overdueCount: 0,
      items: const [],
    );

    await _saveAndRegisterSnapshot('quick_add', snapshot, 'QuickAddWidgetProvider');
  }

  Future<void> _buildFocusSnapshot(List<TaskEntity> allActive, DateTime now) async {
    final incomplete = allActive.where((t) => !t.isCompleted).toList();
    TaskEntity? focusCandidate;

    if (incomplete.isNotEmpty) {
      // Pick highest priority or earliest due task
      incomplete.sort((a, b) {
        final p = b.priority.index.compareTo(a.priority.index);
        if (p != 0) return p;
        if (a.dueDate != null && b.dueDate != null) {
          return a.dueDate!.compareTo(b.dueDate!);
        }
        return 0;
      });
      focusCandidate = incomplete.first;
    }

    final snapshot = focusCandidate == null
        ? WidgetSnapshotData.empty(widgetType: 'focus')
        : WidgetSnapshotData(
            timestamp: DateTime.now().toIso8601String(),
            widgetType: 'focus',
            totalCount: 1,
            overdueCount: 0,
            items: [_toWidgetTaskItem(focusCandidate)],
            focusTask: _toWidgetTaskItem(focusCandidate),
          );

    await _saveAndRegisterSnapshot('focus', snapshot, 'FocusWidgetProvider');
  }

  WidgetTaskItem _toWidgetTaskItem(TaskEntity task) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final isOverdue = task.dueDate != null && task.dueDate!.isBefore(todayStart) && !task.isCompleted;

    String? formattedDue;
    if (task.dueDate != null) {
      formattedDue = DateFormat('MMM d').format(task.dueDate!);
    }

    return WidgetTaskItem(
      id: task.id,
      title: task.title,
      isCompleted: task.isCompleted,
      isOverdue: isOverdue,
      formattedDueDate: formattedDue,
      priority: task.priority.index,
    );
  }

  Future<void> _saveAndRegisterSnapshot(
    String type,
    WidgetSnapshotData snapshot,
    String androidProviderName,
  ) async {
    if (!snapshot.isValid) {
      _diagnostics.logEvent(
        eventType: 'snapshot_validation_failure',
        widgetType: type,
        durationMs: 0,
        outcome: 'fallback',
        reasonCode: 'WIDGET_SNAPSHOT_INVALID_SCHEMA',
      );
      // Fallback: retain last known good snapshot
      return;
    }

    final jsonStr = jsonEncode(snapshot.toJson());
    await HomeWidget.saveWidgetData('widget_snapshot_$type', jsonStr);
    await HomeWidget.saveWidgetData('last_known_good_snapshot_$type', jsonStr);
    await HomeWidget.updateWidget(name: androidProviderName);
  }

  final Set<String> _processedActionIds = {};

  /// Action Safety Pipeline (PRD Section 8.1 & 9.5):
  /// Safely completes a task from a widget tap with idempotency check.
  Future<bool> handleWidgetTaskCompletion(String taskId, {String? eventId}) async {
    final sw = Stopwatch()..start();
    final actionKey = eventId ?? '$taskId-${DateTime.now().millisecondsSinceEpoch ~/ 2000}';

    if (_processedActionIds.contains(actionKey)) {
      _diagnostics.logEvent(
        eventType: 'widget_action_received',
        widgetType: 'action',
        durationMs: sw.elapsedMilliseconds,
        outcome: 'duplicate_ignored',
        reasonCode: 'WIDGET_ACTION_DUPLICATE_IGNORED',
      );
      return true;
    }
    _processedActionIds.add(actionKey);

    try {
      final task = await _taskRepo.getTask(taskId);
      if (task == null) {
        _diagnostics.logEvent(
          eventType: 'widget_action_received',
          widgetType: 'action',
          durationMs: sw.elapsedMilliseconds,
          outcome: 'failure',
          reasonCode: 'WIDGET_ACTION_TASK_NOT_FOUND',
        );
        return false;
      }

      // Explicit set completed = true for idempotency (PRD Section 8.1)
      if (!task.isCompleted) {
        await _taskRepo.toggleTaskCompleted(taskId, completed: true);
      }

      _diagnostics.logEvent(
        eventType: 'widget_action_received',
        widgetType: 'action',
        durationMs: sw.elapsedMilliseconds,
        outcome: 'success',
      );

      await rebuildAllSnapshots();
      return true;
    } catch (e) {
      _diagnostics.logEvent(
        eventType: 'widget_action_received',
        widgetType: 'action',
        durationMs: sw.elapsedMilliseconds,
        outcome: 'failure',
        reasonCode: 'WIDGET_ACTION_QUEUE_RETRY',
      );
      return false;
    }
  }
}

final widgetSnapshotServiceProvider = Provider<WidgetSnapshotService>((ref) {
  final repo = ref.watch(taskRepositoryProvider);
  final diagnostics = ref.watch(widgetDiagnosticsServiceProvider);
  return WidgetSnapshotService(repo, diagnostics);
});
