import 'package:flutter/material.dart';
import '../../domain/widget_snapshot_model.dart';
import '../../domain/widget_configuration.dart';
import '../../../../core/constants/app_constants.dart';

/// Renders a live preview card of home-screen widgets matching platform layout specs (PRD Sections 6 & 7).
class WidgetPreviewCard extends StatelessWidget {
  final String widgetType; // 'today', 'quick_add', 'inbox', 'focus'
  final String size; // 'small', 'medium', 'large'
  final WidgetSnapshotData snapshot;
  final WidgetConfig config;
  final VoidCallback? onTap;

  const WidgetPreviewCard({
    super.key,
    required this.widgetType,
    required this.size,
    required this.snapshot,
    required this.config,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final dimensions = switch (size) {
      'small' => const Size(155, 155),
      'medium' => const Size(320, 155),
      'large' => const Size(320, 310),
      _ => const Size(320, 155),
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusLG),
      child: Container(
        width: dimensions.width,
        height: dimensions.height,
        padding: const EdgeInsets.all(AppConstants.space3),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            if (config.titleVisible) _buildHeader(context),
            const SizedBox(height: AppConstants.space2),
            // Body Content
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final title = switch (widgetType) {
      'today' => 'Today',
      'inbox' => 'Inbox',
      'quick_add' => 'Quick Add',
      'focus' => 'Focus Task',
      _ => 'TaskMitra',
    };

    final icon = switch (widgetType) {
      'today' => Icons.today_rounded,
      'inbox' => Icons.inbox_rounded,
      'quick_add' => Icons.add_circle_outline_rounded,
      'focus' => Icons.center_focus_strong_rounded,
      _ => Icons.check_circle_outline_rounded,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: colorScheme.primary),
            const SizedBox(width: 6),
            Text(
              title,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        if (snapshot.totalCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${snapshot.totalCount}',
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (snapshot.fallbackMessage != null) {
      return Center(
        child: Text(
          snapshot.fallbackMessage!,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    if (widgetType == 'quick_add') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_task_rounded, size: 36, color: colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            'Tap to Capture Task',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      );
    }

    if (widgetType == 'focus') {
      final task = snapshot.focusTask ?? (snapshot.items.isNotEmpty ? snapshot.items.first : null);
      if (task == null) {
        return Center(
          child: Text(
            'No focus task selected',
            style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(Icons.circle_outlined, size: 20, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  task.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Today & Inbox List View
    final displayItems = snapshot.items.take(size == 'large' ? 5 : 3).toList();
    if (displayItems.isEmpty) {
      return Center(
        child: Text(
          'All tasks completed! 🎉',
          style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    return Column(
      children: displayItems.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Row(
            children: [
              Icon(
                item.isCompleted ? Icons.check_circle_rounded : Icons.circle_outlined,
                size: 16,
                color: item.isCompleted ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface,
                    decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
