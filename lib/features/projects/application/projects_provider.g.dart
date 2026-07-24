// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectRepositoryHash() => r'0b1f18d3c09923ddc5d7f5d4f988ee6bdc8734d1';

/// Provides the ProjectRepository.
///
/// Copied from [projectRepository].
@ProviderFor(projectRepository)
final projectRepositoryProvider = Provider<ProjectRepository>.internal(
  projectRepository,
  name: r'projectRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProjectRepositoryRef = ProviderRef<ProjectRepository>;
String _$projectsHash() => r'fbcff582b57c4021f83bdb42f18b272230054fbf';

/// Watch all active projects.
///
/// Copied from [projects].
@ProviderFor(projects)
final projectsProvider =
    AutoDisposeStreamProvider<List<ProjectEntity>>.internal(
      projects,
      name: r'projectsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$projectsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProjectsRef = AutoDisposeStreamProviderRef<List<ProjectEntity>>;
String _$projectActionsHash() => r'438cdd905b48cb88735be4b34a4c8d8b2d19a22d';

/// ProjectActions notifier for mutations.
///
/// Copied from [ProjectActions].
@ProviderFor(ProjectActions)
final projectActionsProvider =
    AutoDisposeNotifierProvider<ProjectActions, AsyncValue<void>>.internal(
      ProjectActions.new,
      name: r'projectActionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$projectActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProjectActions = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
