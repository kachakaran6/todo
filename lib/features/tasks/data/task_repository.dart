import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../data/local/database.dart';
import '../../../data/local/tables.dart';
import '../domain/task_entity.dart';
import '../domain/task_priority.dart';

const _uuid = Uuid();

/// Repository for all task data operations.
/// Abstracts the Drift DAO and maps raw rows to domain entities.
class TaskRepository {
  TaskRepository(this._db);

  final AppDatabase _db;

  // ──────────────────────────────────────────────────────────────────────────
  // Watch streams — return domain entities
  // ──────────────────────────────────────────────────────────────────────────

  Stream<List<TaskEntity>> watchInboxTasks() =>
      _db.tasksDao.watchInboxTasks().asyncMap(_enrichTasks);

  Stream<List<TaskEntity>> watchTodayTasks() =>
      _db.tasksDao.watchTodayTasks().asyncMap(_enrichTasks);

  Stream<List<TaskEntity>> watchAllActiveTasks() =>
      _db.tasksDao.watchAllActiveTasks().asyncMap(_enrichTasks);

  Stream<List<TaskEntity>> watchProjectTasks(String projectId) =>
      _db.tasksDao.watchTasksByProject(projectId).asyncMap(_enrichTasks);

  Stream<List<TaskEntity>> watchCompletedTasks() =>
      _db.tasksDao.watchCompletedTasks().asyncMap(_enrichTasks);

  Stream<int> watchTodayTaskCount() => _db.tasksDao.watchTodayTaskCount();

  Stream<int> watchProjectTaskCount(String projectId) =>
      _db.tasksDao.watchProjectTaskCount(projectId);

  // ──────────────────────────────────────────────────────────────────────────
  // One-shot queries
  // ──────────────────────────────────────────────────────────────────────────

  Future<TaskEntity?> getTask(String id) async {
    final task = await _db.tasksDao.getTask(id);
    if (task == null) return null;
    return _enrichTask(task);
  }

  Future<List<TaskEntity>> searchTasks(String query) async {
    final rawTasks = await _db.tasksDao.searchTasks(query);
    return _enrichTasks(rawTasks);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Writes
  // ──────────────────────────────────────────────────────────────────────────

  /// Create a new task and return its ID.
  Future<String> createTask({
    required String title,
    String? notes,
    DateTime? dueDate,
    String? dueTime,
    DateTime? startDate,
    TaskPriority priority = TaskPriority.none,
    String? projectId,
    int? estimatedMinutes,
    String? recurrenceRule,
  }) async {
    final id = _uuid.v4();
    await _db.tasksDao.insertTask(
      TasksCompanion.insert(
        id: id,
        title: title,
        notes: Value(notes),
        dueDate: Value(dueDate),
        dueTime: Value(dueTime),
        startDate: Value(startDate),
        priority: Value(priority.value),
        projectId: Value(projectId),
        estimatedMinutes: Value(estimatedMinutes),
        recurrenceRule: Value(recurrenceRule),
      ),
    );
    return id;
  }

  /// Update an existing task.
  Future<void> updateTask({
    required String id,
    String? title,
    String? notes,
    DateTime? dueDate,
    String? dueTime,
    bool clearDueDate = false,
    DateTime? startDate,
    TaskPriority? priority,
    String? projectId,
    bool clearProject = false,
    int? estimatedMinutes,
    int? sortOrder,
    String? recurrenceRule,
  }) async {
    await _db.tasksDao.updateTask(
      TasksCompanion(
        id: Value(id),
        title: title != null ? Value(title) : const Value.absent(),
        notes: notes != null ? Value(notes) : const Value.absent(),
        dueDate: clearDueDate
            ? const Value(null)
            : dueDate != null
                ? Value(dueDate)
                : const Value.absent(),
        dueTime: dueTime != null ? Value(dueTime) : const Value.absent(),
        startDate: startDate != null ? Value(startDate) : const Value.absent(),
        priority:
            priority != null ? Value(priority.value) : const Value.absent(),
        projectId: clearProject
            ? const Value(null)
            : projectId != null
                ? Value(projectId)
                : const Value.absent(),
        estimatedMinutes: estimatedMinutes != null
            ? Value(estimatedMinutes)
            : const Value.absent(),
        sortOrder: sortOrder != null ? Value(sortOrder) : const Value.absent(),
        recurrenceRule: recurrenceRule != null
            ? Value(recurrenceRule)
            : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Toggle task completion.
  Future<void> toggleTaskCompleted(String id, {required bool completed}) {
    return _db.tasksDao.setTaskCompleted(id, completed: completed);
  }

  /// Archive a task (soft remove from active lists).
  Future<void> archiveTask(String id) => _db.tasksDao.archiveTask(id);

  /// Restore an archived or completed task to active state.
  Future<void> restoreTask(String id) => _db.tasksDao.restoreTask(id);

  /// Soft delete a task (can be undone by restoring).
  Future<void> softDeleteTask(String id) => _db.tasksDao.softDeleteTask(id);

  /// Permanently delete a task and all its associated data.
  Future<void> permanentlyDeleteTask(String id) =>
      _db.tasksDao.permanentlyDeleteTask(id);

  // ──────────────────────────────────────────────────────────────────────────
  // Subtasks
  // ──────────────────────────────────────────────────────────────────────────

  /// Add a subtask to a task.
  Future<String> addSubtask(String taskId, String title) async {
    final id = _uuid.v4();
    await _db.tasksDao.upsertSubtask(
      SubtasksCompanion.insert(
        id: id,
        taskId: taskId,
        title: title,
      ),
    );
    return id;
  }

  Future<void> toggleSubtask(String subtaskId, {required bool completed}) =>
      _db.tasksDao.toggleSubtask(subtaskId, completed: completed);

  Future<void> deleteSubtask(String subtaskId) =>
      _db.tasksDao.deleteSubtask(subtaskId);

  // ──────────────────────────────────────────────────────────────────────────
  // Private: enrich raw DB rows into domain entities
  // ──────────────────────────────────────────────────────────────────────────

  Future<List<TaskEntity>> _enrichTasks(List<Task> rawTasks) async {
    return Future.wait(rawTasks.map(_enrichTask));
  }

  Future<TaskEntity> _enrichTask(Task task) async {
    final tags = await _db.tagsDao.getTagsForTask(task.id);
    final subtasks = await _db.tasksDao.getSubtasks(task.id);


    Project? project;
    if (task.projectId != null) {
      project = await _db.projectsDao.getProject(task.projectId!);
    }

    return TaskEntity(
      task: task,
      tags: tags,
      subtasks: subtasks,
      projectName: project?.name,
      projectColor: project?.colorHex,
    );
  }
}
