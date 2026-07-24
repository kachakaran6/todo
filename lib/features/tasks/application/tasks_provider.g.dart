// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'59cce38d45eeaba199eddd097d8e149d66f9f3e1';

/// Provides the single AppDatabase instance.
///
/// Copied from [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = ProviderRef<AppDatabase>;
String _$taskRepositoryHash() => r'85e63b4826a3d6db7d188a8354c50d4d8b378f21';

/// Provides the TaskRepository.
///
/// Copied from [taskRepository].
@ProviderFor(taskRepository)
final taskRepositoryProvider = Provider<TaskRepository>.internal(
  taskRepository,
  name: r'taskRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TaskRepositoryRef = ProviderRef<TaskRepository>;
String _$inboxTasksHash() => r'4758fc2e1862ebd94fe16ff59c2a9516c20548cd';

/// Inbox tasks stream.
///
/// Copied from [inboxTasks].
@ProviderFor(inboxTasks)
final inboxTasksProvider = AutoDisposeStreamProvider<List<TaskEntity>>.internal(
  inboxTasks,
  name: r'inboxTasksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inboxTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InboxTasksRef = AutoDisposeStreamProviderRef<List<TaskEntity>>;
String _$todayTasksHash() => r'5b5c8495e08ddc76e99363391cb326b433e90746';

/// Today tasks stream.
///
/// Copied from [todayTasks].
@ProviderFor(todayTasks)
final todayTasksProvider = AutoDisposeStreamProvider<List<TaskEntity>>.internal(
  todayTasks,
  name: r'todayTasksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayTasksRef = AutoDisposeStreamProviderRef<List<TaskEntity>>;
String _$allActiveTasksHash() => r'c4848702be1713a46adae8a2802c0f037efd62e0';

/// All active tasks stream.
///
/// Copied from [allActiveTasks].
@ProviderFor(allActiveTasks)
final allActiveTasksProvider =
    AutoDisposeStreamProvider<List<TaskEntity>>.internal(
      allActiveTasks,
      name: r'allActiveTasksProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$allActiveTasksHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllActiveTasksRef = AutoDisposeStreamProviderRef<List<TaskEntity>>;
String _$projectTasksHash() => r'7d07273de63190eaa1d79ec4ff4a87291636506e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Tasks for a specific project.
///
/// Copied from [projectTasks].
@ProviderFor(projectTasks)
const projectTasksProvider = ProjectTasksFamily();

/// Tasks for a specific project.
///
/// Copied from [projectTasks].
class ProjectTasksFamily extends Family<AsyncValue<List<TaskEntity>>> {
  /// Tasks for a specific project.
  ///
  /// Copied from [projectTasks].
  const ProjectTasksFamily();

  /// Tasks for a specific project.
  ///
  /// Copied from [projectTasks].
  ProjectTasksProvider call(String projectId) {
    return ProjectTasksProvider(projectId);
  }

  @override
  ProjectTasksProvider getProviderOverride(
    covariant ProjectTasksProvider provider,
  ) {
    return call(provider.projectId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'projectTasksProvider';
}

/// Tasks for a specific project.
///
/// Copied from [projectTasks].
class ProjectTasksProvider extends AutoDisposeStreamProvider<List<TaskEntity>> {
  /// Tasks for a specific project.
  ///
  /// Copied from [projectTasks].
  ProjectTasksProvider(String projectId)
    : this._internal(
        (ref) => projectTasks(ref as ProjectTasksRef, projectId),
        from: projectTasksProvider,
        name: r'projectTasksProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$projectTasksHash,
        dependencies: ProjectTasksFamily._dependencies,
        allTransitiveDependencies:
            ProjectTasksFamily._allTransitiveDependencies,
        projectId: projectId,
      );

  ProjectTasksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final String projectId;

  @override
  Override overrideWith(
    Stream<List<TaskEntity>> Function(ProjectTasksRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProjectTasksProvider._internal(
        (ref) => create(ref as ProjectTasksRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<TaskEntity>> createElement() {
    return _ProjectTasksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectTasksProvider && other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProjectTasksRef on AutoDisposeStreamProviderRef<List<TaskEntity>> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _ProjectTasksProviderElement
    extends AutoDisposeStreamProviderElement<List<TaskEntity>>
    with ProjectTasksRef {
  _ProjectTasksProviderElement(super.provider);

  @override
  String get projectId => (origin as ProjectTasksProvider).projectId;
}

String _$completedTasksHash() => r'bf8a92be2a99c926c0105a745818a3be59757c52';

/// Completed tasks stream.
///
/// Copied from [completedTasks].
@ProviderFor(completedTasks)
final completedTasksProvider =
    AutoDisposeStreamProvider<List<TaskEntity>>.internal(
      completedTasks,
      name: r'completedTasksProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$completedTasksHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompletedTasksRef = AutoDisposeStreamProviderRef<List<TaskEntity>>;
String _$todayTaskCountHash() => r'233c99fc77272afe78ca9a09156157165095f570';

/// Today task count (for badge in nav).
///
/// Copied from [todayTaskCount].
@ProviderFor(todayTaskCount)
final todayTaskCountProvider = AutoDisposeStreamProvider<int>.internal(
  todayTaskCount,
  name: r'todayTaskCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayTaskCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayTaskCountRef = AutoDisposeStreamProviderRef<int>;
String _$projectTaskCountHash() => r'83acf2f28a026254aa9ac1f19b74828799d5112e';

/// Project task count (for badge on project card).
///
/// Copied from [projectTaskCount].
@ProviderFor(projectTaskCount)
const projectTaskCountProvider = ProjectTaskCountFamily();

/// Project task count (for badge on project card).
///
/// Copied from [projectTaskCount].
class ProjectTaskCountFamily extends Family<AsyncValue<int>> {
  /// Project task count (for badge on project card).
  ///
  /// Copied from [projectTaskCount].
  const ProjectTaskCountFamily();

  /// Project task count (for badge on project card).
  ///
  /// Copied from [projectTaskCount].
  ProjectTaskCountProvider call(String projectId) {
    return ProjectTaskCountProvider(projectId);
  }

  @override
  ProjectTaskCountProvider getProviderOverride(
    covariant ProjectTaskCountProvider provider,
  ) {
    return call(provider.projectId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'projectTaskCountProvider';
}

/// Project task count (for badge on project card).
///
/// Copied from [projectTaskCount].
class ProjectTaskCountProvider extends AutoDisposeStreamProvider<int> {
  /// Project task count (for badge on project card).
  ///
  /// Copied from [projectTaskCount].
  ProjectTaskCountProvider(String projectId)
    : this._internal(
        (ref) => projectTaskCount(ref as ProjectTaskCountRef, projectId),
        from: projectTaskCountProvider,
        name: r'projectTaskCountProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$projectTaskCountHash,
        dependencies: ProjectTaskCountFamily._dependencies,
        allTransitiveDependencies:
            ProjectTaskCountFamily._allTransitiveDependencies,
        projectId: projectId,
      );

  ProjectTaskCountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final String projectId;

  @override
  Override overrideWith(
    Stream<int> Function(ProjectTaskCountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProjectTaskCountProvider._internal(
        (ref) => create(ref as ProjectTaskCountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<int> createElement() {
    return _ProjectTaskCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectTaskCountProvider && other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProjectTaskCountRef on AutoDisposeStreamProviderRef<int> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _ProjectTaskCountProviderElement
    extends AutoDisposeStreamProviderElement<int>
    with ProjectTaskCountRef {
  _ProjectTaskCountProviderElement(super.provider);

  @override
  String get projectId => (origin as ProjectTaskCountProvider).projectId;
}

String _$singleTaskHash() => r'903b7911c819280137daa4fd99851dc5433146c6';

/// Fetches a single task entity by ID.
///
/// Copied from [singleTask].
@ProviderFor(singleTask)
const singleTaskProvider = SingleTaskFamily();

/// Fetches a single task entity by ID.
///
/// Copied from [singleTask].
class SingleTaskFamily extends Family<AsyncValue<TaskEntity?>> {
  /// Fetches a single task entity by ID.
  ///
  /// Copied from [singleTask].
  const SingleTaskFamily();

  /// Fetches a single task entity by ID.
  ///
  /// Copied from [singleTask].
  SingleTaskProvider call(String taskId) {
    return SingleTaskProvider(taskId);
  }

  @override
  SingleTaskProvider getProviderOverride(
    covariant SingleTaskProvider provider,
  ) {
    return call(provider.taskId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'singleTaskProvider';
}

/// Fetches a single task entity by ID.
///
/// Copied from [singleTask].
class SingleTaskProvider extends AutoDisposeFutureProvider<TaskEntity?> {
  /// Fetches a single task entity by ID.
  ///
  /// Copied from [singleTask].
  SingleTaskProvider(String taskId)
    : this._internal(
        (ref) => singleTask(ref as SingleTaskRef, taskId),
        from: singleTaskProvider,
        name: r'singleTaskProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$singleTaskHash,
        dependencies: SingleTaskFamily._dependencies,
        allTransitiveDependencies: SingleTaskFamily._allTransitiveDependencies,
        taskId: taskId,
      );

  SingleTaskProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.taskId,
  }) : super.internal();

  final String taskId;

  @override
  Override overrideWith(
    FutureOr<TaskEntity?> Function(SingleTaskRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SingleTaskProvider._internal(
        (ref) => create(ref as SingleTaskRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        taskId: taskId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TaskEntity?> createElement() {
    return _SingleTaskProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SingleTaskProvider && other.taskId == taskId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, taskId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SingleTaskRef on AutoDisposeFutureProviderRef<TaskEntity?> {
  /// The parameter `taskId` of this provider.
  String get taskId;
}

class _SingleTaskProviderElement
    extends AutoDisposeFutureProviderElement<TaskEntity?>
    with SingleTaskRef {
  _SingleTaskProviderElement(super.provider);

  @override
  String get taskId => (origin as SingleTaskProvider).taskId;
}

String _$taskSearchResultsHash() => r'ad87b0eaac01cbe243261f49de8235815d2144e0';

/// Search results provider.
///
/// Copied from [taskSearchResults].
@ProviderFor(taskSearchResults)
const taskSearchResultsProvider = TaskSearchResultsFamily();

/// Search results provider.
///
/// Copied from [taskSearchResults].
class TaskSearchResultsFamily extends Family<AsyncValue<List<TaskEntity>>> {
  /// Search results provider.
  ///
  /// Copied from [taskSearchResults].
  const TaskSearchResultsFamily();

  /// Search results provider.
  ///
  /// Copied from [taskSearchResults].
  TaskSearchResultsProvider call(String query) {
    return TaskSearchResultsProvider(query);
  }

  @override
  TaskSearchResultsProvider getProviderOverride(
    covariant TaskSearchResultsProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'taskSearchResultsProvider';
}

/// Search results provider.
///
/// Copied from [taskSearchResults].
class TaskSearchResultsProvider
    extends AutoDisposeFutureProvider<List<TaskEntity>> {
  /// Search results provider.
  ///
  /// Copied from [taskSearchResults].
  TaskSearchResultsProvider(String query)
    : this._internal(
        (ref) => taskSearchResults(ref as TaskSearchResultsRef, query),
        from: taskSearchResultsProvider,
        name: r'taskSearchResultsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$taskSearchResultsHash,
        dependencies: TaskSearchResultsFamily._dependencies,
        allTransitiveDependencies:
            TaskSearchResultsFamily._allTransitiveDependencies,
        query: query,
      );

  TaskSearchResultsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<TaskEntity>> Function(TaskSearchResultsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TaskSearchResultsProvider._internal(
        (ref) => create(ref as TaskSearchResultsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TaskEntity>> createElement() {
    return _TaskSearchResultsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskSearchResultsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TaskSearchResultsRef on AutoDisposeFutureProviderRef<List<TaskEntity>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _TaskSearchResultsProviderElement
    extends AutoDisposeFutureProviderElement<List<TaskEntity>>
    with TaskSearchResultsRef {
  _TaskSearchResultsProviderElement(super.provider);

  @override
  String get query => (origin as TaskSearchResultsProvider).query;
}

String _$taskActionsHash() => r'5a91abb711e40d6f9ac9064ee13f29ba8a2a029a';

/// Exposes task mutation actions from the UI layer.
///
/// Copied from [TaskActions].
@ProviderFor(TaskActions)
final taskActionsProvider =
    AutoDisposeNotifierProvider<TaskActions, AsyncValue<void>>.internal(
      TaskActions.new,
      name: r'taskActionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$taskActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TaskActions = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
