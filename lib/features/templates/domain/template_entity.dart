/// Task template entity (PRD Section 4.5).
class TaskTemplateEntity {
  const TaskTemplateEntity({
    required this.id,
    required this.title,
    this.notes,
    this.priority = 0,
    this.projectId,
    this.subtasksJson,
  });

  final String id;
  final String title;
  final String? notes;
  final int priority;
  final String? projectId;
  final String? subtasksJson;
}
