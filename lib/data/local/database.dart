import 'package:drift/drift.dart';
import 'connection/connection.dart';

import 'tables.dart';
import 'daos/tasks_dao.dart';
import 'daos/projects_dao.dart';
import 'daos/tags_dao.dart';

part 'database.g.dart';

/// Orbit Todo — Drift SQLite Database
///
/// Single source of truth for all local task data.
/// Add new migrations in [_migrationStrategy].
@DriftDatabase(
  tables: [
    Tasks,
    Projects,
    Tags,
    TaskTags,
    Subtasks,
    TaskLinks,
    UserPreferences,
    SmartLists,
  ],
  daos: [
    TasksDao,
    ProjectsDao,
    TagsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          // Seed default smart lists
          await _seedDefaultSmartLists();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Future migrations go here
        },
        beforeOpen: (details) async {
          // Enable foreign key support
          await customStatement('PRAGMA foreign_keys = ON');
          // Enable WAL mode for better concurrency
          await customStatement('PRAGMA journal_mode = WAL');
          // Optimize for reads
          await customStatement('PRAGMA synchronous = NORMAL');
        },
      );

  /// Seed built-in smart lists that ship by default.
  Future<void> _seedDefaultSmartLists() async {
    final defaults = [
      SmartListsCompanion.insert(
        id: 'smart_high_priority',
        name: 'High Priority',
        icon: const Value('flag'),
        filterJson: '{"priority": {"gte": 3}}',
        isDefault: const Value(true),
        sortOrder: const Value(0),
      ),
      SmartListsCompanion.insert(
        id: 'smart_overdue',
        name: 'Overdue',
        icon: const Value('schedule'),
        filterJson: '{"overdue": true}',
        isDefault: const Value(true),
        sortOrder: const Value(1),
      ),
      SmartListsCompanion.insert(
        id: 'smart_no_due_date',
        name: 'No Due Date',
        icon: const Value('calendar_today'),
        filterJson: '{"dueDate": null}',
        isDefault: const Value(true),
        sortOrder: const Value(2),
      ),
    ];
    for (final sl in defaults) {
      await into(smartLists).insertOnConflictUpdate(sl);
    }
  }
}

/// Opens the platform-appropriate database (Native SQLite on Desktop/Mobile, WebDatabase on Web).
QueryExecutor _openConnection() {
  return openConnection();
}
