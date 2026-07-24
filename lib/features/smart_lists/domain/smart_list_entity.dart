import 'package:flutter/material.dart';

/// Smart List entity representing a saved, named query (PRD Section 4.3).
class SmartListEntity {
  const SmartListEntity({
    required this.id,
    required this.name,
    required this.iconName,
    required this.filterJson,
    this.isDefault = false,
    this.sortOrder = 0,
  });

  final String id;
  final String name;
  final String iconName;
  final String filterJson;
  final bool isDefault;
  final int sortOrder;

  IconData get iconData => switch (iconName) {
        'flag' => Icons.flag_rounded,
        'schedule' => Icons.schedule_rounded,
        'calendar_today' => Icons.calendar_today_rounded,
        'star' => Icons.star_rounded,
        _ => Icons.filter_list_rounded,
      };

  /// Generates a human-readable summary of the filter query.
  String get humanReadableSummary {
    if (id == 'smart_high_priority') return 'High priority tasks (Level 3+)';
    if (id == 'smart_overdue') return 'Tasks past their due date';
    if (id == 'smart_no_due_date') return 'Tasks without a scheduled date';
    return 'Custom filtered task view';
  }
}
