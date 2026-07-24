import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:orbit_todo/core/constants/app_constants.dart';
import 'package:orbit_todo/core/widgets/empty_state.dart';
import 'package:orbit_todo/features/tasks/application/tasks_provider.dart';
import 'package:orbit_todo/features/tasks/domain/task_entity.dart';
import 'package:orbit_todo/features/tasks/presentation/widgets/task_tile.dart';

/// Completed / Archive screen — history of all completed tasks.
class CompletedScreen extends ConsumerWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(completedTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear all completed',
            onPressed: () => _confirmClearAll(context, ref),
          ),
        ],
      ),
      body: tasksAsync.when(
        data: (tasks) {
          if (tasks.isEmpty) return const CompletedEmptyState();

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: AppConstants.space8),
            itemCount: tasks.length,
            itemBuilder: (ctx, i) {
              final task = tasks[i];
              return _CompletedTaskTile(task: task)
                  .animate()
                  .fadeIn(delay: Duration(milliseconds: i * 20), duration: 200.ms);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _confirmClearAll(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear completed tasks?'),
        content: const Text(
          'This will permanently delete all completed tasks. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: Batch permanent delete
            },
            child: const Text('Delete all'),
          ),
        ],
      ),
    );
  }
}

class _CompletedTaskTile extends ConsumerWidget {
  const _CompletedTaskTile({required this.task});
  final TaskEntity task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Dismissible(
      key: ValueKey('completed_${task.id}'),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.space6),
        color: colorScheme.primary.withOpacity(0.1),
        child: Row(
          children: [
            Icon(Icons.restore_rounded, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Restore',
              style: TextStyle(
                  color: colorScheme.primary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.space6),
        color: colorScheme.error.withOpacity(0.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Delete',
              style: TextStyle(
                  color: colorScheme.error, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            Icon(Icons.delete_outline_rounded, color: colorScheme.error),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await ref.read(taskActionsProvider.notifier).restoreTask(task.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task restored')),
            );
          }
        } else {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Delete permanently?'),
              content: Text('"${task.title}" will be deleted forever.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                  ),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
          if (confirmed == true) {
            await ref
                .read(taskActionsProvider.notifier)
                .permanentlyDeleteTask(task.id);
          }
        }
        return false; // We handle UI reactivity via stream
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.space4,
          vertical: AppConstants.space1,
        ),
        leading: Icon(
          Icons.check_circle_rounded,
          color: colorScheme.primary.withOpacity(0.6),
        ),
        title: Text(
          task.title,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
            decoration: TextDecoration.lineThrough,
            decorationColor: colorScheme.onSurface.withOpacity(0.3),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: task.completedAt != null
            ? Text(
                _formatDate(task.completedAt!),
                style: theme.textTheme.bodySmall,
              )
            : null,
        onTap: () => context.push('/task/${task.id}'),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt).inDays;
    if (diff == 0) return 'Completed today';
    if (diff == 1) return 'Completed yesterday';
    return 'Completed ${diff}d ago';
  }
}
