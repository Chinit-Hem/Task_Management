import 'package:isar/isar.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/providers/database_provider.dart';
import '../../domain/models/task_model.dart';

class TaskRepository {
  final Isar _isar;

  TaskRepository(this._isar);

  Future<List<TaskModel>> getAllTasks() async {
    return await _isar.taskModels.where().findAll();
  }

  Future<List<TaskModel>> getTasksByCompletion(bool isCompleted) async {
    return await _isar.taskModels
        .filter()
        .isCompletedEqualTo(isCompleted)
        .findAll();
  }

  Future<List<TaskModel>> getPendingTasks() async {
    return await getTasksByCompletion(false);
  }

  Future<List<TaskModel>> getCompletedTasks() async {
    return await getTasksByCompletion(true);
  }

  Future<List<TaskModel>> getTasksByPriority(Priority priority) async {
    return await _isar.taskModels.filter().priorityEqualTo(priority).findAll();
  }

  Future<List<TaskModel>> getTasksByCategory(String category) async {
    return await _isar.taskModels.filter().categoryEqualTo(category).findAll();
  }

  Future<List<TaskModel>> getTasksByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return await _isar.taskModels
        .filter()
        .dueDateBetween(startOfDay, endOfDay)
        .findAll();
  }

  Future<List<TaskModel>> getTasksByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _isar.taskModels
        .filter()
        .dueDateBetween(startDate, endDate)
        .findAll();
  }

  Future<List<TaskModel>> getOverdueTasks() async {
    final now = DateTime.now();
    return await _isar.taskModels
        .filter()
        .dueDateLessThan(now)
        .isCompletedEqualTo(false)
        .findAll();
  }

  Future<List<TaskModel>> getTodayTasks() async {
    return await getTasksByDate(DateTime.now());
  }

  Future<List<TaskModel>> searchTasks(String query) async {
    if (query.isEmpty) return await getAllTasks();

    return await _isar.taskModels
        .filter()
        .titleContains(query, caseSensitive: false)
        .or()
        .descriptionContains(query, caseSensitive: false)
        .findAll();
  }

  Future<TaskModel?> getTaskById(int id) async {
    return await _isar.taskModels.get(id);
  }

  Future<int> addTask(TaskModel task) async {
    int id = 0;
    await _isar.writeTxn(() async {
      id = await _isar.taskModels.put(task);
    });
    if (kDebugMode) {
      print('Task added with ID: $id');
    }
    return id;
  }

  Future<int> updateTask(TaskModel task) async {
    task.updatedAt = DateTime.now();
    int id = 0;
    await _isar.writeTxn(() async {
      id = await _isar.taskModels.put(task);
    });
    if (kDebugMode) {
      print('Task updated with ID: $id');
    }
    return id;
  }

  Future<void> toggleTaskCompletion(int id) async {
    await _isar.writeTxn(() async {
      final task = await _isar.taskModels.get(id);
      if (task != null) {
        task.toggleComplete();
        await _isar.taskModels.put(task);
      }
    });
  }

  Future<bool> deleteTask(int id) async {
    bool deleted = false;
    await _isar.writeTxn(() async {
      deleted = await _isar.taskModels.delete(id);
    });
    if (kDebugMode) {
      print('Task deleted: $deleted');
    }
    return deleted;
  }

  Future<int> deleteTasks(List<int> ids) async {
    int count = 0;
    await _isar.writeTxn(() async {
      count = await _isar.taskModels.deleteAll(ids);
    });
    return count;
  }

  Future<TaskStats> getTaskStats() async {
    final total = await _isar.taskModels.count();
    final completed =
        await _isar.taskModels.filter().isCompletedEqualTo(true).count();
    final pending = total - completed;

    final highPriority = await _isar.taskModels
        .filter()
        .priorityEqualTo(Priority.high)
        .isCompletedEqualTo(false)
        .count();

    final overdue = await _isar.taskModels
        .filter()
        .dueDateLessThan(DateTime.now())
        .isCompletedEqualTo(false)
        .count();

    return TaskStats(
      total: total,
      completed: completed,
      pending: pending,
      highPriority: highPriority,
      overdue: overdue,
    );
  }

  Stream<List<TaskModel>> watchAllTasks() {
    return _isar.taskModels.where().watch(fireImmediately: true);
  }

  Stream<List<TaskModel>> watchTasksByCompletion(bool isCompleted) {
    return _isar.taskModels
        .filter()
        .isCompletedEqualTo(isCompleted)
        .watch(fireImmediately: true);
  }

  Stream<List<TaskModel>> watchTodayTasks() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return _isar.taskModels
        .filter()
        .dueDateBetween(startOfDay, endOfDay)
        .watch(fireImmediately: true);
  }

  Future<void> clearAllTasks() async {
    await _isar.writeTxn(() async {
      await _isar.taskModels.clear();
    });
  }

  Future<void> addSampleTasks(List<TaskModel> tasks) async {
    await _isar.writeTxn(() async {
      for (final task in tasks) {
        await _isar.taskModels.put(task);
      }
    });
  }
}

class TaskStats {
  final int total;
  final int completed;
  final int pending;
  final int highPriority;
  final int overdue;

  TaskStats({
    required this.total,
    required this.completed,
    required this.pending,
    required this.highPriority,
    required this.overdue,
  });

  double get completionRate => total > 0 ? completed / total : 0.0;

  @override
  String toString() {
    return 'TaskStats(total: $total, completed: $completed, pending: $pending)';
  }
}
