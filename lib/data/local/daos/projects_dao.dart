import 'package:drift/drift.dart';

import '../database.dart';
import '../tables.dart';

part 'projects_dao.g.dart';

/// Data Access Object for Project operations.
@DriftAccessor(tables: [Projects, Tasks])
class ProjectsDao extends DatabaseAccessor<AppDatabase>
    with _$ProjectsDaoMixin {
  ProjectsDao(super.db);

  /// Watch all non-archived projects ordered by sort order.
  Stream<List<Project>> watchProjects() {
    return (select(projects)
          ..where((p) => p.isArchived.equals(false))
          ..orderBy([(p) => OrderingTerm.asc(p.sortOrder)]))
        .watch();
  }

  /// Get a single project by ID.
  Future<Project?> getProject(String id) {
    return (select(projects)..where((p) => p.id.equals(id)))
        .getSingleOrNull();
  }

  /// Watch a single project by ID.
  Stream<Project?> watchProject(String id) {
    return (select(projects)..where((p) => p.id.equals(id)))
        .watchSingleOrNull();
  }

  /// Insert a new project.
  Future<void> insertProject(ProjectsCompanion project) async {
    await into(projects).insert(project);
  }

  /// Update a project.
  Future<void> updateProject(ProjectsCompanion project) async {
    await (update(projects)..where((p) => p.id.equals(project.id.value)))
        .write(project);
  }

  /// Archive a project.
  Future<void> archiveProject(String id) async {
    await (update(projects)..where((p) => p.id.equals(id))).write(
      ProjectsCompanion(
        isArchived: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Permanently delete a project (tasks will have their projectId set to null).
  Future<void> deleteProject(String id) async {
    await transaction(() async {
      // Unassign tasks from this project
      await (update(tasks)..where((t) => t.projectId.equals(id))).write(
        const TasksCompanion(projectId: Value(null)),
      );
      await (delete(projects)..where((p) => p.id.equals(id))).go();
    });
  }

  /// Reorder projects by updating sortOrder.
  Future<void> reorderProjects(List<String> orderedIds) async {
    await transaction(() async {
      for (int i = 0; i < orderedIds.length; i++) {
        await (update(projects)
              ..where((p) => p.id.equals(orderedIds[i])))
            .write(ProjectsCompanion(sortOrder: Value(i)));
      }
    });
  }
}
