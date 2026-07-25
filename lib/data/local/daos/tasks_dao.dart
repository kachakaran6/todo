import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'tasks_dao.g.dart';

/// Data Access Object for all Task operations.
/// Provides strongly-typed queries used by TaskRepository.
@DriftAccessor(tables: [Tasks, TaskTags, Tags, Subtasks, TaskLinks, Projects])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(super.db);

  // ──────────────────────────────────────────────────────────────────────────
  // Single task fetch
  // ──────────────────────────────────────────────────────────────────────────

  /// Watch a single task by ID.
  Stream<Task?> watchTask(String id) {
    return (select(tasks)..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }

  /// Fetch a single task by ID.
  Future<Task?> getTask(String id) {
    return (select(tasks)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Inbox queries — unprocessed tasks (no due date, no project typically)
  // ──────────────────────────────────────────────────────────────────────────

  /// Watch all active (non-completed, non-archived, non-deleted) tasks
  /// not assigned to any project, ordered by sort order then creation date.
  Stream<List<Task>> watchInboxTasks() {
    return (select(tasks)
          ..where(
            (t) =>
                t.isCompleted.equals(false) &
                t.isArchived.equals(false) &
                t.isDeleted.equals(false) &
                t.projectId.isNull(),
          )
          ..orderBy([
            (t) => OrderingTerm.asc(t.sortOrder),
            (t) => OrderingTerm.asc(t.createdAt),
          ]))
        .watch();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Today queries
  // ──────────────────────────────────────────────────────────────────────────

  /// Watch tasks that are due today or overdue, active (not completed/archived).
  Stream<List<Task>> watchTodayTasks() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return (select(tasks)
          ..where(
            (t) =>
                t.isCompleted.equals(false) &
                t.isArchived.equals(false) &
                t.isDeleted.equals(false) &
                t.dueDate.isSmallerThanValue(tomorrow),
          )
          ..orderBy([
            (t) => OrderingTerm.asc(t.priority),
            (t) => OrderingTerm.asc(t.dueDate),
          ]))
        .watch();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // All tasks query (for All Tasks screen)
  // ──────────────────────────────────────────────────────────────────────────

  /// Watch all active tasks with configurable sort.
  Stream<List<Task>> watchAllActiveTasks() {
    return (select(tasks)
          ..where(
            (t) =>
                t.isArchived.equals(false) &
                t.isDeleted.equals(false),
          )
          ..orderBy([
            (t) => OrderingTerm.asc(t.isCompleted),
            (t) => OrderingTerm.desc(t.priority),
            (t) => OrderingTerm.asc(t.dueDate),
            (t) => OrderingTerm.asc(t.createdAt),
          ]))
        .watch();
  }

  /// One-shot fetch of all active tasks.
  Future<List<Task>> getAllActiveTasks() {
    return (select(tasks)
          ..where(
            (t) =>
                t.isArchived.equals(false) &
                t.isDeleted.equals(false),
          )
          ..orderBy([
            (t) => OrderingTerm.asc(t.isCompleted),
            (t) => OrderingTerm.desc(t.priority),
            (t) => OrderingTerm.asc(t.dueDate),
            (t) => OrderingTerm.asc(t.createdAt),
          ]))
        .get();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Project tasks
  // ──────────────────────────────────────────────────────────────────────────

  /// Watch tasks in a specific project.
  Stream<List<Task>> watchTasksByProject(String projectId) {
    return (select(tasks)
          ..where(
            (t) =>
                t.projectId.equals(projectId) &
                t.isArchived.equals(false) &
                t.isDeleted.equals(false),
          )
          ..orderBy([
            (t) => OrderingTerm.asc(t.isCompleted),
            (t) => OrderingTerm.asc(t.sortOrder),
            (t) => OrderingTerm.asc(t.createdAt),
          ]))
        .watch();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Completed / Archive
  // ──────────────────────────────────────────────────────────────────────────

  /// Watch completed (non-deleted) tasks for the history/archive view.
  Stream<List<Task>> watchCompletedTasks() {
    return (select(tasks)
          ..where(
            (t) =>
                t.isCompleted.equals(true) &
                t.isDeleted.equals(false),
          )
          ..orderBy([
            (t) => OrderingTerm.desc(t.completedAt),
          ]))
        .watch();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Search
  // ──────────────────────────────────────────────────────────────────────────

  /// Search tasks by title (case insensitive).
  Future<List<Task>> searchTasks(String query) {
    return (select(tasks)
          ..where(
            (t) =>
                t.title.lower().contains(query.toLowerCase()) &
                t.isDeleted.equals(false),
          )
          ..orderBy([
            (t) => OrderingTerm.asc(t.isCompleted),
            (t) => OrderingTerm.asc(t.dueDate),
          ])
          ..limit(100))
        .get();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Counts
  // ──────────────────────────────────────────────────────────────────────────

  /// Watch count of active tasks in a project.
  Stream<int> watchProjectTaskCount(String projectId) {
    final countExpr = tasks.id.count();
    final query = selectOnly(tasks)
      ..addColumns([countExpr])
      ..where(
        tasks.projectId.equals(projectId) &
            tasks.isCompleted.equals(false) &
            tasks.isArchived.equals(false) &
            tasks.isDeleted.equals(false),
      );
    return query.map((row) => row.read(countExpr) ?? 0).watchSingle();
  }

  /// Watch count of today's incomplete tasks.
  Stream<int> watchTodayTaskCount() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final countExpr = tasks.id.count();
    final query = selectOnly(tasks)
      ..addColumns([countExpr])
      ..where(
        tasks.isCompleted.equals(false) &
            tasks.isArchived.equals(false) &
            tasks.isDeleted.equals(false) &
            tasks.dueDate.isSmallerThanValue(tomorrow),
      );
    return query.map((row) => row.read(countExpr) ?? 0).watchSingle();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Subtasks
  // ──────────────────────────────────────────────────────────────────────────

  /// Watch subtasks for a given parent task.
  Stream<List<Subtask>> watchSubtasks(String taskId) {
    return (select(subtasks)
          ..where((s) => s.taskId.equals(taskId))
          ..orderBy([(s) => OrderingTerm.asc(s.sortOrder)]))
        .watch();
  }

  /// One-shot fetch of subtasks for a given parent task (for enrichment).
  Future<List<Subtask>> getSubtasks(String taskId) {
    return (select(subtasks)
          ..where((s) => s.taskId.equals(taskId))
          ..orderBy([(s) => OrderingTerm.asc(s.sortOrder)]))
        .get();
  }


  // ──────────────────────────────────────────────────────────────────────────
  // Writes
  // ──────────────────────────────────────────────────────────────────────────

  /// Insert a new task.
  Future<void> insertTask(TasksCompanion task) async {
    await into(tasks).insert(task);
  }

  /// Update an existing task.
  Future<void> updateTask(TasksCompanion task) async {
    await (update(tasks)..where((t) => t.id.equals(task.id.value)))
        .write(task);
  }

  /// Soft-complete a task (toggle completion).
  Future<void> setTaskCompleted(String id, {required bool completed}) async {
    await (update(tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        isCompleted: Value(completed),
        completedAt: Value(completed ? DateTime.now() : null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Archive a task.
  Future<void> archiveTask(String id) async {
    await (update(tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        isArchived: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Restore an archived task.
  Future<void> restoreTask(String id) async {
    await (update(tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        isArchived: const Value(false),
        isCompleted: const Value(false),
        completedAt: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Soft delete (marks isDeleted=true). Data is retained for undo.
  Future<void> softDeleteTask(String id) async {
    await (update(tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Permanently delete a task and all its subtasks + links.
  Future<void> permanentlyDeleteTask(String id) async {
    await transaction(() async {
      await (delete(subtasks)..where((s) => s.taskId.equals(id))).go();
      await (delete(taskLinks)..where((l) => l.taskId.equals(id))).go();
      await (delete(taskTags)..where((tt) => tt.taskId.equals(id))).go();
      await (delete(tasks)..where((t) => t.id.equals(id))).go();
    });
  }

  /// Insert or replace a subtask.
  Future<void> upsertSubtask(SubtasksCompanion subtask) async {
    await into(subtasks).insertOnConflictUpdate(subtask);
  }

  /// Toggle subtask completion.
  Future<void> toggleSubtask(String subtaskId, {required bool completed}) async {
    await (update(subtasks)..where((s) => s.id.equals(subtaskId))).write(
      SubtasksCompanion(isCompleted: Value(completed)),
    );
  }

  /// Delete a subtask.
  Future<void> deleteSubtask(String subtaskId) async {
    await (delete(subtasks)..where((s) => s.id.equals(subtaskId))).go();
  }

  /// Set task tags (replaces existing set).
  Future<void> setTaskTags(String taskId, List<String> tagIds) async {
    await transaction(() async {
      await (delete(taskTags)..where((tt) => tt.taskId.equals(taskId))).go();
      for (final tagId in tagIds) {
        await into(taskTags).insert(
          TaskTagsCompanion.insert(taskId: taskId, tagId: tagId),
        );
      }
    });
  }

  /// Get tag IDs for a task.
  Future<List<String>> getTagIdsForTask(String taskId) async {
    final result = await (select(taskTags)
          ..where((tt) => tt.taskId.equals(taskId)))
        .get();
    return result.map((r) => r.tagId).toList();
  }
}
