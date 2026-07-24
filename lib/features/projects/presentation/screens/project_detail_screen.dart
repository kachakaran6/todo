import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:orbit_todo/core/constants/app_constants.dart';
import 'package:orbit_todo/core/widgets/empty_state.dart';
import 'package:orbit_todo/features/projects/application/projects_provider.dart';
import 'package:orbit_todo/features/tasks/application/tasks_provider.dart';
import 'package:orbit_todo/features/tasks/domain/task_entity.dart';
import 'package:orbit_todo/features/tasks/presentation/widgets/task_tile.dart';
import 'package:orbit_todo/features/tasks/presentation/widgets/task_quick_add.dart';

/// Project detail screen — shows all tasks in a project.
class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(
      projectsProvider.select(
        (async) => async.whenData(
          (projects) => projects.where((p) => p.id == projectId).firstOrNull,
        ),
      ),
    );
    final tasksAsync = ref.watch(projectTasksProvider(projectId));

    return Scaffold(
      body: projectAsync.when(
        data: (project) {
          if (project == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Project')),
              body: const Center(child: Text('Project not found')),
            );
          }

          return CustomScrollView(
            slivers: [
              // Colored app bar
              SliverAppBar(
                expandedHeight: 120,
                pinned: true,
                backgroundColor: project.color.withOpacity(0.1),
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => context.pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    project.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.more_vert_rounded),
                    onPressed: () => _showMenu(context, ref),
                  ),
                ],
              ),

              // Task list
              tasksAsync.when(
                data: (tasks) {
                  if (tasks.isEmpty) {
                    return SliverFillRemaining(
                      child: ProjectEmptyState(
                        onAdd: () => showQuickAdd(context),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) {
                        final task = tasks[i];
                        return TaskTile(
                          key: ValueKey(task.id),
                          task: task,
                          onComplete: () => ref
                              .read(taskActionsProvider.notifier)
                              .toggleCompleted(task.id, completed: !task.isCompleted),
                          onArchive: () => ref
                              .read(taskActionsProvider.notifier)
                              .archiveTask(task.id),
                          onTap: () => context.push('/task/${task.id}'),
                        )
                            .animate()
                            .fadeIn(delay: Duration(milliseconds: i * 30), duration: 200.ms);
                      },
                      childCount: tasks.length,
                    ),
                  );
                },
                loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, _) => SliverFillRemaining(
                  child: Center(child: Text('Error: $err')),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showQuickAdd(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add task'),
        heroTag: 'project_detail_fab',
      ),
    );
  }

  void _showMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppConstants.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit project'),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: Icon(Icons.archive_outlined,
                  color: Theme.of(context).colorScheme.error),
              title: Text('Archive project',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error)),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(projectActionsProvider.notifier).archiveProject(projectId);
                context.pop();
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
