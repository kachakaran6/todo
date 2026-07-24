import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:orbit_todo/core/constants/app_constants.dart';
import 'package:orbit_todo/features/tasks/application/tasks_provider.dart';
import 'package:orbit_todo/features/tasks/presentation/widgets/task_tile.dart';
import 'package:orbit_todo/core/widgets/empty_state.dart';

/// Agenda-first Upcoming & Calendar screen (PRD Section 5.1).
class UpcomingScreen extends ConsumerStatefulWidget {
  const UpcomingScreen({super.key});

  @override
  ConsumerState<UpcomingScreen> createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends ConsumerState<UpcomingScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(allActiveTasksProvider);
    final actions = ref.read(taskActionsProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final dates = List.generate(
      14,
      (i) => DateTime.now().add(Duration(days: i - 2)),
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Upcoming Calendar'),
            Text(
              '14-Day Horizon & Daily Agenda',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.today_rounded),
            tooltip: 'Go to Today',
            onPressed: () => setState(() => _selectedDate = DateTime.now()),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Horizon Day Strip Selector
          Container(
            height: 80,
            padding: EdgeInsets.symmetric(vertical: AppConstants.space2),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppConstants.space3),
              itemCount: dates.length,
              itemBuilder: (ctx, idx) {
                final date = dates[idx];
                final isSelected = DateUtils.isSameDay(date, _selectedDate);
                final isToday = DateUtils.isSameDay(date, DateTime.now());

                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = date),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 54,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : isToday
                              ? colorScheme.primaryContainer.withValues(alpha: 0.5)
                              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? colorScheme.primary : Colors.transparent,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEE').format(date).toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${date.day}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),

          // Agenda Task List for Selected Day
          Expanded(
            child: tasksAsync.when(
              data: (tasks) {
                final dayTasks = tasks.where((t) {
                  if (t.dueDate == null) return false;
                  return DateUtils.isSameDay(t.dueDate, _selectedDate);
                }).toList();

                if (dayTasks.isEmpty) {
                  return const EmptyStateWidget(
                    headline: 'No tasks scheduled',
                    body: 'Your agenda for this day is clear.',
                    icon: Icons.event_available_rounded,
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.all(AppConstants.space4),
                  itemCount: dayTasks.length,
                  separatorBuilder: (_, __) => SizedBox(height: AppConstants.space2),
                  itemBuilder: (ctx, idx) {
                    final task = dayTasks[idx];
                    return TaskTile(
                      task: task,
                      onComplete: () => actions.toggleCompleted(task.id, completed: !task.isCompleted),
                      onArchive: () => actions.archiveTask(task.id),
                      onTap: () => context.push('/task/${task.id}'),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
