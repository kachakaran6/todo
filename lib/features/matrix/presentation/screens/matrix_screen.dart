import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:orbit_todo/core/constants/app_constants.dart';
import 'package:orbit_todo/core/widgets/orbit_checkbox.dart';
import 'package:orbit_todo/features/tasks/application/tasks_provider.dart';
import 'package:orbit_todo/features/tasks/domain/task_entity.dart';
import 'package:orbit_todo/features/tasks/domain/task_priority.dart';

/// Eisenhower Priority Matrix Screen.
/// Categorizes tasks into 4 productivity quadrants:
/// - Quadrant I: Urgent & Important (Red)
/// - Quadrant II: Not Urgent & Important (Orange)
/// - Quadrant III: Urgent & Unimportant (Blue)
/// - Quadrant IV: Not Urgent & Unimportant (Teal)
class MatrixScreen extends ConsumerStatefulWidget {
  const MatrixScreen({super.key});

  @override
  ConsumerState<MatrixScreen> createState() => _MatrixScreenState();
}

class _MatrixScreenState extends ConsumerState<MatrixScreen> {
  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(allActiveTasksProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Priority Matrix'),
            Text(
              'Eisenhower 4-Quadrant Categorization',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: tasksAsync.when(
        data: (tasks) {
          // Categorize tasks into 4 quadrants
          final q1Tasks = tasks.where((t) => t.priority == TaskPriority.urgent).toList();
          final q2Tasks = tasks.where((t) => t.priority == TaskPriority.high).toList();
          final q3Tasks = tasks.where((t) => t.priority == TaskPriority.medium).toList();
          final q4Tasks = tasks.where((t) => t.priority == TaskPriority.low || t.priority == TaskPriority.none).toList();

          return Column(
            children: [
              // Hero Summary Banner
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(
                  AppConstants.space4,
                  AppConstants.space2,
                  AppConstants.space4,
                  AppConstants.space2,
                ),
                padding: const EdgeInsets.all(AppConstants.space3),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: colorScheme.primaryContainer,
                      radius: 20,
                      child: Icon(Icons.grid_view_rounded, color: colorScheme.primary, size: 20),
                    ),
                    const SizedBox(width: AppConstants.space3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Focus Grid Summary',
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${tasks.length} active tasks sorted by urgency & impact',
                            style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 4 Quadrants Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.space3),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppConstants.space3,
                    mainAxisSpacing: AppConstants.space3,
                    childAspectRatio: 0.8,
                    children: [
                      // Quadrant I: Urgent & Important
                      _QuadrantCard(
                        quadrantId: 'I',
                        title: 'Urgent & Important',
                        badgeColor: const Color(0xFFE53935),
                        tasks: q1Tasks,
                        priorityValue: TaskPriority.urgent.value,
                        onTaskTap: (taskId) => context.push('/task/$taskId'),
                      ),

                      // Quadrant II: Not Urgent & Important
                      _QuadrantCard(
                        quadrantId: 'II',
                        title: 'Not Urgent & Important',
                        badgeColor: const Color(0xFFFB8C00),
                        tasks: q2Tasks,
                        priorityValue: TaskPriority.high.value,
                        onTaskTap: (taskId) => context.push('/task/$taskId'),
                      ),

                      // Quadrant III: Urgent & Unimportant
                      _QuadrantCard(
                        quadrantId: 'III',
                        title: 'Urgent & Unimportant',
                        badgeColor: const Color(0xFF1E88E5),
                        tasks: q3Tasks,
                        priorityValue: TaskPriority.medium.value,
                        onTaskTap: (taskId) => context.push('/task/$taskId'),
                      ),

                      // Quadrant IV: Not Urgent & Unimportant
                      _QuadrantCard(
                        quadrantId: 'IV',
                        title: 'Not Urgent & Unimportant',
                        badgeColor: const Color(0xFF00897B),
                        tasks: q4Tasks,
                        priorityValue: TaskPriority.low.value,
                        onTaskTap: (taskId) => context.push('/task/$taskId'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _QuadrantCard extends ConsumerWidget {
  const _QuadrantCard({
    required this.quadrantId,
    required this.title,
    required this.badgeColor,
    required this.tasks,
    required this.priorityValue,
    required this.onTaskTap,
  });

  final String quadrantId;
  final String title;
  final Color badgeColor;
  final List<TaskEntity> tasks;
  final int priorityValue;
  final ValueChanged<String> onTaskTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textController = TextEditingController();

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppConstants.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quadrant Header
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    quadrantId,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: badgeColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.space2),
          const Divider(height: 1),

          // Quadrant Task Items
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Text(
                      'No tasks',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (ctx, idx) {
                      final task = tasks[idx];
                      return InkWell(
                        onTap: () => onTaskTap(task.id),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              OrbitCheckbox(
                                isChecked: task.isCompleted,
                                size: 18,
                                borderColor: badgeColor,
                                checkColor: badgeColor,
                                onChanged: (_) {
                                  ref
                                      .read(taskActionsProvider.notifier)
                                      .toggleCompleted(task.id, completed: !task.isCompleted);
                                },
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: task.isCompleted
                                        ? colorScheme.onSurfaceVariant
                                        : colorScheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Add Task to Quadrant
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Add to Quadrant $quadrantId'),
                  content: TextField(
                    controller: textController,
                    autofocus: true,
                    decoration: const InputDecoration(hintText: 'Task title…'),
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        ref.read(taskActionsProvider.notifier).createTask(
                              title: val.trim(),
                              priority: priorityValue,
                            );
                        Navigator.pop(ctx);
                      }
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () {
                        if (textController.text.trim().isNotEmpty) {
                          ref.read(taskActionsProvider.notifier).createTask(
                                title: textController.text.trim(),
                                priority: priorityValue,
                              );
                          Navigator.pop(ctx);
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded, size: 16, color: badgeColor),
                  const SizedBox(width: 4),
                  Text(
                    'Add task',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: badgeColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
