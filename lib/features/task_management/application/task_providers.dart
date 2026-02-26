import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/database_provider.dart';
import '../domain/models/task_model.dart';

part 'task_providers.g.dart';

/// Provider for all tasks from Isar database
@riverpod
Stream<List<TaskModel>> allTasks(AllTasksRef ref) async* {
  final isar = await ref.watch(databaseProvider.future);

  // Watch for changes in the TaskModel collection
  final query = isar.taskModels.where().watch(fireImmediately: true);

  await for (final tasks in query) {
    if (kDebugMode) {
      print('All tasks updated: ${tasks.length} tasks');
    }
    yield tasks;
  }
}

/// Provider for filtered tasks based on completion status
@riverpod
Future<List<TaskModel>> filteredTasks(
  FilteredTasksRef ref, {
  required TaskFilter filter,
  String searchQuery = '',
}) async {
  final isar = await ref.watch(databaseProvider.future);

  // Build query based on filter
  Query<TaskModel> query;

  switch (filter) {
    case TaskFilter.pending:
      query = isar.taskModels.filter().isCompletedEqualTo(false).build();
      break;
    case TaskFilter.completed:
      query = isar.taskModels.filter().isCompletedEqualTo(true).build();
      break;
    case TaskFilter.all:
    default:
      query = isar.taskModels.where().build();
      break;
  }

  final tasks = await query.findAll();

  // Apply search filter if provided
  if (searchQuery.isNotEmpty) {
    final lowerQuery = searchQuery.toLowerCase();
    return tasks.where((task) {
      return task.title.toLowerCase().contains(lowerQuery) ||
          (task.description?.toLowerCase().contains(lowerQuery) ?? false) ||
          task.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Sort by priority (high -> medium -> low) and then by due date
  tasks.sort((a, b) {
    // First sort by completion (pending first)
    if (a.isCompleted != b.isCompleted) {
      return a.isCompleted ? 1 : -1;
    }

    // Then by priority (high = 2, medium = 1, low = 0)
    final priorityCompare = b.priority.index.compareTo(a.priority.index);
    if (priorityCompare != 0) return priorityCompare;

    // Then by due date (earlier first)
    if (a.dueDate != null && b.dueDate != null) {
      return a.dueDate!.compareTo(b.dueDate!);
    }
    if (a.dueDate != null) return -1;
    if (b.dueDate != null) return 1;

    return 0;
  });

  return tasks;
}

/// Provider for today's tasks
@riverpod
Future<List<TaskModel>> todaysTasks(TodaysTasksRef ref) async {
  final isar = await ref.watch(databaseProvider.future);

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));

  return await isar.taskModels
      .filter()
      .isCompletedEqualTo(false)
      .dueDateBetween(today, tomorrow)
      .findAll();
}

/// Provider for task statistics
@riverpod
Future<TaskStats> taskStats(TaskStatsRef ref) async {
  final isar = await ref.watch(databaseProvider.future);

  final total = await isar.taskModels.count();
  final completed =
      await isar.taskModels.filter().isCompletedEqualTo(true).count();
  final pending = total - completed;

  // High priority pending tasks
  final highPriority = await isar.taskModels
      .filter()
      .isCompletedEqualTo(false)
      .priorityEqualTo(Priority.high)
      .count();

  return TaskStats(
    total: total,
    completed: completed,
    pending: pending,
    highPriority: highPriority,
  );
}

/// Provider for a single task by ID
@riverpod
Future<TaskModel?> taskById(TaskByIdRef ref, int id) async {
  final isar = await ref.watch(databaseProvider.future);
  return await isar.taskModels.get(id);
}

/// Notifier for task operations (add, update, delete)
@riverpod
class TaskNotifier extends _$TaskNotifier {
  @override
  Future<void> build() async {
    // Initial state - nothing to do
    return;
  }

  /// Add a new task to Isar
  Future<bool> addTask(TaskModel task) async {
    final isar = await ref.read(databaseProvider.future);

    try {
      await isar.writeTxn(() async {
        await isar.taskModels.put(task);
      });

      // Invalidate related providers to refresh UI
      ref.invalidate(allTasksProvider);
      ref.invalidate(taskStatsProvider);

      return true;
    } catch (e, stackTrace) {
      // Log error in all modes for debugging
      print('ERROR adding task: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }


  /// Update an existing task
  Future<bool> updateTask(TaskModel task) async {
    final isar = await ref.read(databaseProvider.future);

    try {
      task.updatedAt = DateTime.now();

      await isar.writeTxn(() async {
        await isar.taskModels.put(task);
      });

      // Invalidate related providers
      ref.invalidate(allTasksProvider);
      ref.invalidate(taskStatsProvider);
      ref.invalidate(taskByIdProvider(task.id));

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating task: $e');
      }
      return false;
    }
  }

  /// Toggle task completion status
  Future<bool> toggleTaskCompletion(int taskId) async {
    final isar = await ref.read(databaseProvider.future);

    try {
      await isar.writeTxn(() async {
        final task = await isar.taskModels.get(taskId);
        if (task != null) {
          task.toggleComplete();
          await isar.taskModels.put(task);
        }
      });

      // Invalidate related providers
      ref.invalidate(allTasksProvider);
      ref.invalidate(taskStatsProvider);
      ref.invalidate(taskByIdProvider(taskId));

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling task: $e');
      }
      return false;
    }
  }

  /// Delete a task
  Future<bool> deleteTask(int taskId) async {
    final isar = await ref.read(databaseProvider.future);

    try {
      await isar.writeTxn(() async {
        await isar.taskModels.delete(taskId);
      });

      // Invalidate related providers
      ref.invalidate(allTasksProvider);
      ref.invalidate(taskStatsProvider);

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting task: $e');
      }
      return false;
    }
  }
}

/// Enum for task filtering
enum TaskFilter {
  all,
  pending,
  completed,
}

/// Statistics model for tasks
class TaskStats {
  final int total;
  final int completed;
  final int pending;
  final int highPriority;

  const TaskStats({
    required this.total,
    required this.completed,
    required this.pending,
    required this.highPriority,
  });

  double get completionRate => total > 0 ? completed / total : 0.0;

  @override
  String toString() {
    return 'TaskStats(total: $total, completed: $completed, pending: $pending, highPriority: $highPriority)';
  }
}

/// Search query provider (for UI state)
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Selected filter provider (for UI state)
final selectedFilterProvider =
    StateProvider<TaskFilter>((ref) => TaskFilter.all);
