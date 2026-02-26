import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/database_provider.dart';
import '../../data/repositories/task_repository.dart';
import '../../domain/models/task_model.dart';

part 'task_providers.g.dart';

/// Task filter type for filtering tasks
enum TaskFilter {
  all,
  pending,
  completed,
}

/// Search query provider (simple state provider)
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Task filter provider (simple state provider)
final taskFilterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.all);

/// Task repository provider
@Riverpod(keepAlive: true)
Future<TaskRepository> taskRepository(TaskRepositoryRef ref) async {
  final isar = await ref.watch(databaseProvider.future);
  return TaskRepository(isar);
}

/// All tasks provider (auto-refreshable)
@riverpod
Future<List<TaskModel>> allTasks(AllTasksRef ref) async {
  final repository = await ref.watch(taskRepositoryProvider.future);
  return await repository.getAllTasks();
}

/// Pending tasks provider
@riverpod
Future<List<TaskModel>> pendingTasks(PendingTasksRef ref) async {
  final repository = await ref.watch(taskRepositoryProvider.future);
  return await repository.getPendingTasks();
}

/// Completed tasks provider
@riverpod
Future<List<TaskModel>> completedTasks(CompletedTasksRef ref) async {
  final repository = await ref.watch(taskRepositoryProvider.future);
  return await repository.getCompletedTasks();
}

/// Today's tasks provider
@riverpod
Future<List<TaskModel>> todayTasks(TodayTasksRef ref) async {
  final repository = await ref.watch(taskRepositoryProvider.future);
  return await repository.getTodayTasks();
}

/// Task statistics provider
@riverpod
Future<TaskStats> taskStats(TaskStatsRef ref) async {
  final repository = await ref.watch(taskRepositoryProvider.future);
  return await repository.getTaskStats();
}

/// Single task provider (by ID)
@riverpod
Future<TaskModel?> taskById(TaskByIdRef ref, int id) async {
  final repository = await ref.watch(taskRepositoryProvider.future);
  return await repository.getTaskById(id);
}

/// Filtered tasks provider (combines search + filter)
@riverpod
Future<List<TaskModel>> filteredTasks(FilteredTasksRef ref) async {
  final repository = await ref.watch(taskRepositoryProvider.future);
  final searchQuery = ref.watch(searchQueryProvider);
  final filter = ref.watch(taskFilterProvider);

  // Get base list based on filter
  List<TaskModel> tasks;
  switch (filter) {
    case TaskFilter.pending:
      tasks = await repository.getPendingTasks();
      break;
    case TaskFilter.completed:
      tasks = await repository.getCompletedTasks();
      break;
    case TaskFilter.all:
    default:
      tasks = await repository.getAllTasks();
      break;
  }

  // Apply search filter if query exists
  if (searchQuery.isNotEmpty) {
    final query = searchQuery.toLowerCase();
    tasks = tasks.where((task) {
      return task.title.toLowerCase().contains(query) ||
          (task.description?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  return tasks;
}

/// Tasks by date provider
@riverpod
Future<List<TaskModel>> tasksByDate(TasksByDateRef ref, DateTime date) async {
  final repository = await ref.watch(taskRepositoryProvider.future);
  return await repository.getTasksByDate(date);
}

/// Tasks by date range provider (for calendar view)
@riverpod
Future<List<TaskModel>> tasksByDateRange(
  TasksByDateRangeRef ref,
  DateTime start,
  DateTime end,
) async {
  final repository = await ref.watch(taskRepositoryProvider.future);
  return await repository.getTasksByDateRange(start, end);
}

/// Task notifier for CRUD operations
class TaskNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  TaskNotifier(this._ref) : super(const AsyncValue.data(null));

  /// Add a new task
  Future<bool> addTask(TaskModel task) async {
    state = const AsyncValue.loading();
    try {
      final repository = await _ref.read(taskRepositoryProvider.future);
      await repository.addTask(task);
      state = const AsyncValue.data(null);

      // Invalidate providers to refresh UI
      _ref.invalidate(allTasksProvider);
      _ref.invalidate(todayTasksProvider);
      _ref.invalidate(taskStatsProvider);
      _ref.invalidate(filteredTasksProvider);

      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      if (kDebugMode) {
        print('Error adding task: $e');
      }
      return false;
    }
  }

  /// Update an existing task
  Future<bool> updateTask(TaskModel task) async {
    state = const AsyncValue.loading();
    try {
      final repository = await _ref.read(taskRepositoryProvider.future);
      await repository.updateTask(task);
      state = const AsyncValue.data(null);

      // Invalidate providers to refresh UI
      _ref.invalidate(allTasksProvider);
      _ref.invalidate(todayTasksProvider);
      _ref.invalidate(taskStatsProvider);
      _ref.invalidate(filteredTasksProvider);
      _ref.invalidate(taskByIdProvider(task.id));

      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      if (kDebugMode) {
        print('Error updating task: $e');
      }
      return false;
    }
  }

  /// Toggle task completion
  Future<bool> toggleTaskCompletion(int id) async {
    state = const AsyncValue.loading();
    try {
      final repository = await _ref.read(taskRepositoryProvider.future);
      await repository.toggleTaskCompletion(id);
      state = const AsyncValue.data(null);

      // Invalidate providers to refresh UI
      _ref.invalidate(allTasksProvider);
      _ref.invalidate(pendingTasksProvider);
      _ref.invalidate(completedTasksProvider);
      _ref.invalidate(todayTasksProvider);
      _ref.invalidate(taskStatsProvider);
      _ref.invalidate(filteredTasksProvider);
      _ref.invalidate(taskByIdProvider(id));

      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      if (kDebugMode) {
        print('Error toggling task: $e');
      }
      return false;
    }
  }

  /// Delete a task
  Future<bool> deleteTask(int id) async {
    state = const AsyncValue.loading();
    try {
      final repository = await _ref.read(taskRepositoryProvider.future);
      await repository.deleteTask(id);
      state = const AsyncValue.data(null);

      // Invalidate providers to refresh UI
      _ref.invalidate(allTasksProvider);
      _ref.invalidate(pendingTasksProvider);
      _ref.invalidate(completedTasksProvider);
      _ref.invalidate(todayTasksProvider);
      _ref.invalidate(taskStatsProvider);
      _ref.invalidate(filteredTasksProvider);

      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      if (kDebugMode) {
        print('Error deleting task: $e');
      }
      return false;
    }
  }

  /// Clear error state
  void clearError() {
    state = const AsyncValue.data(null);
  }
}

/// Task notifier provider
final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, AsyncValue<void>>((ref) {
  return TaskNotifier(ref);
});
