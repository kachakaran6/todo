import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:orbit_todo/core/constants/app_constants.dart';
import 'package:orbit_todo/core/widgets/orbit_checkbox.dart';
import 'package:orbit_todo/features/tasks/application/tasks_provider.dart';
import 'package:orbit_todo/features/tasks/domain/task_entity.dart';
import 'package:orbit_todo/features/tasks/domain/task_priority.dart';
import 'package:orbit_todo/features/projects/application/projects_provider.dart';

/// Task detail and edit screen.
/// Professional design with scrollable instant pickers and high contrast surfaces.
class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({super.key, required this.taskId});
  final String taskId;

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  late final TextEditingController _subtaskController;
  bool _isEditingTitle = false;
  bool _isEditingNotes = false;

  TaskEntity? _task;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _notesController = TextEditingController();
    _subtaskController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _subtaskController.dispose();
    super.dispose();
  }

  void _loadTask(TaskEntity task) {
    if (_task == null || _task!.id != task.id) {
      _titleController.text = task.title;
      _notesController.text = task.notes ?? '';
    } else {
      if (!_isEditingTitle) _titleController.text = task.title;
      if (!_isEditingNotes) _notesController.text = task.notes ?? '';
    }
    _task = task;
  }

  Future<void> _saveTitle() async {
    if (_task == null) return;
    final newTitle = _titleController.text.trim();
    if (newTitle.isNotEmpty && newTitle != _task!.title) {
      await ref.read(taskActionsProvider.notifier).updateTask(
            id: _task!.id,
            title: newTitle,
          );
    }
    setState(() => _isEditingTitle = false);
  }

  Future<void> _saveNotes() async {
    if (_task == null) return;
    final newNotes = _notesController.text.trim();
    if (newNotes != (_task!.notes ?? '')) {
      await ref.read(taskActionsProvider.notifier).updateTask(
            id: _task!.id,
            notes: newNotes.isEmpty ? null : newNotes,
          );
    }
    setState(() => _isEditingNotes = false);
  }

  bool _hasUnsavedEdits(TaskEntity task) {
    final titleChanged = _isEditingTitle && _titleController.text.trim() != task.title;
    final notesChanged = _isEditingNotes && _notesController.text.trim() != (task.notes ?? '');
    return titleChanged || notesChanged;
  }

  Future<bool?> _showUnsavedChangesSheet(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppConstants.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Unsaved Changes', style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: AppConstants.space2),
            Text(
              'You have modified task details. Would you like to save before leaving?',
              style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                    color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppConstants.space4),
            ListTile(
              leading: const Icon(Icons.save_outlined),
              title: const Text('Save & Leave'),
              onTap: () async {
                await _saveTitle();
                await _saveNotes();
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
            appBar: AppBar(title: const Text('Task Details')),
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
              title: Text(
                task.projectName ?? 'Task Details',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert_rounded),
                  onPressed: () => _showTaskMenu(context, task),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.space4,
                vertical: AppConstants.space2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Hero Title Card (Crisp Surface + High Contrast Checkbox) ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppConstants.space4),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: OrbitCheckbox(
                            isChecked: task.isCompleted,
                            onChanged: (_) => ref
                                .read(taskActionsProvider.notifier)
                                .toggleCompleted(task.id, completed: !task.isCompleted),
                            borderColor: task.priority != TaskPriority.none
                                ? task.priority.colorFor(theme.brightness)
                                : colorScheme.primary,
                            checkColor: task.priority != TaskPriority.none
                                ? task.priority.colorFor(theme.brightness)
                                : colorScheme.primary,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: AppConstants.space3),
                        Expanded(
                          child: _isEditingTitle
                              ? TextField(
                                  controller: _titleController,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  textCapitalization: TextCapitalization.sentences,
                                  maxLines: null,
                                  autofocus: true,
                                  onEditingComplete: _saveTitle,
                                  onTapOutside: (_) => _saveTitle(),
                                )
                              : GestureDetector(
                                  onTap: () => setState(() => _isEditingTitle = true),
                                  child: Text(
                                    task.title,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: task.isCompleted
                                          ? colorScheme.onSurface.withValues(alpha: 0.5)
                                          : colorScheme.onSurface,
                                      decoration: task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppConstants.space4),

                  // ── Properties Surface Card (Instant Pickers) ────────────
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Due Date Property Row
                        _PropertyTile(
                          icon: Icons.calendar_today_rounded,
                          iconColor: task.isOverdue
                              ? colorScheme.error
                              : task.dueDate != null
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                          label: 'Due date',
                          valueText: task.dueDate != null
                              ? DateFormat('EEE, d MMM yyyy').format(task.dueDate!)
                              : 'No due date',
                          valueColor: task.isOverdue
                              ? colorScheme.error
                              : task.dueDate != null
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                          isAccent: task.dueDate != null,
                          onTap: () => _showInstantDatePicker(context, task),
                        ),
                        const Divider(height: 1, indent: 56),

                        // Priority Property Row
                        _PropertyTile(
                          icon: task.priority.icon,
                          iconColor: task.priority != TaskPriority.none
                              ? task.priority.colorFor(theme.brightness)
                              : colorScheme.onSurfaceVariant,
                          label: 'Priority',
                          valueText: task.priority != TaskPriority.none
                              ? task.priority.label
                              : 'No priority',
                          valueColor: task.priority != TaskPriority.none
                              ? task.priority.colorFor(theme.brightness)
                              : colorScheme.onSurfaceVariant,
                          isAccent: task.priority != TaskPriority.none,
                          onTap: () => _showInstantPriorityPicker(context, task),
                        ),
                        const Divider(height: 1, indent: 56),

                        // Project Property Row
                        _PropertyTile(
                          icon: Icons.folder_open_rounded,
                          iconColor: task.projectId != null
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          label: 'Project',
                          valueText: task.projectName ?? 'Inbox',
                          valueColor: task.projectId != null
                              ? colorScheme.onSurface
                              : colorScheme.onSurfaceVariant,
                          isAccent: task.projectId != null,
                          onTap: () => _showInstantProjectPicker(context, task),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppConstants.space5),

                  // ── Notes Card ───────────────────────────────────────────
                  Text(
                    'NOTES',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: AppConstants.space2),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppConstants.space3),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                      border: Border.all(
                        color: _isEditingNotes
                            ? colorScheme.primary
                            : colorScheme.outlineVariant.withValues(alpha: 0.4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _isEditingNotes
                        ? TextField(
                            controller: _notesController,
                            maxLines: null,
                            minLines: 3,
                            style: theme.textTheme.bodyMedium,
                            decoration: const InputDecoration(
                              hintText: 'Add extra context, links, or instructions…',
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            autofocus: true,
                            onTapOutside: (_) => _saveNotes(),
                          )
                        : GestureDetector(
                            onTap: () => setState(() => _isEditingNotes = true),
                            child: Text(
                              task.notes?.isNotEmpty == true
                                  ? task.notes!
                                  : 'Tap to add notes…',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: task.notes?.isNotEmpty == true
                                    ? colorScheme.onSurface
                                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                  ),

                  const SizedBox(height: AppConstants.space5),

                  // ── Subtasks Card ─────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SUBTASKS',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                        ),
                      ),
                      if (task.hasSubtasks)
                        Text(
                          '${task.completedSubtaskCount}/${task.subtasks.length}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.space2),

                  if (task.hasSubtasks) ...[
                    // Subtask Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: task.completedSubtaskCount / task.subtasks.length,
                        minHeight: 6,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                      ),
                    ),
                    const SizedBox(height: AppConstants.space3),

                    // Subtask List
                    ...task.subtasks.map((subtask) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppConstants.space2),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                          ),
                        ),
                        child: ListTile(
                          dense: true,
                          leading: Checkbox(
                            value: subtask.isCompleted,
                            onChanged: (val) {
                              ref.read(taskRepositoryProvider).toggleSubtask(
                                    subtask.id,
                                    completed: val ?? false,
                                  );
                            },
                          ),
                          title: Text(
                            subtask.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              decoration: subtask.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: subtask.isCompleted
                                  ? colorScheme.onSurfaceVariant
                                  : colorScheme.onSurface,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () {
                              ref.read(taskRepositoryProvider).deleteSubtask(subtask.id);
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ],

                  // Inline Subtask Adder
                  Container(
                    margin: const EdgeInsets.only(top: AppConstants.space1),
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.space3),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add_rounded, color: colorScheme.primary, size: 20),
                        const SizedBox(width: AppConstants.space2),
                        Expanded(
                          child: TextField(
                            controller: _subtaskController,
                            decoration: const InputDecoration(
                              hintText: 'Add subtask…',
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            onSubmitted: (val) {
                              final text = val.trim();
                              if (text.isNotEmpty) {
                                ref
                                    .read(taskRepositoryProvider)
                                    .addSubtask(task.id, text);
                                _subtaskController.clear();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppConstants.space8),

                  // ── Metadata Footer ───────────────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Created ${DateFormat('d MMM yyyy, HH:mm').format(task.createdAt)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          ),
                        ),
                        if (task.completedAt != null)
                          Text(
                            'Completed ${DateFormat('d MMM yyyy, HH:mm').format(task.completedAt!)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary.withValues(alpha: 0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.space6),
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

  // ── Instant Pickers (Overflow Proof) ──────────────────────────────────────

  /// Instant Date Picker Sheet with quick presets (Today, Tomorrow, Weekend, Custom).
  void _showInstantDatePicker(BuildContext context, TaskEntity task) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final weekend = today.add(Duration(days: (6 - today.weekday) % 7 + 1));
    final nextWeek = today.add(const Duration(days: 7));

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(ctx).size.height * 0.75,
        ),
        decoration: BoxDecoration(
          color: Theme.of(ctx).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.fromLTRB(
          AppConstants.space4,
          AppConstants.space3,
          AppConstants.space4,
          MediaQuery.of(ctx).padding.bottom + AppConstants.space4,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(ctx).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.space3),
              Text('Set Due Date', style: Theme.of(ctx).textTheme.titleMedium),
              const SizedBox(height: AppConstants.space4),

              ListTile(
                leading: const Icon(Icons.wb_sunny_outlined, color: Colors.orange),
                title: const Text('Today'),
                subtitle: Text(DateFormat('EEE, d MMM').format(today)),
                onTap: () => _applyDueDate(today, ctx),
              ),
              ListTile(
                leading: const Icon(Icons.wb_twilight_rounded, color: Colors.indigo),
                title: const Text('Tomorrow'),
                subtitle: Text(DateFormat('EEE, d MMM').format(tomorrow)),
                onTap: () => _applyDueDate(tomorrow, ctx),
              ),
              ListTile(
                leading: const Icon(Icons.weekend_outlined, color: Colors.teal),
                title: const Text('This Weekend'),
                subtitle: Text(DateFormat('EEE, d MMM').format(weekend)),
                onTap: () => _applyDueDate(weekend, ctx),
              ),
              ListTile(
                leading: const Icon(Icons.next_week_outlined, color: Colors.purple),
                title: const Text('Next Week'),
                subtitle: Text(DateFormat('EEE, d MMM').format(nextWeek)),
                onTap: () => _applyDueDate(nextWeek, ctx),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.calendar_month_rounded),
                title: const Text('Pick Custom Date…'),
                onTap: () async {
                  Navigator.pop(ctx);
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
                    setState(() {});
                  }
                },
              ),
              if (task.dueDate != null)
                ListTile(
                  leading: const Icon(Icons.clear_rounded, color: Colors.red),
                  title: const Text('Remove Due Date', style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await ref.read(taskActionsProvider.notifier).updateTask(
                          id: task.id,
                          clearDueDate: true,
                        );
                    setState(() {});
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _applyDueDate(DateTime date, BuildContext sheetContext) async {
    Navigator.pop(sheetContext);
    await ref.read(taskActionsProvider.notifier).updateTask(
          id: widget.taskId,
          dueDate: date,
        );
    if (mounted) setState(() {});
  }

  /// Instant Priority Picker Sheet.
  void _showInstantPriorityPicker(BuildContext context, TaskEntity task) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(ctx).size.height * 0.75,
        ),
        decoration: BoxDecoration(
          color: Theme.of(ctx).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.fromLTRB(
          AppConstants.space4,
          AppConstants.space3,
          AppConstants.space4,
          MediaQuery.of(ctx).padding.bottom + AppConstants.space4,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(ctx).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.space3),
              Text('Set Priority', style: Theme.of(ctx).textTheme.titleMedium),
              const SizedBox(height: AppConstants.space4),
              ...TaskPriority.values.map((p) {
                final color = p == TaskPriority.none
                    ? Theme.of(ctx).colorScheme.onSurfaceVariant
                    : p.colorFor(Theme.of(ctx).brightness);
                final isSelected = task.priority == p;

                return ListTile(
                  leading: Icon(p.icon, color: color),
                  title: Text(p.label),
                  trailing: isSelected
                      ? Icon(Icons.check_rounded, color: Theme.of(ctx).colorScheme.primary)
                      : null,
                  onTap: () async {
                    Navigator.pop(ctx);
                    await ref.read(taskActionsProvider.notifier).updateTask(
                          id: task.id,
                          priority: p.value,
                        );
                    if (mounted) setState(() {});
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  /// Instant Project Picker Sheet (Overflow Safe).
  void _showInstantProjectPicker(BuildContext context, TaskEntity task) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Consumer(
        builder: (context, ref, _) {
          final projectsAsync = ref.watch(projectsProvider);

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.75,
            ),
            decoration: BoxDecoration(
              color: Theme.of(ctx).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: EdgeInsets.fromLTRB(
              AppConstants.space4,
              AppConstants.space3,
              AppConstants.space4,
              MediaQuery.of(ctx).padding.bottom + AppConstants.space4,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(ctx).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.space3),
                  Text('Move to Project', style: Theme.of(ctx).textTheme.titleMedium),
                  const SizedBox(height: AppConstants.space4),

                  // Inbox Option
                  ListTile(
                    leading: const Icon(Icons.inbox_rounded),
                    title: const Text('Inbox'),
                    trailing: task.projectId == null
                        ? Icon(Icons.check_rounded, color: Theme.of(ctx).colorScheme.primary)
                        : null,
                    onTap: () async {
                      Navigator.pop(ctx);
                      await ref.read(taskActionsProvider.notifier).updateTask(
                            id: task.id,
                            clearProject: true,
                          );
                      if (mounted) setState(() {});
                    },
                  ),
                  const Divider(),

                  // User Projects
                  projectsAsync.when(
                    data: (projects) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: projects.map((proj) {
                        final isSelected = task.projectId == proj.id;
                        final projColor = _parseColor(proj.colorHex);

                        return ListTile(
                          leading: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: projColor,
                            ),
                            child: Icon(
                              _parseIcon(proj.icon),
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(proj.name),
                          trailing: isSelected
                              ? Icon(Icons.check_rounded, color: Theme.of(ctx).colorScheme.primary)
                              : null,
                          onTap: () async {
                            Navigator.pop(ctx);
                            await ref.read(taskActionsProvider.notifier).updateTask(
                                  id: task.id,
                                  projectId: proj.id,
                                );
                            if (mounted) setState(() {});
                          },
                        );
                      }).toList(),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const SizedBox(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showTaskMenu(BuildContext context, TaskEntity task) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
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

  Color _parseColor(String hex) {
    final clean = hex.replaceFirst('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }

  IconData _parseIcon(String name) => switch (name) {
        'work' => Icons.work_outline_rounded,
        'home' => Icons.home_outlined,
        'star' => Icons.star_outline_rounded,
        'shopping' => Icons.shopping_bag_outlined,
        'fitness' => Icons.fitness_center_rounded,
        _ => Icons.folder_outlined,
      };
}

class _PropertyTile extends StatelessWidget {
  const _PropertyTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.valueText,
    required this.valueColor,
    required this.isAccent,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String valueText;
  final Color valueColor;
  final bool isAccent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.space4,
          vertical: AppConstants.space3,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: AppConstants.space3),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const Spacer(),
            Text(
              valueText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: isAccent ? FontWeight.w700 : FontWeight.w500,
                    color: valueColor,
                  ),
            ),
            const SizedBox(width: AppConstants.space1),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
