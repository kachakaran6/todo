import 'package:equatable/equatable.dart';
import '../../../data/local/database.dart';
import 'task_priority.dart';

/// Rich domain model for a task, combining the database [Task] row
/// with its associated tags, subtasks, and computed properties.
class TaskEntity extends Equatable {
  const TaskEntity({
    required this.task,
    this.tags = const [],
    this.subtasks = const [],
    this.projectName,
    this.projectColor,
  });

  final Task task;
  final List<Tag> tags;
  final List<Subtask> subtasks;
  final String? projectName;
  final String? projectColor;

  // ──────────────────────────────────────────────────────────────────────────
  // Convenience getters
  // ──────────────────────────────────────────────────────────────────────────

  String get id => task.id;
  String get title => task.title;
  String? get notes => task.notes;
  bool get isCompleted => task.isCompleted;
  bool get isArchived => task.isArchived;
  DateTime? get dueDate => task.dueDate;
  DateTime? get startDate => task.startDate;
  String? get dueTime => task.dueTime;
  DateTime? get completedAt => task.completedAt;
  String? get projectId => task.projectId;
  TaskPriority get priority => TaskPriority.fromValue(task.priority);
  int? get estimatedMinutes => task.estimatedMinutes;
  DateTime get createdAt => task.createdAt;
  DateTime get updatedAt => task.updatedAt;

  // ──────────────────────────────────────────────────────────────────────────
  // Computed
  // ──────────────────────────────────────────────────────────────────────────

  /// True if the task has a due date and that date is before today (local).
  bool get isOverdue {
    if (isCompleted || dueDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    return due.isBefore(today);
  }

  /// True if due date is today (local date comparison).
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  /// True if due date is in the future (not today, not overdue).
  bool get isDueFuture {
    if (dueDate == null) return false;
    return !isOverdue && !isDueToday;
  }

  /// Count of completed subtasks.
  int get completedSubtaskCount =>
      subtasks.where((s) => s.isCompleted).length;

  /// Total subtask count.
  int get subtaskCount => subtasks.length;

  /// Subtask progress as a fraction [0.0 - 1.0].
  double get subtaskProgress =>
      subtaskCount == 0 ? 0 : completedSubtaskCount / subtaskCount;

  bool get hasSubtasks => subtaskCount > 0;
  bool get hasTags => tags.isNotEmpty;
  bool get hasDueDate => dueDate != null;
  bool get hasDueTime => dueTime != null;
  bool get hasNotes => notes != null && notes!.isNotEmpty;

  // ──────────────────────────────────────────────────────────────────────────
  // CopyWith
  // ──────────────────────────────────────────────────────────────────────────

  TaskEntity copyWith({
    Task? task,
    List<Tag>? tags,
    List<Subtask>? subtasks,
    String? projectName,
    String? projectColor,
  }) {
    return TaskEntity(
      task: task ?? this.task,
      tags: tags ?? this.tags,
      subtasks: subtasks ?? this.subtasks,
      projectName: projectName ?? this.projectName,
      projectColor: projectColor ?? this.projectColor,
    );
  }

  @override
  List<Object?> get props => [task.id, task.updatedAt, tags, subtasks];
}
