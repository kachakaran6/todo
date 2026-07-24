import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:orbit_todo/core/constants/app_constants.dart';
import 'package:orbit_todo/core/widgets/empty_state.dart';
import 'package:orbit_todo/core/widgets/quick_theme_sheet.dart';
import 'package:orbit_todo/features/tasks/application/tasks_provider.dart';
import 'package:orbit_todo/features/tasks/domain/task_entity.dart';
import 'package:orbit_todo/features/tasks/presentation/widgets/task_tile.dart';
import 'package:orbit_todo/features/tasks/presentation/widgets/task_quick_add.dart';

/// Today screen — shows overdue, due today tasks.
///
/// Header: date + completion count.
/// Groups: Overdue → Due Today.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(todayTasksProvider);
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Today'),
            Text(
              DateFormat('EEEE, d MMMM').format(now),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Theme & Accent',
            onPressed: () => showQuickThemeSheet(context),
          ),
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
        data: (tasks) => _TodayContent(tasks: tasks),
        loading: () => const _TaskListSkeleton(),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showQuickAdd(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add task'),
        heroTag: 'today_fab',
      ),
    );
  }
}

class _TodayContent extends ConsumerStatefulWidget {
  const _TodayContent({required this.tasks});
  final List<TaskEntity> tasks;

  @override
  ConsumerState<_TodayContent> createState() => _TodayContentState();
}

class _TodayContentState extends ConsumerState<_TodayContent> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.tasks.isEmpty) {
      return const TodayEmptyState();
    }

    // Split into groups
    final overdue = widget.tasks.where((t) => t.isOverdue && !t.isCompleted).toList();
    final dueToday = widget.tasks.where((t) => t.isDueToday && !t.isCompleted).toList();
    final completed = widget.tasks.where((t) => t.isCompleted).toList();

    final completedCount = completed.length;
    final totalCount = widget.tasks.length;

    return CustomScrollView(
      slivers: [
        // Completion progress header
        if (totalCount > 0)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.space4,
                AppConstants.space4,
                AppConstants.space4,
                AppConstants.space2,
              ),
              child: _CompletionHeader(
                completed: completedCount,
                total: totalCount,
              ),
            ),
          ),

        // Overdue section
        if (overdue.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: _SectionHeader(
              label: 'Overdue',
              icon: Icons.schedule_rounded,
              color: colorScheme.error,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _buildTaskTile(overdue[i], i),
              childCount: overdue.length,
            ),
          ),
        ],

        // Today section
        if (dueToday.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: _SectionHeader(
              label: 'Today',
              icon: Icons.wb_sunny_outlined,
              color: colorScheme.primary,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _buildTaskTile(dueToday[i], i + overdue.length),
              childCount: dueToday.length,
            ),
          ),
        ],

        // Completed section (collapsed by default)
        if (completed.isNotEmpty)
          SliverToBoxAdapter(
            child: _CollapsibleCompleted(tasks: completed),
          ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 100), // FAB clearance
        ),
      ],
    );
  }

  Widget _buildTaskTile(TaskEntity task, int index) {
    final actions = ref.read(taskActionsProvider.notifier);
    return TaskTile(
      key: ValueKey(task.id),
      task: task,
      onComplete: () async {
        await actions.toggleCompleted(task.id, completed: !task.isCompleted);
        if (mounted) _showUndoSnack(task, !task.isCompleted);
      },
      onArchive: () async {
        await actions.archiveTask(task.id);
        if (mounted) _showArchiveUndoSnack(task.id);
      },
      onTap: () => context.push('/task/${task.id}'),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: index * 30), duration: 200.ms)
        .slideY(begin: 0.05, end: 0, duration: 200.ms);
  }

  void _showUndoSnack(TaskEntity task, bool nowCompleted) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(nowCompleted ? '✓ "${task.title}" completed' : '"${task.title}" reopened'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => ref.read(taskActionsProvider.notifier)
              .toggleCompleted(task.id, completed: !nowCompleted),
        ),
      ),
    );
  }

  void _showArchiveUndoSnack(String taskId) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task archived'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => ref.read(taskActionsProvider.notifier).restoreTask(taskId),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Completion progress header
// ──────────────────────────────────────────────────────────────────────────

class _CompletionHeader extends StatelessWidget {
  const _CompletionHeader({required this.completed, required this.total});
  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = total > 0 ? completed / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$completed of $total done',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const Spacer(),
            if (completed == total && total > 0)
              Text(
                '🎉 All done!',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
          ],
        ),
        const SizedBox(height: AppConstants.space2),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusXS),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: colorScheme.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Section header
// ──────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.space4,
        AppConstants.space4,
        AppConstants.space4,
        AppConstants.space1,
      ),
      child: Row(
        spacing: AppConstants.space2,
        children: [
          Icon(icon, size: 14, color: color),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Collapsible completed tasks
// ──────────────────────────────────────────────────────────────────────────

class _CollapsibleCompleted extends ConsumerStatefulWidget {
  const _CollapsibleCompleted({required this.tasks});
  final List<TaskEntity> tasks;

  @override
  ConsumerState<_CollapsibleCompleted> createState() =>
      _CollapsibleCompletedState();
}

class _CollapsibleCompletedState extends ConsumerState<_CollapsibleCompleted> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          dense: true,
          leading: Icon(
            _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
          title: Text(
            'Completed (${widget.tasks.length})',
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () => setState(() => _expanded = !_expanded),
        ),
        AnimatedSize(
          duration: 250.ms,
          curve: Curves.easeInOut,
          child: _expanded
              ? Column(
                  children: widget.tasks
                      .map(
                        (task) => TaskTile(
                          key: ValueKey(task.id),
                          task: task,
                          onComplete: () => ref
                              .read(taskActionsProvider.notifier)
                              .toggleCompleted(task.id, completed: false),
                          onArchive: () => ref
                              .read(taskActionsProvider.notifier)
                              .archiveTask(task.id),
                          onTap: () => context.push('/task/${task.id}'),
                        ),
                      )
                      .toList(),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// Loading skeleton reused from inbox
class _TaskListSkeleton extends StatelessWidget {
  const _TaskListSkeleton();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.symmetric(vertical: AppConstants.space4),
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.space4,
          vertical: AppConstants.space2,
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surfaceContainerHigh,
              ),
            ),
            const SizedBox(width: AppConstants.space3),
            Expanded(
              child: Container(
                height: 14,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppConstants.radiusXS),
                ),
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
