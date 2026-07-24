// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$preferencesRepositoryHash() =>
    r'5a97d0869fe62f9fa6acaa725e5333d18b4760eb';

/// Provides the PreferencesRepository.
///
/// Copied from [preferencesRepository].
@ProviderFor(preferencesRepository)
final preferencesRepositoryProvider = Provider<PreferencesRepository>.internal(
  preferencesRepository,
  name: r'preferencesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$preferencesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PreferencesRepositoryRef = ProviderRef<PreferencesRepository>;
String _$preferencesNotifierHash() =>
    r'd5c2f058e5287b534f4d63aa40123f7e38d16c44';

/// The primary user preferences notifier.
/// Loaded synchronously from SharedPreferences (already initialized).
///
/// Copied from [PreferencesNotifier].
@ProviderFor(PreferencesNotifier)
final preferencesNotifierProvider =
    NotifierProvider<PreferencesNotifier, UserPrefs>.internal(
      PreferencesNotifier.new,
      name: r'preferencesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$preferencesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PreferencesNotifier = Notifier<UserPrefs>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
