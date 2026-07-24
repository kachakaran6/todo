import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/motion.dart';
import '../../application/tasks_provider.dart';
import '../../domain/task_priority.dart';
import '../../../projects/application/projects_provider.dart';
import '../../../projects/domain/project_entity.dart';

/// Quick-add bottom sheet for rapid task capture.
/// Designed for super easy UX and MNC-grade speed.
void showQuickAdd(BuildContext context, {String? initialTitle, String? initialProjectId}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => QuickAddSheet(
      initialTitle: initialTitle,
      initialProjectId: initialProjectId,
    ),
  );
}

class QuickAddSheet extends ConsumerStatefulWidget {
  const QuickAddSheet({super.key, this.initialTitle, this.initialProjectId});
  final String? initialTitle;
  final String? initialProjectId;

  @override
  ConsumerState<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends ConsumerState<QuickAddSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  final FocusNode _focusNode = FocusNode();

  DateTime? _dueDate;
  TaskPriority _priority = TaskPriority.none;
  String? _projectId;
  bool _showNotes = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _notesController = TextEditingController();
    _projectId = widget.initialProjectId;

    _titleController.addListener(_onTitleChanged);

    Future.delayed(OrbitMotion.fast, () {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _titleController.dispose();
    _notesController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTitleChanged() {
    final text = _titleController.text.toLowerCase();
    // Smart Natural Language Parsing
    if (_dueDate == null) {
      if (text.contains('today')) {
        _dueDate = DateTime.now();
      } else if (text.contains('tomorrow')) {
        _dueDate = DateTime.now().add(const Duration(days: 1));
      }
    }
    setState(() {});
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty || _isSaving) return;

    setState(() => _isSaving = true);

    await ref.read(taskActionsProvider.notifier).createTask(
          title: title,
          notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
          dueDate: _dueDate,
          priority: _priority.value,
          projectId: _projectId,
        );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final viewInsets = MediaQuery.of(context).viewInsets;
    final projectsAsync = ref.watch(projectsProvider);

    final isTitleNotEmpty = _titleController.text.trim().isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(
          AppConstants.space4,
          AppConstants.space3,
          AppConstants.space4,
          AppConstants.space3,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.space3),

            // Task title input
            TextField(
              controller: _titleController,
              focusNode: _focusNode,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              maxLines: 3,
              minLines: 1,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: 'What needs to be done?',
                hintStyle: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (_) => _save(),
            ),

            // Optional Notes input
            if (_showNotes) ...[
              const SizedBox(height: AppConstants.space2),
              TextField(
                controller: _notesController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
                minLines: 1,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Add description or notes…',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],

            const SizedBox(height: AppConstants.space3),

            // Scrollable Metadata Chips Row (Date, Priority, Project)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Quick Today Date Chip
                  _QuickChip(
                    icon: Icons.wb_sunny_rounded,
                    label: _dueDate != null && DateUtils.isSameDay(_dueDate!, DateTime.now())
                        ? 'Today'
                        : (_dueDate != null ? _formatDate(_dueDate!) : 'Date'),
                    isActive: _dueDate != null,
                    activeColor: colorScheme.primary,
                    onTap: () {
                      if (_dueDate != null && DateUtils.isSameDay(_dueDate!, DateTime.now())) {
                        setState(() => _dueDate = null);
                      } else {
                        setState(() => _dueDate = DateTime.now());
                      }
                    },
                  ),
                  const SizedBox(width: AppConstants.space2),

                  // Quick Tomorrow Date Chip
                  _QuickChip(
                    icon: Icons.calendar_today_rounded,
                    label: 'Tomorrow',
                    isActive: _dueDate != null &&
                        DateUtils.isSameDay(
                          _dueDate!,
                          DateTime.now().add(const Duration(days: 1)),
                        ),
                    activeColor: colorScheme.secondary,
                    onTap: () {
                      final tomorrow = DateTime.now().add(const Duration(days: 1));
                      if (_dueDate != null && DateUtils.isSameDay(_dueDate!, tomorrow)) {
                        setState(() => _dueDate = null);
                      } else {
                        setState(() => _dueDate = tomorrow);
                      }
                    },
                  ),
                  const SizedBox(width: AppConstants.space2),

                  // Priority Selector Chip
                  _QuickChip(
                    icon: _priority.icon,
                    label: _priority == TaskPriority.none ? 'Priority' : _priority.label,
                    isActive: _priority != TaskPriority.none,
                    activeColor: _priority != TaskPriority.none
                        ? _priority.colorFor(theme.brightness)
                        : colorScheme.primary,
                    onTap: _pickPriority,
                  ),
                  const SizedBox(width: AppConstants.space2),

                  // Project Picker Chip
                  projectsAsync.when(
                    data: (projects) {
                      final selectedProj =
                          projects.where((p) => p.id == _projectId).firstOrNull;
                      return _QuickChip(
                        icon: Icons.folder_open_rounded,
                        label: selectedProj != null ? selectedProj.name : 'Inbox',
                        isActive: _projectId != null,
                        activeColor: selectedProj?.color ?? colorScheme.primary,
                        onTap: () => _pickProject(projects),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.space3),
            const Divider(height: 1),
            const SizedBox(height: AppConstants.space2),

            // Bottom Actions Bar (Notes Toggle & Submit Button)
            Row(
              children: [
                // Notes toggle button
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    _showNotes ? Icons.description_rounded : Icons.description_outlined,
                    color: _showNotes ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  tooltip: 'Add notes',
                  onPressed: () => setState(() => _showNotes = !_showNotes),
                ),
                const SizedBox(width: AppConstants.space2),
                Text(
                  _showNotes ? 'Notes' : 'Add description',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),

                // Primary Add Task Button
                AnimatedContainer(
                  duration: OrbitMotion.fast,
                  child: FilledButton.icon(
                    onPressed: isTitleNotEmpty && !_isSaving ? _save : null,
                    icon: _isSaving
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.onPrimary,
                            ),
                          )
                        : const Icon(Icons.arrow_upward_rounded, size: 18),
                    label: const Text('Add Task'),
                    style: FilledButton.styleFrom(
                      backgroundColor: isTitleNotEmpty
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      foregroundColor: isTitleNotEmpty
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      elevation: isTitleNotEmpty ? 3 : 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.space4,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPriority() async {
    final priority = await showModalBottomSheet<TaskPriority>(
      context: context,
      builder: (ctx) => _PriorityPicker(current: _priority),
    );
    if (priority != null && mounted) {
      setState(() => _priority = priority);
    }
  }

  Future<void> _pickProject(List<ProjectEntity> projects) async {
    final selected = await showModalBottomSheet<String?>(
      context: context,
      builder: (ctx) => _ProjectPickerSheet(
        projects: projects,
        selectedId: _projectId,
      ),
    );
    if (mounted) {
      setState(() => _projectId = selected);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${date.day} ${months[date.month - 1]}';
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: OrbitMotion.fast,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withValues(alpha: 0.15)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? activeColor.withValues(alpha: 0.5)
                : colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isActive ? activeColor : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? activeColor : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriorityPicker extends StatelessWidget {
  const _PriorityPicker({required this.current});
  final TaskPriority current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppConstants.space4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Priority', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppConstants.space3),
          ...TaskPriority.values.map((p) {
            final color = p == TaskPriority.none
                ? colorScheme.onSurfaceVariant
                : p.colorFor(theme.brightness);
            return ListTile(
              leading: Icon(p.icon, color: color),
              title: Text(p.label, style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w600)),
              trailing: current == p
                  ? Icon(Icons.check_rounded, color: colorScheme.primary)
                  : null,
              onTap: () => Navigator.of(context).pop(p),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class _ProjectPickerSheet extends StatelessWidget {
  const _ProjectPickerSheet({
    required this.projects,
    required this.selectedId,
  });

  final List<ProjectEntity> projects;
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppConstants.space4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Project', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppConstants.space3),

          // Inbox Option
          ListTile(
            leading: Icon(Icons.inbox_rounded, color: colorScheme.primary),
            title: const Text('Inbox (No Project)'),
            trailing: selectedId == null
                ? Icon(Icons.check_rounded, color: colorScheme.primary)
                : null,
            onTap: () => Navigator.of(context).pop(null),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const Divider(height: 1),

          // User Projects
          ...projects.map((proj) {
            return ListTile(
              leading: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: proj.color,
                ),
              ),
              title: Text(proj.name),
              trailing: selectedId == proj.id
                  ? Icon(Icons.check_rounded, color: colorScheme.primary)
                  : null,
              onTap: () => Navigator.of(context).pop(proj.id),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
