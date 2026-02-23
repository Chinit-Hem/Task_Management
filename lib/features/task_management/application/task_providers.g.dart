// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allTasksHash() => r'4d81f810f3a98b5e0b74dc03e1de4ab352bf0165';

/// Provider for all tasks from Isar database
///
/// Copied from [allTasks].
@ProviderFor(allTasks)
final allTasksProvider = AutoDisposeStreamProvider<List<TaskModel>>.internal(
  allTasks,
  name: r'allTasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllTasksRef = AutoDisposeStreamProviderRef<List<TaskModel>>;
String _$filteredTasksHash() => r'043b081bfc2fc0e2fe743f213f35224545fd9a12';

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

/// Provider for filtered tasks based on completion status
///
/// Copied from [filteredTasks].
@ProviderFor(filteredTasks)
const filteredTasksProvider = FilteredTasksFamily();

/// Provider for filtered tasks based on completion status
///
/// Copied from [filteredTasks].
class FilteredTasksFamily extends Family<AsyncValue<List<TaskModel>>> {
  /// Provider for filtered tasks based on completion status
  ///
  /// Copied from [filteredTasks].
  const FilteredTasksFamily();

  /// Provider for filtered tasks based on completion status
  ///
  /// Copied from [filteredTasks].
  FilteredTasksProvider call({
    required TaskFilter filter,
    String searchQuery = '',
  }) {
    return FilteredTasksProvider(
      filter: filter,
      searchQuery: searchQuery,
    );
  }

  @override
  FilteredTasksProvider getProviderOverride(
    covariant FilteredTasksProvider provider,
  ) {
    return call(
      filter: provider.filter,
      searchQuery: provider.searchQuery,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'filteredTasksProvider';
}

/// Provider for filtered tasks based on completion status
///
/// Copied from [filteredTasks].
class FilteredTasksProvider extends AutoDisposeFutureProvider<List<TaskModel>> {
  /// Provider for filtered tasks based on completion status
  ///
  /// Copied from [filteredTasks].
  FilteredTasksProvider({
    required TaskFilter filter,
    String searchQuery = '',
  }) : this._internal(
          (ref) => filteredTasks(
            ref as FilteredTasksRef,
            filter: filter,
            searchQuery: searchQuery,
          ),
          from: filteredTasksProvider,
          name: r'filteredTasksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredTasksHash,
          dependencies: FilteredTasksFamily._dependencies,
          allTransitiveDependencies:
              FilteredTasksFamily._allTransitiveDependencies,
          filter: filter,
          searchQuery: searchQuery,
        );

  FilteredTasksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filter,
    required this.searchQuery,
  }) : super.internal();

  final TaskFilter filter;
  final String searchQuery;

  @override
  Override overrideWith(
    FutureOr<List<TaskModel>> Function(FilteredTasksRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredTasksProvider._internal(
        (ref) => create(ref as FilteredTasksRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filter: filter,
        searchQuery: searchQuery,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TaskModel>> createElement() {
    return _FilteredTasksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredTasksProvider &&
        other.filter == filter &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FilteredTasksRef on AutoDisposeFutureProviderRef<List<TaskModel>> {
  /// The parameter `filter` of this provider.
  TaskFilter get filter;

  /// The parameter `searchQuery` of this provider.
  String get searchQuery;
}

class _FilteredTasksProviderElement
    extends AutoDisposeFutureProviderElement<List<TaskModel>>
    with FilteredTasksRef {
  _FilteredTasksProviderElement(super.provider);

  @override
  TaskFilter get filter => (origin as FilteredTasksProvider).filter;
  @override
  String get searchQuery => (origin as FilteredTasksProvider).searchQuery;
}

String _$todaysTasksHash() => r'a7022f144f996d21910fbc444779d6a02acd3454';

/// Provider for today's tasks
///
/// Copied from [todaysTasks].
@ProviderFor(todaysTasks)
final todaysTasksProvider = AutoDisposeFutureProvider<List<TaskModel>>.internal(
  todaysTasks,
  name: r'todaysTasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todaysTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TodaysTasksRef = AutoDisposeFutureProviderRef<List<TaskModel>>;
String _$taskStatsHash() => r'afe1591af7247785fe3757090b21a9e81c16874e';

/// Provider for task statistics
///
/// Copied from [taskStats].
@ProviderFor(taskStats)
final taskStatsProvider = AutoDisposeFutureProvider<TaskStats>.internal(
  taskStats,
  name: r'taskStatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$taskStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TaskStatsRef = AutoDisposeFutureProviderRef<TaskStats>;
String _$taskByIdHash() => r'91a5b80210f0a7a0d9a8c7725c14fd7f01ebc969';

/// Provider for a single task by ID
///
/// Copied from [taskById].
@ProviderFor(taskById)
const taskByIdProvider = TaskByIdFamily();

/// Provider for a single task by ID
///
/// Copied from [taskById].
class TaskByIdFamily extends Family<AsyncValue<TaskModel?>> {
  /// Provider for a single task by ID
  ///
  /// Copied from [taskById].
  const TaskByIdFamily();

  /// Provider for a single task by ID
  ///
  /// Copied from [taskById].
  TaskByIdProvider call(
    int id,
  ) {
    return TaskByIdProvider(
      id,
    );
  }

  @override
  TaskByIdProvider getProviderOverride(
    covariant TaskByIdProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'taskByIdProvider';
}

/// Provider for a single task by ID
///
/// Copied from [taskById].
class TaskByIdProvider extends AutoDisposeFutureProvider<TaskModel?> {
  /// Provider for a single task by ID
  ///
  /// Copied from [taskById].
  TaskByIdProvider(
    int id,
  ) : this._internal(
          (ref) => taskById(
            ref as TaskByIdRef,
            id,
          ),
          from: taskByIdProvider,
          name: r'taskByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$taskByIdHash,
          dependencies: TaskByIdFamily._dependencies,
          allTransitiveDependencies: TaskByIdFamily._allTransitiveDependencies,
          id: id,
        );

  TaskByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<TaskModel?> Function(TaskByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TaskByIdProvider._internal(
        (ref) => create(ref as TaskByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TaskModel?> createElement() {
    return _TaskByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TaskByIdRef on AutoDisposeFutureProviderRef<TaskModel?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _TaskByIdProviderElement
    extends AutoDisposeFutureProviderElement<TaskModel?> with TaskByIdRef {
  _TaskByIdProviderElement(super.provider);

  @override
  int get id => (origin as TaskByIdProvider).id;
}

String _$taskNotifierHash() => r'64a21322869a99ae2cd44c6a93e918bf6c05152e';

/// Notifier for task operations (add, update, delete)
///
/// Copied from [TaskNotifier].
@ProviderFor(TaskNotifier)
final taskNotifierProvider =
    AutoDisposeAsyncNotifierProvider<TaskNotifier, void>.internal(
  TaskNotifier.new,
  name: r'taskNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$taskNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TaskNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
