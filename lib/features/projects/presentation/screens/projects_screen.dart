import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:orbit_todo/core/constants/app_constants.dart';
import 'package:orbit_todo/core/widgets/empty_state.dart';
import 'package:orbit_todo/features/projects/application/projects_provider.dart';
import 'package:orbit_todo/features/projects/domain/project_entity.dart';
import 'package:orbit_todo/features/tasks/application/tasks_provider.dart';

/// Projects screen — grid of user-created project cards with MNC-level UI.
class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Projects'),
            Text(
              'Workspaces & Folder Categories',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (projects.isEmpty) {
      return ProjectsListEmptyState(
        onAdd: () => showDialog<void>(
          context: context,
          builder: (ctx) => _CreateProjectDialog(),
        ),
      );
    }

    final crossCount = MediaQuery.of(context).size.width > AppConstants.breakpointMedium ? 3 : 2;

    return CustomScrollView(
      slivers: [
        // Hero Header Banner
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(
              AppConstants.space4,
              AppConstants.space2,
              AppConstants.space4,
              AppConstants.space3,
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
                  child: Icon(Icons.folder_open_rounded, color: colorScheme.primary, size: 20),
                ),
                const SizedBox(width: AppConstants.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${projects.length} Workspace Project${projects.length == 1 ? "" : "s"}',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Organize tasks by client, domain, or category',
                        style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Projects Grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.space4),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossCount,
              crossAxisSpacing: AppConstants.space3,
              mainAxisSpacing: AppConstants.space3,
              childAspectRatio: 1.15, // Fixed aspect ratio to guarantee zero overflow
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                return _ProjectCard(project: projects[i])
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: i * 40), duration: 200.ms)
                    .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 200.ms);
              },
              childCount: projects.length,
            ),
          ),
        ),
      ],
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

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: project.color.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: project.color.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/project/${project.id}'),
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top accent indicator bar
            Container(
              height: 4,
              color: project.color,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: project.color.withValues(alpha: 0.15),
                        ),
                        child: Icon(
                          _iconData(project.icon),
                          size: 18,
                          color: project.color,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () => _showProjectMenu(context, ref),
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.more_horiz_rounded,
                            size: 18,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    project.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  taskCountAsync.when(
                    data: (count) => Text(
                      count == 0 ? 'No tasks' : '$count task${count == 1 ? '' : 's'}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                    loading: () => const SizedBox(height: 12),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
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
                showDialog(
                  context: context,
                  builder: (_) => _CreateProjectDialog(projectToEdit: project),
                );
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
// Create/Edit Project Dialog
// ──────────────────────────────────────────────────────────────────────────

class _CreateProjectDialog extends ConsumerStatefulWidget {
  const _CreateProjectDialog({this.projectToEdit});
  final ProjectEntity? projectToEdit;

  @override
  ConsumerState<_CreateProjectDialog> createState() =>
      _CreateProjectDialogState();
}

class _CreateProjectDialogState extends ConsumerState<_CreateProjectDialog> {
  late final TextEditingController _nameController;
  late String _selectedColor;
  bool _isSaving = false;

  final List<String> _colors = [
    '#4F46E5', '#059669', '#DC4C3E', '#D97706',
    '#7C3AED', '#0891B2', '#DB2777', '#65A30D',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.projectToEdit?.name ?? '');
    _selectedColor = widget.projectToEdit?.colorHex ?? '#4F46E5';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEditing = widget.projectToEdit != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit project' : 'New project'),
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
          Text('Color Accent', style: theme.textTheme.labelMedium),
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
                        ? [BoxShadow(color: c.withValues(alpha: 0.4), blurRadius: 8)]
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
              : Text(isEditing ? 'Save' : 'Create'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    setState(() => _isSaving = true);
    if (widget.projectToEdit != null) {
      await ref.read(projectActionsProvider.notifier).updateProject(
            id: widget.projectToEdit!.id,
            name: name,
            colorHex: _selectedColor,
          );
    } else {
      await ref.read(projectActionsProvider.notifier).createProject(
            name: name,
            colorHex: _selectedColor,
          );
    }
    if (mounted) Navigator.pop(context);
  }
}
