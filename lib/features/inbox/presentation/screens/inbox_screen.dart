import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:orbit_todo/core/constants/app_constants.dart';
import 'package:orbit_todo/core/widgets/empty_state.dart';
import 'package:orbit_todo/features/tasks/application/tasks_provider.dart';
import 'package:orbit_todo/features/tasks/domain/task_entity.dart';
import 'package:orbit_todo/features/tasks/presentation/widgets/task_tile.dart';
import 'package:orbit_todo/features/tasks/presentation/widgets/task_quick_add.dart';

/// Inbox screen — rapid capture for unprocessed tasks.
///
/// Shows all tasks not assigned to a project.
/// Swipe left → complete, swipe right → archive.
/// Tap → opens task detail.
class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(inboxTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search',
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: tasksAsync.when(
        data: (tasks) => _InboxContent(tasks: tasks),
        loading: () => const _TaskListSkeleton(),
        error: (err, _) => _ErrorState(message: err.toString()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showQuickAdd(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add task'),
        heroTag: 'inbox_fab',
      ),
    );
  }
}

class _InboxContent extends ConsumerWidget {
  const _InboxContent({required this.tasks});
  final List<TaskEntity> tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (tasks.isEmpty) {
      return InboxEmptyState(onAdd: () => showQuickAdd(context));
    }

    final actions = ref.read(taskActionsProvider.notifier);

    return ListView.builder(
      padding: const EdgeInsets.only(
        top: AppConstants.space2,
        bottom: 100, // Above FAB
      ),
      itemCount: tasks.length,
      itemBuilder: (context, i) {
        final task = tasks[i];
        return TaskTile(
          key: ValueKey(task.id),
          task: task,
          onComplete: () async {
            await actions.toggleCompleted(task.id, completed: !task.isCompleted);
            if (context.mounted) {
              _showUndoSnack(context, ref, task, !task.isCompleted);
            }
          },
          onArchive: () async {
            await actions.archiveTask(task.id);
            if (context.mounted) {
              _showArchiveUndoSnack(context, ref, task.id);
            }
          },
          onTap: () => context.push('/task/${task.id}'),
        )
            .animate()
            .fadeIn(delay: Duration(milliseconds: i * 30), duration: 200.ms)
            .slideY(begin: 0.05, end: 0, duration: 200.ms);
      },
    );
  }

  void _showUndoSnack(
    BuildContext context,
    WidgetRef ref,
    TaskEntity task,
    bool nowCompleted,
  ) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(nowCompleted ? '"${task.title}" completed' : '"${task.title}" reopened'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ref.read(taskActionsProvider.notifier).toggleCompleted(
                  task.id,
                  completed: !nowCompleted,
                );
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showArchiveUndoSnack(BuildContext context, WidgetRef ref, String taskId) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task archived'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ref.read(taskActionsProvider.notifier).restoreTask(taskId);
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Loading skeleton
// ──────────────────────────────────────────────────────────────────────────

class _TaskListSkeleton extends StatelessWidget {
  const _TaskListSkeleton();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListView.builder(
      itemCount: 7,
      padding: const EdgeInsets.symmetric(vertical: AppConstants.space2),
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.space4,
          vertical: AppConstants.space2,
        ),
        child: Row(
          children: [
            // Checkbox placeholder
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surfaceContainerHigh,
              ),
            ),
            const SizedBox(width: AppConstants.space3),
            // Text placeholder
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(AppConstants.radiusXS),
                    ),
                  ),
                  if (i % 2 == 0) ...[
                    const SizedBox(height: 6),
                    Container(
                      height: 10,
                      width: 80,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(AppConstants.radiusXS),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      )
          .animate(onPlay: (c) => c.repeat())
          .shimmer(duration: 1200.ms, color: colorScheme.surfaceContainer),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.space8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppConstants.space4),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppConstants.space2),
            Text(
              'Please restart the app if the problem persists.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
