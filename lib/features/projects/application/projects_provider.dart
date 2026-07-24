import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/database.dart';
import '../data/project_repository.dart';
import '../domain/project_entity.dart';
import '../../tasks/application/tasks_provider.dart';

part 'projects_provider.g.dart';

/// Provides the ProjectRepository.
@Riverpod(keepAlive: true)
ProjectRepository projectRepository(Ref ref) {
  return ProjectRepository(ref.watch(appDatabaseProvider));
}

/// Watch all active projects.
@riverpod
Stream<List<ProjectEntity>> projects(Ref ref) {
  return ref.watch(projectRepositoryProvider).watchProjects();
}

/// ProjectActions notifier for mutations.
@riverpod
class ProjectActions extends _$ProjectActions {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  ProjectRepository get _repo => ref.read(projectRepositoryProvider);

  Future<String?> createProject({
    required String name,
    String colorHex = '#4F46E5',
    String icon = 'list',
  }) async {
    state = const AsyncLoading();
    try {
      final id = await _repo.createProject(
        name: name,
        colorHex: colorHex,
        icon: icon,
      );
      state = const AsyncData(null);
      return id;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }

  Future<void> updateProject({
    required String id,
    String? name,
    String? colorHex,
    String? icon,
  }) async {
    await _repo.updateProject(id: id, name: name, colorHex: colorHex, icon: icon);
  }

  Future<void> archiveProject(String id) => _repo.archiveProject(id);

  Future<void> deleteProject(String id) => _repo.deleteProject(id);

  Future<void> reorderProjects(List<String> ids) => _repo.reorderProjects(ids);
}
