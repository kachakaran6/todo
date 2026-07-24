import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/motion.dart';
import '../../../../core/widgets/orbit_checkbox.dart';
import '../../../../core/widgets/priority_badge.dart';
import '../../domain/task_entity.dart';
import '../../domain/task_priority.dart';

/// The primary task list item widget.
///
/// Features:
/// - Animated completion with strike-through text
/// - Swipe-to-complete (left) and swipe-to-archive (right)
/// - Priority badge, due date, tag chips, subtask progress
/// - Density-aware layout (compact / comfortable / spacious)
/// - Full accessibility with semantic labels
class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onComplete,
    required this.onArchive,
    required this.onTap,
    this.density = TaskDensity.comfortable,
    this.showProject = false,
  });

  final TaskEntity task;
  final VoidCallback onComplete;
  final VoidCallback onArchive;
  final VoidCallback onTap;
  final TaskDensity density;
  final bool showProject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Padding based on density
    final vPad = density.verticalPadding;

    return Semantics(
      label: '${task.title}. ${task.isCompleted ? "Completed." : ""}${task.priority != TaskPriority.none ? "${task.priority.label} priority." : ""}${task.isOverdue ? "Overdue." : ""}',
      button: false,
      child: Dismissible(
        key: ValueKey('task_${task.id}'),
        background: _buildSwipeBackground(
          context,
          color: colorScheme.primary,
          icon: Icons.check_rounded,
          label: 'Complete',
          alignment: Alignment.centerLeft,
        ),
        secondaryBackground: _buildSwipeBackground(
          context,
          color: colorScheme.tertiary,
          icon: Icons.archive_outlined,
          label: 'Archive',
          alignment: Alignment.centerRight,
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            onComplete();
          } else {
            onArchive();
          }
          return false; // Don't actually dismiss — we handle state
        },
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppConstants.space3,
            vertical: AppConstants.space1,
          ),
          decoration: BoxDecoration(
            color: task.isCompleted
                ? colorScheme.surfaceContainerLowest.withValues(alpha: 0.5)
                : colorScheme.surfaceContainerLow.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            border: Border.all(
              color: task.isCompleted
                  ? Colors.transparent
                  : colorScheme.outlineVariant.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.space3,
                vertical: vPad,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: OrbitCheckbox(
                      isChecked: task.isCompleted,
                      onChanged: (_) => onComplete(),
                      borderColor: task.priority != TaskPriority.none
                          ? task.priority.colorFor(theme.brightness)
                          : null,
                      checkColor: task.priority != TaskPriority.none
                          ? task.priority.colorFor(theme.brightness)
                          : null,
                      semanticLabel: task.isCompleted
                          ? 'Mark ${task.title} incomplete'
                          : 'Complete ${task.title}',
                    ),
                  ),
                  const SizedBox(width: AppConstants.space3),

                  // Main content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _TaskTitle(
                                title: task.title,
                                isCompleted: task.isCompleted,
                              ),
                            ),
                            if (task.priority != TaskPriority.none) ...[
                              const SizedBox(width: AppConstants.space2),
                              PriorityBadge(priority: task.priority),
                            ],
                          ],
                        ),

                        // Meta row (due date, project, subtask progress, tags)
                        if (_hasMetaInfo(task)) ...[
                          const SizedBox(height: AppConstants.space1),
                          _MetaRow(task: task, showProject: showProject),
                        ],

                        // Subtask progress bar
                        if (task.hasSubtasks && density != TaskDensity.compact) ...[
                          const SizedBox(height: AppConstants.space2),
                          _SubtaskProgress(task: task),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _hasMetaInfo(TaskEntity task) {
    return task.hasDueDate ||
        (task.projectId != null && showProject) ||
        task.hasTags;
  }

  Widget _buildSwipeBackground(
    BuildContext context, {
    required Color color,
    required IconData icon,
    required String label,
    required Alignment alignment,
  }) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.space6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Task title with animated strike-through on completion
// ──────────────────────────────────────────────────────────────────────────

class _TaskTitle extends StatelessWidget {
  const _TaskTitle({required this.title, required this.isCompleted});

  final String title;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedDefaultTextStyle(
      duration: OrbitMotion.standard,
      curve: Curves.easeOut,
      style: theme.textTheme.bodyLarge!.copyWith(
        color: isCompleted
            ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
            : colorScheme.onSurface,
        decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
        decorationColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        decorationThickness: 1.5,
      ),
      child: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Meta information row (due date, project, tags)
// ──────────────────────────────────────────────────────────────────────────

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.task, required this.showProject});

  final TaskEntity task;
  final bool showProject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final items = <Widget>[];

    // Due date chip
    if (task.hasDueDate) {
      final color = task.isOverdue
          ? OrbitColorTokens.priorityUrgent
          : task.isDueToday
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant;

      final icon = task.isOverdue
          ? Icons.warning_amber_rounded
          : task.isDueToday
              ? Icons.today_rounded
              : Icons.calendar_today_rounded;

      items.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 3,
          children: [
            Icon(icon, size: 12, color: color),
            Text(
              _formatDate(task.dueDate!),
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: task.isOverdue || task.isDueToday
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    // Project chip
    if (showProject && task.projectId != null && task.projectName != null) {
      Color projectColor = colorScheme.onSurfaceVariant;
      if (task.projectColor != null) {
        try {
          final hex = task.projectColor!.replaceAll('#', '');
          projectColor = Color(int.parse('FF$hex', radix: 16));
        } catch (_) {}
      }

      items.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 3,
          children: [
            Icon(Icons.circle, size: 8, color: projectColor),
            Text(
              task.projectName!,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    // Tag chips (max 2)
    for (final tag in task.tags.take(2)) {
      items.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppConstants.radiusSM),
          ),
          child: Text(
            tag.name,
            style: TextStyle(
              fontSize: 11,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppConstants.space3,
      runSpacing: AppConstants.space1,
      children: items,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    if (diff < 0) return '${diff.abs()}d overdue';
    if (diff < 7) return DateFormat('EEEE').format(date); // "Monday"
    return DateFormat('d MMM').format(date); // "14 Jan"
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Subtask progress indicator
// ──────────────────────────────────────────────────────────────────────────

class _SubtaskProgress extends StatelessWidget {
  const _SubtaskProgress({required this.task});
  final TaskEntity task;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      spacing: AppConstants.space2,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusXS),
            child: LinearProgressIndicator(
              value: task.subtaskProgress,
              backgroundColor: colorScheme.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation<Color>(
                task.subtaskProgress == 1.0
                    ? colorScheme.primary
                    : colorScheme.primary.withValues(alpha: 0.7),
              ),
              minHeight: 3,
            ),
          ),
        ),
        Text(
          '${task.completedSubtaskCount}/${task.subtaskCount}',
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
