import 'package:drift/drift.dart';

/// Drift table definition for Tasks.
/// Stores all task data with proper column types and defaults.
class Tasks extends Table {
  // Primary key — UUID string
  TextColumn get id => text()();

  // Core fields
  TextColumn get title => text()();
  TextColumn get notes => text().nullable()();

  // Completion state
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();

  // Scheduling
  DateTimeColumn get dueDate => dateTime().nullable()();
  TextColumn get dueTime => text().nullable()(); // "HH:mm" format
  DateTimeColumn get startDate => dateTime().nullable()();

  // Priority: 0=none, 1=low, 2=medium, 3=high, 4=urgent
  IntColumn get priority => integer().withDefault(const Constant(0))();

  // Organisation
  TextColumn get projectId => text().nullable().references(Projects, #id)();
  IntColumn get estimatedMinutes => integer().nullable()();
  TextColumn get recurrenceRule => text().nullable()(); // RFC-like rule JSON

  // Ordering
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  // Soft delete / archive
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  // Audit
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table definition for Projects / Lists.
class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get colorHex => text().withDefault(const Constant('#4F46E5'))();
  TextColumn get icon => text().withDefault(const Constant('list'))(); // icon name
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table definition for Tags / Labels.
class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get colorHex => text().withDefault(const Constant('#6B7280'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Many-to-many: Tasks <-> Tags
class TaskTags extends Table {
  TextColumn get taskId => text().references(Tasks, #id)();
  TextColumn get tagId => text().references(Tags, #id)();

  @override
  Set<Column> get primaryKey => {taskId, tagId};
}

/// Subtasks belonging to a parent task.
class Subtasks extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().references(Tasks, #id)();
  TextColumn get title => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Links / attachments stored with a task.
class TaskLinks extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().references(Tasks, #id)();
  TextColumn get url => text()();
  TextColumn get title => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Key-value store for user preferences.
class UserPreferences extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()(); // JSON encoded

  @override
  Set<Column> get primaryKey => {key};
}

/// Smart list definitions — serialized filter query.
class SmartLists extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icon => text().withDefault(const Constant('filter_list'))();
  TextColumn get filterJson => text()(); // JSON serialized filter
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
