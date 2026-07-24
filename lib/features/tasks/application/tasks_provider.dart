import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/local/database.dart';
import '../data/task_repository.dart';
import '../domain/task_entity.dart';
import '../domain/task_priority.dart';

part 'tasks_provider.g.dart';

// ──────────────────────────────────────────────────────────────────────────
// Database provider (singleton)
// ──────────────────────────────────────────────────────────────────────────

/// Provides the single AppDatabase instance.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

/// Provides the TaskRepository.
@Riverpod(keepAlive: true)
TaskRepository taskRepository(Ref ref) {
  return TaskRepository(ref.watch(appDatabaseProvider));
}

// ──────────────────────────────────────────────────────────────────────────
// Task list providers
// ──────────────────────────────────────────────────────────────────────────

/// Inbox tasks stream.
@riverpod
Stream<List<TaskEntity>> inboxTasks(Ref ref) {
  return ref.watch(taskRepositoryProvider).watchInboxTasks();
}

/// Today tasks stream.
@riverpod
Stream<List<TaskEntity>> todayTasks(Ref ref) {
  return ref.watch(taskRepositoryProvider).watchTodayTasks();
}

/// All active tasks stream.
@riverpod
Stream<List<TaskEntity>> allActiveTasks(Ref ref) {
  return ref.watch(taskRepositoryProvider).watchAllActiveTasks();
}

/// Tasks for a specific project.
@riverpod
Stream<List<TaskEntity>> projectTasks(Ref ref, String projectId) {
  return ref.watch(taskRepositoryProvider).watchProjectTasks(projectId);
}

/// Completed tasks stream.
@riverpod
Stream<List<TaskEntity>> completedTasks(Ref ref) {
  return ref.watch(taskRepositoryProvider).watchCompletedTasks();
}

/// Today task count (for badge in nav).
@riverpod
Stream<int> todayTaskCount(Ref ref) {
  return ref.watch(taskRepositoryProvider).watchTodayTaskCount();
}

/// Project task count (for badge on project card).
@riverpod
Stream<int> projectTaskCount(Ref ref, String projectId) {
  return ref.watch(taskRepositoryProvider).watchProjectTaskCount(projectId);
}

// ──────────────────────────────────────────────────────────────────────────
// Single task provider
// ──────────────────────────────────────────────────────────────────────────

/// Fetches a single task entity by ID.
@riverpod
Future<TaskEntity?> singleTask(Ref ref, String taskId) {
  return ref.watch(taskRepositoryProvider).getTask(taskId);
}

// ──────────────────────────────────────────────────────────────────────────
// Search provider
// ──────────────────────────────────────────────────────────────────────────

/// Search results provider.
@riverpod
Future<List<TaskEntity>> taskSearchResults(Ref ref, String query) {
  if (query.trim().isEmpty) return Future.value([]);
  return ref.watch(taskRepositoryProvider).searchTasks(query);
}

// ──────────────────────────────────────────────────────────────────────────
// Mutation notifier
// ──────────────────────────────────────────────────────────────────────────

/// Exposes task mutation actions from the UI layer.
@riverpod
class TaskActions extends _$TaskActions {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  TaskRepository get _repo => ref.read(taskRepositoryProvider);

  Future<String?> createTask({
    required String title,
    String? notes,
    DateTime? dueDate,
    String? dueTime,
    DateTime? startDate,
    int priority = 0,
    String? projectId,
    int? estimatedMinutes,
  }) async {
    state = const AsyncLoading();
    try {
      final id = await _repo.createTask(
        title: title,
        notes: notes,
        dueDate: dueDate,
        dueTime: dueTime,
        startDate: startDate,
        priority: TaskPriority.fromValue(priority),
        projectId: projectId,
        estimatedMinutes: estimatedMinutes,
      );
      state = const AsyncData(null);
      return id;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }

  Future<void> toggleCompleted(String id, {required bool completed}) async {
    await _repo.toggleTaskCompleted(id, completed: completed);
  }

  Future<void> archiveTask(String id) async {
    await _repo.archiveTask(id);
  }

  Future<void> restoreTask(String id) async {
    await _repo.restoreTask(id);
  }

  Future<void> softDeleteTask(String id) async {
    await _repo.softDeleteTask(id);
  }

  Future<void> permanentlyDeleteTask(String id) async {
    await _repo.permanentlyDeleteTask(id);
  }

  Future<void> updateTask({
    required String id,
    String? title,
    String? notes,
    DateTime? dueDate,
    bool clearDueDate = false,
    String? dueTime,
    DateTime? startDate,
    int? priority,
    String? projectId,
    bool clearProject = false,
    int? estimatedMinutes,
  }) async {
    await _repo.updateTask(
      id: id,
      title: title,
      notes: notes,
      dueDate: dueDate,
      clearDueDate: clearDueDate,
      dueTime: dueTime,
      startDate: startDate,
      priority: priority != null ? TaskPriority.fromValue(priority) : null,
      projectId: projectId,
      clearProject: clearProject,
      estimatedMinutes: estimatedMinutes,
    );
  }
}
