import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:orbit_todo/core/constants/app_constants.dart';
import 'package:orbit_todo/core/theme/color_tokens.dart';
import 'package:orbit_todo/core/widgets/orbit_checkbox.dart';
import 'package:orbit_todo/core/widgets/priority_badge.dart';
import 'package:orbit_todo/features/tasks/application/tasks_provider.dart';
import 'package:orbit_todo/features/tasks/domain/task_entity.dart';
import 'package:orbit_todo/features/tasks/domain/task_priority.dart';
import 'package:orbit_todo/features/projects/application/projects_provider.dart';
import 'package:orbit_todo/features/projects/domain/project_entity.dart';

/// Task detail and edit screen.
///
/// Opens as a modal bottom sheet on phones, and as a side panel on tablets.
/// All task fields are editable inline.
class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({super.key, required this.taskId});
  final String taskId;

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  bool _isEditing = false;
  bool _isSaving = false;

  TaskEntity? _task;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _loadTask(TaskEntity task) {
    if (_task == null) {
      _titleController.text = task.title;
      _notesController.text = task.notes ?? '';
    }
    _task = task;
  }

  Future<void> _saveChanges() async {
    if (_task == null) return;
    setState(() => _isSaving = true);
    try {
      await ref.read(taskActionsProvider.notifier).updateTask(
            id: _task!.id,
            title: _titleController.text.trim(),
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          );
      setState(() => _isEditing = false);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  bool _hasUnsavedEdits(TaskEntity task) {
    if (!_isEditing) return false;
    final titleChanged = _titleController.text.trim() != task.title;
    final notesChanged = _notesController.text.trim() != (task.notes ?? '');
    return titleChanged || notesChanged;
  }

  Future<bool?> _showUnsavedChangesSheet(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppConstants.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Unsaved Changes', style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: AppConstants.space2),
            Text(
              'You have unsaved changes. Would you like to save them before leaving?',
              style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                    color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppConstants.space4),
            ListTile(
              leading: const Icon(Icons.save_outlined),
              title: const Text('Save & Leave'),
              onTap: () async {
                await _saveChanges();
                if (ctx.mounted) Navigator.pop(ctx, true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: const Text('Discard Changes'),
              onTap: () => Navigator.pop(ctx, true),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Keep Editing'),
              onTap: () => Navigator.pop(ctx, false),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskAsync = ref.watch(singleTaskProvider(widget.taskId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return taskAsync.when(
      data: (task) {
        if (task == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Task')),
            body: const Center(child: Text('Task not found')),
          );
        }
        _loadTask(task);

        final hasEdits = _hasUnsavedEdits(task);

        return PopScope(
          canPop: !hasEdits,
          onPopInvokedWithResult: (didPop, result) async {
            if (!didPop && hasEdits) {
              final shouldLeave = await _showUnsavedChangesSheet(context);
              if (shouldLeave == true && context.mounted) {
                context.pop();
              }
            }
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () async {
                  if (hasEdits) {
                    final shouldLeave = await _showUnsavedChangesSheet(context);
                    if (shouldLeave == true && context.mounted) {
                      context.pop();
                    }
                  } else {
                    context.pop();
                  }
                },
              ),
            actions: [
              if (_isEditing)
                TextButton(
                  onPressed: _isSaving ? null : _saveChanges,
                  child: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                )
              else
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Edit',
                  onPressed: () => setState(() => _isEditing = true),
                ),
              IconButton(
                icon: const Icon(Icons.more_vert_rounded),
                onPressed: () => _showTaskMenu(context, task),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row with checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: OrbitCheckbox(
                        isChecked: task.isCompleted,
                        onChanged: (_) => ref
                            .read(taskActionsProvider.notifier)
                            .toggleCompleted(task.id, completed: !task.isCompleted),
                        borderColor: task.priority != TaskPriority.none
                            ? task.priority.colorFor(theme.brightness)
                            : null,
                        checkColor: task.priority != TaskPriority.none
                            ? task.priority.colorFor(theme.brightness)
                            : null,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: AppConstants.space3),
                    Expanded(
                      child: _isEditing
                          ? TextField(
                              controller: _titleController,
                              style: theme.textTheme.titleLarge?.copyWith(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                filled: false,
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              autofocus: true,
                            )
                          : Text(
                              task.title,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: task.isCompleted
                                    ? colorScheme.onSurface.withOpacity(0.5)
                                    : colorScheme.onSurface,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.space4),
                const Divider(),
                const SizedBox(height: AppConstants.space3),

                // Metadata fields
                _MetaField(
                  icon: Icons.calendar_today_rounded,
                  label: 'Due date',
                  value: task.dueDate != null
                      ? DateFormat('EEE, d MMM yyyy').format(task.dueDate!)
                      : null,
                  placeholder: 'No due date',
                  isOverdue: task.isOverdue,
                  onTap: () => _editDueDate(task),
                ),

                _MetaField(
                  icon: Icons.flag_outlined,
                  label: 'Priority',
                  value: task.priority != TaskPriority.none
                      ? task.priority.label
                      : null,
                  placeholder: 'No priority',
                  iconColor: task.priority != TaskPriority.none
                      ? task.priority.colorFor(theme.brightness)
                      : null,
                  onTap: () => _editPriority(task),
                ),

                _MetaField(
                  icon: Icons.circle_outlined,
                  label: 'Project',
                  value: task.projectName,
                  placeholder: 'No project (Inbox)',
                  onTap: () {}, // TODO: project picker
                ),

                const SizedBox(height: AppConstants.space4),

                // Notes section
                Text(
                  'Notes',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppConstants.space2),
                if (_isEditing)
                  TextField(
                    controller: _notesController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Add notes…',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusMD),
                      ),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () => setState(() => _isEditing = true),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppConstants.space3),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusMD),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Text(
                        task.notes?.isNotEmpty == true
                            ? task.notes!
                            : 'Tap to add notes…',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: task.notes?.isNotEmpty == true
                              ? colorScheme.onSurface
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: AppConstants.space4),

                // Subtasks section
                if (task.hasSubtasks) ...[
                  _SubtaskSection(task: task),
                  const SizedBox(height: AppConstants.space4),
                ],

                // Add subtask button
                TextButton.icon(
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add subtask'),
                  onPressed: () => _showAddSubtask(task.id),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                ),

                const SizedBox(height: AppConstants.space8),

                // Meta timestamps
                Text(
                  'Created ${_formatTimestamp(task.createdAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                  ),
                ),
                if (task.completedAt != null)
                  Text(
                    'Completed ${_formatTimestamp(task.completedAt!)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary.withOpacity(0.7),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showTaskMenu(BuildContext context, TaskEntity task) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppConstants.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.archive_outlined),
              title: const Text('Archive task'),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(taskActionsProvider.notifier).archiveTask(task.id);
                context.pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline_rounded,
                  color: Theme.of(context).colorScheme.error),
              title: Text('Delete task',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(task);
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(TaskEntity task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text('"${task.title}" will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref.read(taskActionsProvider.notifier).permanentlyDeleteTask(task.id);
      if (mounted) context.pop();
    }
  }

  Future<void> _editDueDate(TaskEntity task) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: task.dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null && mounted) {
      await ref.read(taskActionsProvider.notifier).updateTask(
            id: task.id,
            dueDate: picked,
          );
    }
  }

  Future<void> _editPriority(TaskEntity task) async {
    final priority = await showModalBottomSheet<TaskPriority>(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppConstants.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Priority', style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: AppConstants.space4),
            ...TaskPriority.values.map((p) {
              final color = p == TaskPriority.none
                  ? Theme.of(ctx).colorScheme.onSurfaceVariant
                  : p.colorFor(Theme.of(ctx).brightness);
              return ListTile(
                leading: Icon(p.icon, color: color),
                title: Text(p.label),
                trailing: task.priority == p
                    ? Icon(Icons.check_rounded,
                        color: Theme.of(ctx).colorScheme.primary)
                    : null,
                onTap: () => Navigator.pop(ctx, p),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                ),
              );
            }),
            SizedBox(height: MediaQuery.of(ctx).padding.bottom),
          ],
        ),
      ),
    );
    if (priority != null && mounted) {
      await ref.read(taskActionsProvider.notifier).updateTask(
            id: task.id,
            priority: priority.value,
          );
    }
  }

  void _showAddSubtask(String taskId) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add subtask'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(hintText: 'Subtask title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final title = controller.text.trim();
              if (title.isNotEmpty) {
                await ref.read(taskRepositoryProvider).addSubtask(taskId, title);
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    return DateFormat('d MMM yyyy, HH:mm').format(dt);
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Metadata field row
// ──────────────────────────────────────────────────────────────────────────

class _MetaField extends StatelessWidget {
  const _MetaField({
    required this.icon,
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
    this.iconColor,
    this.isOverdue = false,
  });

  final IconData icon;
  final String label;
  final String? value;
  final String placeholder;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool isOverdue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final displayColor = isOverdue ? OrbitColorTokens.priorityUrgent : null;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: Icon(
        icon,
        size: 20,
        color: iconColor ?? colorScheme.onSurfaceVariant,
      ),
      title: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        value ?? placeholder,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: value != null
              ? (displayColor ?? colorScheme.onSurface)
              : colorScheme.onSurface.withOpacity(0.4),
          fontWeight: value != null && isOverdue ? FontWeight.w600 : null,
        ),
      ),
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right_rounded, size: 16),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Subtask section
// ──────────────────────────────────────────────────────────────────────────

class _SubtaskSection extends ConsumerWidget {
  const _SubtaskSection({required this.task});
  final TaskEntity task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subtasks',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.space2),
        ...task.subtasks.map(
          (subtask) => ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: Checkbox(
              value: subtask.isCompleted,
              onChanged: (_) => ref
                  .read(taskRepositoryProvider)
                  .toggleSubtask(subtask.id, completed: !subtask.isCompleted),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusXS),
              ),
            ),
            title: Text(
              subtask.title,
              style: theme.textTheme.bodyMedium?.copyWith(
                decoration: subtask.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
                color: subtask.isCompleted
                    ? colorScheme.onSurface.withOpacity(0.5)
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
