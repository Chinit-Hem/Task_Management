import 'package:isar/isar.dart';

part 'task_model.g.dart';

/// Priority levels for tasks
enum Priority {
  low,
  medium,
  high,
}

/// Priority extension for UI display
extension PriorityExtension on Priority {
  String get name {
    switch (this) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
    }
  }

  static Priority fromString(String value) {
    switch (value.toLowerCase()) {
      case 'low':
        return Priority.low;
      case 'medium':
        return Priority.medium;
      case 'high':
        return Priority.high;
      default:
        return Priority.medium;
    }
  }
}

/// TaskModel - Isar collection for task management
///
/// This model represents a task with all required fields for the
/// task management feature. It includes Isar annotations for
/// database persistence.
@collection
class TaskModel {
  /// Auto-increment ID for Isar
  Id id = Isar.autoIncrement;

  /// Task title (required)
  late String title;

  /// Task description (optional)
  String? description;

  /// Task priority level
  @enumerated
  late Priority priority;

  /// Task category (work/personal/urgent/school)
  late String category;

  /// Due date for the task (optional)
  DateTime? dueDate;

  /// Completion status
  bool isCompleted = false;

  /// List of subtasks
  List<String> subtasks = [];

  /// Local file path for task image (optional)
  String? imagePath;

  /// Creation timestamp
  DateTime createdAt = DateTime.now();

  /// Last updated timestamp
  DateTime updatedAt = DateTime.now();

  /// Default constructor
  TaskModel();

  /// Factory constructor for creating tasks
  factory TaskModel.create({
    required String title,
    String? description,
    Priority priority = Priority.medium,
    String category = 'Personal',
    DateTime? dueDate,
    List<String>? subtasks,
    String? imagePath,
  }) {
    final task = TaskModel()
      ..title = title
      ..description = description
      ..priority = priority
      ..category = category
      ..dueDate = dueDate
      ..subtasks = subtasks ?? []
      ..imagePath = imagePath;
    return task;
  }

  /// Copy with method for immutability
  TaskModel copyWith({
    String? title,
    String? description,
    Priority? priority,
    String? category,
    DateTime? dueDate,
    bool? isCompleted,
    List<String>? subtasks,
    String? imagePath,
  }) {
    final task = TaskModel()
      ..id = id
      ..title = title ?? this.title
      ..description = description ?? this.description
      ..priority = priority ?? this.priority
      ..category = category ?? this.category
      ..dueDate = dueDate ?? this.dueDate
      ..isCompleted = isCompleted ?? this.isCompleted
      ..subtasks = subtasks ?? List.from(this.subtasks)
      ..imagePath = imagePath ?? this.imagePath
      ..createdAt = createdAt
      ..updatedAt = DateTime.now();
    return task;
  }

  /// Toggle completion status
  void toggleComplete() {
    isCompleted = !isCompleted;
    updatedAt = DateTime.now();
  }

  /// Get priority color for UI
  int get priorityColorValue {
    switch (priority) {
      case Priority.high:
        return 0xFFF44336; // Red
      case Priority.medium:
        return 0xFFFF9800; // Orange
      case Priority.low:
        return 0xFFFFC107; // Yellow
    }
  }

  /// Get formatted due date string
  String get formattedDueDate {
    if (dueDate == null) return 'No due date';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);

    final difference = due.difference(today).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';
    if (difference > 0 && difference < 7) {
      final weekdays = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      return weekdays[dueDate!.weekday - 1];
    }

    return '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}';
  }

  /// Get formatted due time string
  String get formattedDueTime {
    if (dueDate == null) return '';
    final hour = dueDate!.hour.toString().padLeft(2, '0');
    final minute = dueDate!.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Check if task is overdue
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  /// Get completion progress for subtasks
  double get subtaskProgress {
    if (subtasks.isEmpty) return isCompleted ? 1.0 : 0.0;
    // For now, return 0 or 1 based on completion
    // Can be extended to track individual subtask completion
    return isCompleted ? 1.0 : 0.0;
  }

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, priority: $priority, completed: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
