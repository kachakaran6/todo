import 'package:flutter/material.dart';
import 'package:orbit_todo/core/theme/color_tokens.dart';

/// Task priority levels, ordered from none → urgent.
enum TaskPriority {
  none(0),
  low(1),
  medium(2),
  high(3),
  urgent(4);

  const TaskPriority(this.value);

  final int value;

  static TaskPriority fromValue(int value) {
    return TaskPriority.values.firstWhere(
      (p) => p.value == value,
      orElse: () => TaskPriority.none,
    );
  }

  String get label => switch (this) {
        TaskPriority.none => 'No priority',
        TaskPriority.low => 'Low',
        TaskPriority.medium => 'Medium',
        TaskPriority.high => 'High',
        TaskPriority.urgent => 'Urgent',
      };

  /// Icon for this priority (non color-only, paired with color).
  IconData get icon => switch (this) {
        TaskPriority.none => Icons.remove,
        TaskPriority.low => Icons.flag_outlined,
        TaskPriority.medium => Icons.flag,
        TaskPriority.high => Icons.flag,
        TaskPriority.urgent => Icons.warning_rounded,
      };

  /// Color in light mode.
  Color get lightColor => switch (this) {
        TaskPriority.none => OrbitColorTokens.priorityNone,
        TaskPriority.low => OrbitColorTokens.priorityLow,
        TaskPriority.medium => OrbitColorTokens.priorityMedium,
        TaskPriority.high => OrbitColorTokens.priorityHigh,
        TaskPriority.urgent => OrbitColorTokens.priorityUrgent,
      };

  /// Color in dark mode.
  Color get darkColor => switch (this) {
        TaskPriority.none => OrbitColorTokens.priorityNoneDark,
        TaskPriority.low => OrbitColorTokens.priorityLowDark,
        TaskPriority.medium => OrbitColorTokens.priorityMediumDark,
        TaskPriority.high => OrbitColorTokens.priorityHighDark,
        TaskPriority.urgent => OrbitColorTokens.priorityUrgentDark,
      };

  /// Returns the correct color based on [brightness].
  Color colorFor(Brightness brightness) =>
      brightness == Brightness.light ? lightColor : darkColor;
}
