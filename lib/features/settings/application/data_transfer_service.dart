import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/local/database.dart';
import '../../../features/tasks/application/tasks_provider.dart';

/// Handles manual data export and import for backup/portability (PRD Section 7.3).
class DataTransferService {
  DataTransferService(this._db);

  final AppDatabase _db;

  /// Export all user data to a formatted JSON string.
  Future<String> exportToJson() async {
    final tasks = await _db.select(_db.tasks).get();
    final projects = await _db.select(_db.projects).get();
    final tags = await _db.select(_db.tags).get();
    final smartLists = await _db.select(_db.smartLists).get();
    final customFields = await _db.select(_db.customFieldDefinitions).get();

    final Map<String, dynamic> exportData = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'projects': projects
          .map((p) => {
                'id': p.id,
                'name': p.name,
                'colorHex': p.colorHex,
                'icon': p.icon,
                'sortOrder': p.sortOrder,
                'isArchived': p.isArchived,
              })
          .toList(),
      'tags': tags
          .map((t) => {
                'id': t.id,
                'name': t.name,
                'colorHex': t.colorHex,
              })
          .toList(),
      'tasks': tasks
          .map((t) => {
                'id': t.id,
                'title': t.title,
                'notes': t.notes,
                'isCompleted': t.isCompleted,
                'completedAt': t.completedAt?.toIso8601String(),
                'dueDate': t.dueDate?.toIso8601String(),
                'dueTime': t.dueTime,
                'priority': t.priority,
                'projectId': t.projectId,
                'recurrenceRule': t.recurrenceRule,
                'sortOrder': t.sortOrder,
              })
          .toList(),
      'smartLists': smartLists
          .map((s) => {
                'id': s.id,
                'name': s.name,
                'icon': s.icon,
                'filterJson': s.filterJson,
              })
          .toList(),
      'customFields': customFields
          .map((cf) => {
                'id': cf.id,
                'name': cf.name,
                'type': cf.type,
                'projectId': cf.projectId,
              })
          .toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(exportData);
  }

  /// Import user data from a JSON string with merge/overwrite options.
  Future<int> importFromJson(String rawJson, {bool overwrite = false}) async {
    final Map<String, dynamic> data = jsonDecode(rawJson);
    int importedCount = 0;

    await _db.transaction(() async {
      if (overwrite) {
        await _db.delete(_db.tasks).go();
        await _db.delete(_db.projects).go();
        await _db.delete(_db.tags).go();
      }

      final List projects = data['projects'] ?? [];
      for (final item in projects) {
        await _db.into(_db.projects).insertOnConflictUpdate(
              ProjectsCompanion.insert(
                id: item['id'],
                name: item['name'],
                colorHex: item['colorHex'] ?? '#4F46E5',
                icon: item['icon'] ?? 'list',
              ),
            );
      }

      final List tags = data['tags'] ?? [];
      for (final item in tags) {
        await _db.into(_db.tags).insertOnConflictUpdate(
              TagsCompanion.insert(
                id: item['id'],
                name: item['name'],
                colorHex: item['colorHex'] ?? '#6B7280',
              ),
            );
      }

      final List tasks = data['tasks'] ?? [];
      for (final item in tasks) {
        await _db.into(_db.tasks).insertOnConflictUpdate(
              TasksCompanion.insert(
                id: item['id'],
                title: item['title'],
                notes: Value(item['notes']),
                isCompleted: Value(item['isCompleted'] ?? false),
                completedAt: Value(
                    item['completedAt'] != null ? DateTime.parse(item['completedAt']) : null),
                dueDate: Value(
                    item['dueDate'] != null ? DateTime.parse(item['dueDate']) : null),
                dueTime: Value(item['dueTime']),
                priority: Value(item['priority'] ?? 0),
                projectId: Value(item['projectId']),
                recurrenceRule: Value(item['recurrenceRule']),
              ),
            );
        importedCount++;
      }
    });

    return importedCount;
  }
}

final dataTransferServiceProvider = Provider<DataTransferService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DataTransferService(db);
});
