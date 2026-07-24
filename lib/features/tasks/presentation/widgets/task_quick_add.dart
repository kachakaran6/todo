import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/motion.dart';
import '../../application/tasks_provider.dart';
import '../../domain/task_priority.dart';
import '../../../projects/application/projects_provider.dart';

/// Quick-add bottom sheet for rapid task capture.
///
/// Compact by default: just a text field with inline metadata chips.
/// Expands to show priority, due date, and project when user taps "More".
/// Pressing Enter / tapping "Add" saves immediately.
///
/// Natural-language parsing is done inline: if the title contains
/// "tomorrow", "today", "next week" etc., we suggest a date.
void showQuickAdd(BuildContext context, {String? initialTitle}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => QuickAddSheet(initialTitle: initialTitle),
  );
}

class QuickAddSheet extends ConsumerStatefulWidget {
  const QuickAddSheet({super.key, this.initialTitle});
  final String? initialTitle;

  @override
  ConsumerState<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends ConsumerState<QuickAddSheet> {
  late final TextEditingController _titleController;
  final FocusNode _focusNode = FocusNode();

  DateTime? _dueDate;
  TaskPriority _priority = TaskPriority.none;
  String? _projectId;
  bool _isExpanded = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    // Auto-focus with slight delay so sheet animates in first
    Future.delayed(OrbitMotion.moderate, () {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    setState(() => _isSaving = true);

    await ref.read(taskActionsProvider.notifier).createTask(
          title: title,
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

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.only(top: AppConstants.space3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.space3),

            // Title input row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.space4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    focusNode: _focusNode,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    maxLines: 3,
                    minLines: 1,
                    style: theme.textTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'What needs to be done?',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: AppConstants.space3,
                      ),
                    ),
                    onSubmitted: (_) => _save(),
                  ),
                ),
                // Save button
                Padding(
                  padding: const EdgeInsets.only(left: AppConstants.space2, bottom: AppConstants.space2),
                  child: AnimatedOpacity(
                    opacity: _titleController.text.trim().isNotEmpty ? 1 : 0.4,
                    duration: OrbitMotion.fast,
                    child: FilledButton(
                      onPressed: _isSaving ? null : _save,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 40),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.space4,
                          vertical: 0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                        ),
                      ),
                      child: _isSaving
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onPrimary,
                              ),
                            )
                          : const Text('Add'),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Inline metadata chips
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.space4,
              vertical: AppConstants.space2,
            ),
            child: Row(
              children: [
                // Due date chip
                _MetaChip(
                  icon: Icons.calendar_today_rounded,
                  label: _dueDate != null ? _formatDate(_dueDate!) : 'Date',
                  isActive: _dueDate != null,
                  onTap: _pickDate,
                ),
                const SizedBox(width: AppConstants.space2),

                // Priority chip
                _MetaChip(
                  icon: _priority.icon,
                  label: _priority == TaskPriority.none ? 'Priority' : _priority.label,
                  isActive: _priority != TaskPriority.none,
                  onTap: _pickPriority,
                ),
                const SizedBox(width: AppConstants.space2),

                // Project chip
                _MetaChip(
                  icon: Icons.circle_outlined,
                  label: _projectId != null ? 'Project' : 'Inbox',
                  isActive: _projectId != null,
                  onTap: _pickProject,
                ),

                const Spacer(),

                // Expand to full editor
                IconButton(
                  icon: Icon(
                    _isExpanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    size: 20,
                  ),
                  tooltip: 'More options',
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),

          // Expanded options (shown when user taps More)
          AnimatedSize(
            duration: OrbitMotion.moderate,
            curve: Curves.easeInOut,
            child: _isExpanded
                ? _ExpandedOptions(
                    dueDate: _dueDate,
                    priority: _priority,
                    onDueDateChanged: (d) => setState(() => _dueDate = d),
                    onPriorityChanged: (p) => setState(() => _priority = p),
                  )
                : const SizedBox.shrink(),
          ),

          // Bottom safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom + AppConstants.space2),
        ],
      ),
    ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: DateTime(now.year + 5),
      helpText: 'Select due date',
    );
    if (picked != null && mounted) {
      setState(() => _dueDate = picked);
    }
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

  Future<void> _pickProject() async {
    // TODO: Show project picker sheet
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

// ──────────────────────────────────────────────────────────────────────────
// Inline metadata chip
// ──────────────────────────────────────────────────────────────────────────

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: OrbitMotion.fast,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppConstants.radiusSM),
          border: Border.all(
            color: isActive
                ? colorScheme.primary.withValues(alpha: 0.3)
                : colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Expanded options section
// ──────────────────────────────────────────────────────────────────────────

class _ExpandedOptions extends StatelessWidget {
  const _ExpandedOptions({
    required this.dueDate,
    required this.priority,
    required this.onDueDateChanged,
    required this.onPriorityChanged,
  });

  final DateTime? dueDate;
  final TaskPriority priority;
  final ValueChanged<DateTime?> onDueDateChanged;
  final ValueChanged<TaskPriority> onPriorityChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.space4,
        vertical: AppConstants.space2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          const SizedBox(height: AppConstants.space3),
          Text(
            'Priority',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppConstants.space2),
          Row(
            children: TaskPriority.values.map((p) {
              final isSelected = priority == p;
              final color = p == TaskPriority.none
                  ? colorScheme.onSurfaceVariant
                  : p.colorFor(Theme.of(context).brightness);
              return Padding(
                padding: const EdgeInsets.only(right: AppConstants.space2),
                child: GestureDetector(
                  onTap: () => onPriorityChanged(p),
                  child: AnimatedContainer(
                    duration: OrbitMotion.fast,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: 0.15)
                          : colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppConstants.radiusSM),
                      border: Border.all(
                        color: isSelected
                            ? color.withValues(alpha: 0.5)
                            : colorScheme.outlineVariant,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4,
                      children: [
                        Icon(p.icon, size: 14, color: color),
                        Text(
                          p.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppConstants.space3),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Priority picker bottom sheet
// ──────────────────────────────────────────────────────────────────────────

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
          Text('Priority', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppConstants.space4),
          ...TaskPriority.values.map((p) {
            final color = p == TaskPriority.none
                ? colorScheme.onSurfaceVariant
                : p.colorFor(theme.brightness);
            return ListTile(
              leading: Icon(p.icon, color: color),
              title: Text(p.label, style: TextStyle(color: colorScheme.onSurface)),
              trailing: current == p
                  ? Icon(Icons.check_rounded, color: colorScheme.primary)
                  : null,
              onTap: () => Navigator.of(context).pop(p),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMD),
              ),
            );
          }),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
