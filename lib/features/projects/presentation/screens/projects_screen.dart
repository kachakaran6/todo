import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:orbit_todo/core/constants/app_constants.dart';
import 'package:orbit_todo/core/widgets/empty_state.dart';
import 'package:orbit_todo/features/projects/application/projects_provider.dart';
import 'package:orbit_todo/features/projects/domain/project_entity.dart';
import 'package:orbit_todo/features/tasks/application/tasks_provider.dart';
import 'package:orbit_todo/features/tasks/presentation/widgets/task_quick_add.dart';

/// Projects screen — grid of user-created project cards.
class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'New project',
            onPressed: () => _showCreateProjectDialog(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: projectsAsync.when(
        data: (projects) => _ProjectsGrid(projects: projects),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showCreateProjectDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _CreateProjectDialog(),
    );
  }
}

class _ProjectsGrid extends ConsumerWidget {
  const _ProjectsGrid({required this.projects});
  final List<ProjectEntity> projects;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (projects.isEmpty) {
      return ProjectsListEmptyState(
        onAdd: () => showDialog<void>(
          context: context,
          builder: (ctx) => _CreateProjectDialog(),
        ),
      );
    }

    final crossCount = MediaQuery.of(context).size.width > AppConstants.breakpointMedium ? 3 : 2;

    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.space4),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossCount,
        crossAxisSpacing: AppConstants.space3,
        mainAxisSpacing: AppConstants.space3,
        childAspectRatio: 1.5,
      ),
      itemCount: projects.length,
      itemBuilder: (context, i) {
        return _ProjectCard(project: projects[i])
            .animate()
            .fadeIn(delay: Duration(milliseconds: i * 40), duration: 200.ms)
            .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 200.ms);
      },
    );
  }
}

class _ProjectCard extends ConsumerWidget {
  const _ProjectCard({required this.project});
  final ProjectEntity project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final taskCountAsync = ref.watch(projectTaskCountProvider(project.id));

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/project/${project.id}'),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Color dot + icon
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: project.color.withOpacity(0.15),
                    ),
                    child: Icon(
                      _iconData(project.icon),
                      size: 18,
                      color: project.color,
                    ),
                  ),
                  const Spacer(),
                  // Context menu
                  InkWell(
                    onTap: () => _showProjectMenu(context, ref),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.more_horiz_rounded,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Project name
              Text(
                project.name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              // Task count
              taskCountAsync.when(
                data: (count) => Text(
                  count == 0 ? 'No tasks' : '$count task${count == 1 ? '' : 's'}',
                  style: theme.textTheme.bodySmall,
                ),
                loading: () => const SizedBox(height: 12),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProjectMenu(BuildContext context, WidgetRef ref) {
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
              onTap: () {
                Navigator.pop(ctx);
                // TODO: Edit project dialog
              },
            ),
            ListTile(
              leading: Icon(Icons.archive_outlined,
                  color: Theme.of(context).colorScheme.error),
              title: Text('Archive project',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error)),
              onTap: () {
                Navigator.pop(ctx);
                ref.read(projectActionsProvider.notifier).archiveProject(project.id);
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  IconData _iconData(String name) => switch (name) {
        'work' => Icons.work_outline_rounded,
        'home' => Icons.home_outlined,
        'shopping' => Icons.shopping_bag_outlined,
        'health' => Icons.favorite_outline_rounded,
        'study' => Icons.school_outlined,
        'travel' => Icons.flight_outlined,
        _ => Icons.list_rounded,
      };
}

// ──────────────────────────────────────────────────────────────────────────
// Create Project Dialog
// ──────────────────────────────────────────────────────────────────────────

class _CreateProjectDialog extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CreateProjectDialog> createState() =>
      _CreateProjectDialogState();
}

class _CreateProjectDialogState extends ConsumerState<_CreateProjectDialog> {
  final _nameController = TextEditingController();
  String _selectedColor = '#4F46E5';
  bool _isSaving = false;

  final List<String> _colors = [
    '#4F46E5', '#059669', '#DC4C3E', '#D97706',
    '#7C3AED', '#0891B2', '#DB2777', '#65A30D',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: const Text('New project'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'Project name',
              labelText: 'Name',
            ),
          ),
          const SizedBox(height: AppConstants.space4),
          Text('Color', style: theme.textTheme.labelMedium),
          const SizedBox(height: AppConstants.space2),
          Wrap(
            spacing: AppConstants.space2,
            runSpacing: AppConstants.space2,
            children: _colors.map((hex) {
              Color c;
              try {
                c = Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
              } catch (_) {
                c = colorScheme.primary;
              }
              final isSelected = _selectedColor == hex;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = hex),
                child: AnimatedContainer(
                  duration: 150.ms,
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: c,
                    border: isSelected
                        ? Border.all(
                            color: colorScheme.onSurface,
                            width: 2.5,
                          )
                        : null,
                    boxShadow: isSelected
                        ? [BoxShadow(color: c.withOpacity(0.4), blurRadius: 8)]
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 18)
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    setState(() => _isSaving = true);
    await ref.read(projectActionsProvider.notifier).createProject(
          name: name,
          colorHex: _selectedColor,
        );
    if (mounted) Navigator.pop(context);
  }
}
