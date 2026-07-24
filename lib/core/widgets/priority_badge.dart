import 'package:flutter/material.dart';
import '../../features/tasks/domain/task_priority.dart';
import '../constants/app_constants.dart';

/// Displays a compact priority badge with both icon and color label.
/// Never uses color alone as the only indicator (WCAG compliant).
class PriorityBadge extends StatelessWidget {
  const PriorityBadge({
    super.key,
    required this.priority,
    this.showLabel = false,
    this.size = BadgeSize.small,
  });

  final TaskPriority priority;
  final bool showLabel;
  final BadgeSize size;

  @override
  Widget build(BuildContext context) {
    if (priority == TaskPriority.none) return const SizedBox.shrink();

    final brightness = Theme.of(context).brightness;
    final color = priority.colorFor(brightness);
    final iconSize = size == BadgeSize.small ? 14.0 : 16.0;

    if (!showLabel) {
      // Icon-only badge (used in compact tiles)
      return Tooltip(
        message: priority.label,
        child: Icon(priority.icon, size: iconSize, color: color),
      );
    }

    // Icon + label chip
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.space2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppConstants.radiusSM),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Icon(priority.icon, size: iconSize, color: color),
          Text(
            priority.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

enum BadgeSize { small, medium }
