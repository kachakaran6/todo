import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../data/local/database.dart';

/// Domain entity for a Project / List.
class ProjectEntity extends Equatable {
  const ProjectEntity({
    required this.project,
    this.taskCount = 0,
  });

  final Project project;
  final int taskCount;

  String get id => project.id;
  String get name => project.name;
  String get colorHex => project.colorHex;
  String get icon => project.icon;
  bool get isArchived => project.isArchived;
  int get sortOrder => project.sortOrder;

  /// Parses the hex color string (e.g. "#4F46E5") into a [Color].
  Color get color {
    try {
      final hex = colorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return const Color(0xFF4F46E5);
    }
  }

  ProjectEntity copyWith({Project? project, int? taskCount}) {
    return ProjectEntity(
      project: project ?? this.project,
      taskCount: taskCount ?? this.taskCount,
    );
  }

  @override
  List<Object?> get props => [project.id, project.updatedAt, taskCount];
}
