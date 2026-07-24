import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../data/local/database.dart';
import '../../../data/local/tables.dart';
import '../domain/project_entity.dart';

const _uuid = Uuid();

/// Repository for Project data operations.
class ProjectRepository {
  ProjectRepository(this._db);

  final AppDatabase _db;

  Stream<List<ProjectEntity>> watchProjects() {
    return _db.projectsDao.watchProjects().asyncMap(_enrichProjects);
  }

  Future<ProjectEntity?> getProject(String id) async {
    final p = await _db.projectsDao.getProject(id);
    if (p == null) return null;
    return ProjectEntity(project: p);
  }

  Future<String> createProject({
    required String name,
    String colorHex = '#4F46E5',
    String icon = 'list',
  }) async {
    final id = _uuid.v4();
    await _db.projectsDao.insertProject(
      ProjectsCompanion.insert(
        id: id,
        name: name,
        colorHex: Value(colorHex),
        icon: Value(icon),
      ),
    );
    return id;
  }

  Future<void> updateProject({
    required String id,
    String? name,
    String? colorHex,
    String? icon,
  }) async {
    await _db.projectsDao.updateProject(
      ProjectsCompanion(
        id: Value(id),
        name: name != null ? Value(name) : const Value.absent(),
        colorHex: colorHex != null ? Value(colorHex) : const Value.absent(),
        icon: icon != null ? Value(icon) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> archiveProject(String id) => _db.projectsDao.archiveProject(id);

  Future<void> deleteProject(String id) => _db.projectsDao.deleteProject(id);

  Future<void> reorderProjects(List<String> orderedIds) =>
      _db.projectsDao.reorderProjects(orderedIds);

  Future<List<ProjectEntity>> _enrichProjects(List<Project> rawProjects) async {
    return Future.wait(rawProjects.map((p) async {
      // Count comes from the tasks table watch via provider layer
      return ProjectEntity(project: p);
    }));
  }
}
