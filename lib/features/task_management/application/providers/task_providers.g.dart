// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskRepositoryHash() => r'0622620a5c2cd4c5cff08378ad0afa86cb18d1ef';

/// Task repository provider
///
/// Copied from [taskRepository].
@ProviderFor(taskRepository)
final taskRepositoryProvider = FutureProvider<TaskRepository>.internal(
  taskRepository,
  name: r'taskRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TaskRepositoryRef = FutureProviderRef<TaskRepository>;
String _$allTasksHash() => r'0d0f41bef8f875e066cacd2de3ed51cc1475f020';

/// All tasks provider (auto-refreshable)
///
/// Copied from [allTasks].
@ProviderFor(allTasks)
final allTasksProvider = AutoDisposeFutureProvider<List<TaskModel>>.internal(
  allTasks,
  name: r'allTasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllTasksRef = AutoDisposeFutureProviderRef<List<TaskModel>>;
String _$pendingTasksHash() => r'7d0383cb2d712eaed2a6581960172184687fe44c';

/// Pending tasks provider
///
/// Copied from [pendingTasks].
@ProviderFor(pendingTasks)
final pendingTasksProvider =
    AutoDisposeFutureProvider<List<TaskModel>>.internal(
  pendingTasks,
  name: r'pendingTasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pendingTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PendingTasksRef = AutoDisposeFutureProviderRef<List<TaskModel>>;
String _$completedTasksHash() => r'7ffbf9036698b15ca618dd8480e7eb8022b77bf3';

/// Completed tasks provider
///
/// Copied from [completedTasks].
@ProviderFor(completedTasks)
final completedTasksProvider =
    AutoDisposeFutureProvider<List<TaskModel>>.internal(
  completedTasks,
  name: r'completedTasksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$completedTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CompletedTasksRef = AutoDisposeFutureProviderRef<List<TaskModel>>;
String _$todayTasksHash() => r'ab034fcef8370b285fe8722d9bdb4b9e196652ff';

/// Today's tasks provider
///
/// Copied from [todayTasks].
@ProviderFor(todayTasks)
final todayTasksProvider = AutoDisposeFutureProvider<List<TaskModel>>.internal(
  todayTasks,
  name: r'todayTasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todayTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TodayTasksRef = AutoDisposeFutureProviderRef<List<TaskModel>>;
String _$taskStatsHash() => r'1c641ec03e5c373f5a0475e6468cb50035154950';

/// Task statistics provider
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
String _$taskByIdHash() => r'fed18a72a2d84f4375f2f4131dcc22a476365e35';

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

/// Single task provider (by ID)
///
/// Copied from [taskById].
@ProviderFor(taskById)
const taskByIdProvider = TaskByIdFamily();

/// Single task provider (by ID)
///
/// Copied from [taskById].
class TaskByIdFamily extends Family<AsyncValue<TaskModel?>> {
  /// Single task provider (by ID)
  ///
  /// Copied from [taskById].
  const TaskByIdFamily();

  /// Single task provider (by ID)
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

/// Single task provider (by ID)
///
/// Copied from [taskById].
class TaskByIdProvider extends AutoDisposeFutureProvider<TaskModel?> {
  /// Single task provider (by ID)
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

String _$filteredTasksHash() => r'578b78d044aad936f5b05cd660d57afea3f7fc6d';

/// Filtered tasks provider (combines search + filter)
///
/// Copied from [filteredTasks].
@ProviderFor(filteredTasks)
final filteredTasksProvider =
    AutoDisposeFutureProvider<List<TaskModel>>.internal(
  filteredTasks,
  name: r'filteredTasksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilteredTasksRef = AutoDisposeFutureProviderRef<List<TaskModel>>;
String _$tasksByDateHash() => r'54f4a3951385afc25fb2a0366d42d4feb88abbb4';

/// Tasks by date provider
///
/// Copied from [tasksByDate].
@ProviderFor(tasksByDate)
const tasksByDateProvider = TasksByDateFamily();

/// Tasks by date provider
///
/// Copied from [tasksByDate].
class TasksByDateFamily extends Family<AsyncValue<List<TaskModel>>> {
  /// Tasks by date provider
  ///
  /// Copied from [tasksByDate].
  const TasksByDateFamily();

  /// Tasks by date provider
  ///
  /// Copied from [tasksByDate].
  TasksByDateProvider call(
    DateTime date,
  ) {
    return TasksByDateProvider(
      date,
    );
  }

  @override
  TasksByDateProvider getProviderOverride(
    covariant TasksByDateProvider provider,
  ) {
    return call(
      provider.date,
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
  String? get name => r'tasksByDateProvider';
}

/// Tasks by date provider
///
/// Copied from [tasksByDate].
class TasksByDateProvider extends AutoDisposeFutureProvider<List<TaskModel>> {
  /// Tasks by date provider
  ///
  /// Copied from [tasksByDate].
  TasksByDateProvider(
    DateTime date,
  ) : this._internal(
          (ref) => tasksByDate(
            ref as TasksByDateRef,
            date,
          ),
          from: tasksByDateProvider,
          name: r'tasksByDateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tasksByDateHash,
          dependencies: TasksByDateFamily._dependencies,
          allTransitiveDependencies:
              TasksByDateFamily._allTransitiveDependencies,
          date: date,
        );

  TasksByDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    FutureOr<List<TaskModel>> Function(TasksByDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TasksByDateProvider._internal(
        (ref) => create(ref as TasksByDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TaskModel>> createElement() {
    return _TasksByDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TasksByDateProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TasksByDateRef on AutoDisposeFutureProviderRef<List<TaskModel>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _TasksByDateProviderElement
    extends AutoDisposeFutureProviderElement<List<TaskModel>>
    with TasksByDateRef {
  _TasksByDateProviderElement(super.provider);

  @override
  DateTime get date => (origin as TasksByDateProvider).date;
}

String _$tasksByDateRangeHash() => r'f166f0ab9497cef48464ba0fabc5f83a457f3af4';

/// Tasks by date range provider (for calendar view)
///
/// Copied from [tasksByDateRange].
@ProviderFor(tasksByDateRange)
const tasksByDateRangeProvider = TasksByDateRangeFamily();

/// Tasks by date range provider (for calendar view)
///
/// Copied from [tasksByDateRange].
class TasksByDateRangeFamily extends Family<AsyncValue<List<TaskModel>>> {
  /// Tasks by date range provider (for calendar view)
  ///
  /// Copied from [tasksByDateRange].
  const TasksByDateRangeFamily();

  /// Tasks by date range provider (for calendar view)
  ///
  /// Copied from [tasksByDateRange].
  TasksByDateRangeProvider call(
    DateTime start,
    DateTime end,
  ) {
    return TasksByDateRangeProvider(
      start,
      end,
    );
  }

  @override
  TasksByDateRangeProvider getProviderOverride(
    covariant TasksByDateRangeProvider provider,
  ) {
    return call(
      provider.start,
      provider.end,
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
  String? get name => r'tasksByDateRangeProvider';
}

/// Tasks by date range provider (for calendar view)
///
/// Copied from [tasksByDateRange].
class TasksByDateRangeProvider
    extends AutoDisposeFutureProvider<List<TaskModel>> {
  /// Tasks by date range provider (for calendar view)
  ///
  /// Copied from [tasksByDateRange].
  TasksByDateRangeProvider(
    DateTime start,
    DateTime end,
  ) : this._internal(
          (ref) => tasksByDateRange(
            ref as TasksByDateRangeRef,
            start,
            end,
          ),
          from: tasksByDateRangeProvider,
          name: r'tasksByDateRangeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tasksByDateRangeHash,
          dependencies: TasksByDateRangeFamily._dependencies,
          allTransitiveDependencies:
              TasksByDateRangeFamily._allTransitiveDependencies,
          start: start,
          end: end,
        );

  TasksByDateRangeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.start,
    required this.end,
  }) : super.internal();

  final DateTime start;
  final DateTime end;

  @override
  Override overrideWith(
    FutureOr<List<TaskModel>> Function(TasksByDateRangeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TasksByDateRangeProvider._internal(
        (ref) => create(ref as TasksByDateRangeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        start: start,
        end: end,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TaskModel>> createElement() {
    return _TasksByDateRangeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TasksByDateRangeProvider &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, start.hashCode);
    hash = _SystemHash.combine(hash, end.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TasksByDateRangeRef on AutoDisposeFutureProviderRef<List<TaskModel>> {
  /// The parameter `start` of this provider.
  DateTime get start;

  /// The parameter `end` of this provider.
  DateTime get end;
}

class _TasksByDateRangeProviderElement
    extends AutoDisposeFutureProviderElement<List<TaskModel>>
    with TasksByDateRangeRef {
  _TasksByDateRangeProviderElement(super.provider);

  @override
  DateTime get start => (origin as TasksByDateRangeProvider).start;
  @override
  DateTime get end => (origin as TasksByDateRangeProvider).end;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
