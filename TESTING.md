# Task Management Module - Testing & QA Documentation

## Table of Contents
1. [Documented Bugs & Fixes](#documented-bugs--fixes)
2. [Manual Test Cases](#manual-test-cases)
3. [Unit Test Examples](#unit-test-examples)
4. [Integration Testing Guide](#integration-testing-guide)

---

## Documented Bugs & Fixes

### Bug #1: Checkbox Not Updating UI After Isar Save

**Description:**  
When toggling a task's completion status, the checkbox UI doesn't update immediately after the Isar database operation completes.

**Root Cause:**  
The Riverpod provider wasn't being invalidated after the database write transaction, so the UI was still showing stale data.

**Fix:**
```dart
// In task_providers.dart - TaskNotifier class
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
    
    // Invalidate providers to refresh UI
    ref.invalidate(allTasksProvider);
    ref.invalidate(taskStatsProvider);
    ref.invalidate(taskByIdProvider(taskId));  // <-- Added this line
    
    return true;
  } catch (e) {
    return false;
  }
}
```

**Prevention:**  
Always invalidate specific providers after database mutations to ensure UI consistency.

---

### Bug #2: Image Path Lost on Task Edit

**Description:**  
When editing a task, the previously saved image path was being reset to null.

**Root Cause:**  
The `copyWith` method in TaskModel wasn't preserving the `imagePath` field when other fields were updated.

**Fix:**
```dart
// In add_task_screen.dart - _saveTask method
final task = _isEditing
    ? widget.taskToEdit!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
        category: _selectedCategory,
        dueDate: finalDueDate,
        imagePath: _imagePath,  // <-- Explicitly preserve imagePath
        subtasks: List.from(_subtasks),
      )
    : TaskModel.create(...);
```

**Prevention:**  
Always verify all fields are properly handled in `copyWith` operations, especially optional fields.

---

### Bug #3: Calendar Not Reflecting New Tasks Immediately

**Description:**  
After adding a new task from the Plan screen, the calendar markers don't update until the screen is reopened.

**Root Cause:**  
The `allTasksProvider` stream wasn't being properly listened to in the PlanScreen widget lifecycle.

**Fix:**
```dart
// In plan_screen.dart - build method
final allTasksAsync = ref.watch(allTasksProvider);

// Ensure the provider is properly watched
return allTasksAsync.when(
  data: (tasks) {
    // Use tasks for calendar markers
    return _buildCalendar(tasks);
  },
  loading: () => const CircularProgressIndicator(),
  error: (error, stack) => _buildError(error),
);
```

**Prevention:**  
Use `ref.watch()` instead of `ref.read()` for stream-based providers to ensure reactive updates.

---

## Manual Test Cases

### Test Case 1: Add New Task Flow

| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Tap FAB "+" on Home screen | Navigate to Add Task screen | ⏳ |
| 2 | Leave title empty, tap Save | Show validation error | ⏳ |
| 3 | Enter title "Buy groceries" | Title accepted | ⏳ |
| 4 | Select priority "High" | High button highlighted blue | ⏳ |
| 5 | Select category "Personal" | Personal chip selected | ⏳ |
| 6 | Set due date to tomorrow | Date displayed | ⏳ |
| 7 | Add subtask "Buy milk" | Subtask appears in list | ⏳ |
| 8 | Tap Save button | Task saved, return to Home | ⏳ |
| 9 | Verify task appears in list | Task visible with correct details | ⏳ |

---

### Test Case 2: Mark Task Complete

| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Navigate to List screen | All tasks displayed | ⏳ |
| 2 | Tap checkbox on pending task | Checkbox checked, strikethrough on title | ⏳ |
| 3 | Verify snackbar appears | "Task completed!" message shown | ⏳ |
| 4 | Check stats update | Completed count increased by 1 | ⏳ |
| 5 | Switch to Completed tab | Task appears in completed list | ⏳ |
| 6 | Tap checkbox again | Task returns to pending state | ⏳ |

---

### Test Case 3: Search and Filter

| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Type "work" in search bar | List filters to matching tasks | ⏳ |
| 2 | Clear search | All tasks shown again | ⏳ |
| 3 | Tap "Pending" tab | Only pending tasks shown | ⏳ |
| 4 | Search within pending | Results filtered from pending only | ⏳ |
| 5 | Switch to "Completed" tab | Search cleared, completed tasks shown | ⏳ |

---

### Test Case 4: Image Upload

| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Open Add Task screen | Form displayed | ⏳ |
| 2 | Tap "Add Image" button | Image picker opens | ⏳ |
| 3 | Select image from gallery | Image preview shown | ⏳ |
| 4 | Save task | Task saved with image | ⏳ |
| 5 | Open task detail | Image displayed in header | ⏳ |
| 6 | Tap image | Hero animation to full view | ⏳ |

---

### Test Case 5: Calendar Integration

| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Navigate to Plan screen | Calendar displayed | ⏳ |
| 2 | Select date with tasks | Task count badge shown | ⏳ |
| 3 | Verify task colors | High=red, Medium=orange, Low=yellow | ⏳ |
| 4 | Tap on task in timeline | Navigate to task detail | ⏳ |
| 5 | Add task from Plan screen | New task appears on calendar | ⏳ |

---

### Test Case 6: Profile Management

| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Navigate to Profile screen | User info displayed | ⏳ |
| 2 | Tap edit icon | Fields become editable | ⏳ |
| 3 | Change name | Name updated in real-time | ⏳ |
| 4 | Tap avatar | Image picker opens | ⏳ |
| 5 | Select new avatar | Avatar updated | ⏳ |
| 6 | Tap check to save | "Profile updated" toast shown | ⏳ |
| 7 | Toggle dark mode | Theme switches (if implemented) | ⏳ |

---

## Unit Test Examples

### Example 1: Task Repository Save & Fetch

```dart
// test/task_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_management/features/task_management/domain/models/task_model.dart';

void main() {
  late Isar isar;

  setUpAll(() async {
    // Initialize Isar for testing
    final dir = await getTemporaryDirectory();
    isar = await Isar.open(
      [TaskModelSchema],
      directory: dir.path,
    );
  });

  tearDownAll(() async {
    await isar.close();
  });

  group('TaskModel Repository Tests', () {
    test('should save and retrieve a task', () async {
      // Arrange
      final task = TaskModel.create(
        title: 'Test Task',
        description: 'Test Description',
        priority: Priority.high,
        category: 'Work',
      );

      // Act
      await isar.writeTxn(() async {
        await isar.taskModels.put(task);
      });

      final savedTask = await isar.taskModels.get(task.id);

      // Assert
      expect(savedTask, isNotNull);
      expect(savedTask!.title, equals('Test Task'));
      expect(savedTask.priority, equals(Priority.high));
    });

    test('should update task completion status', () async {
      // Arrange
      final task = TaskModel.create(
        title: 'Complete Me',
        priority: Priority.medium,
      );

      await isar.writeTxn(() async {
        await isar.taskModels.put(task);
      });

      // Act
      await isar.writeTxn(() async {
        final fetched = await isar.taskModels.get(task.id);
        fetched!.toggleComplete();
        await isar.taskModels.put(fetched);
      });

      final updated = await isar.taskModels.get(task.id);

      // Assert
      expect(updated!.isCompleted, isTrue);
    });

    test('should filter tasks by completion status', () async {
      // Arrange
      final pendingTask = TaskModel.create(
        title: 'Pending',
        priority: Priority.low,
      );
      final completedTask = TaskModel.create(
        title: 'Completed',
        priority: Priority.high,
      )..isCompleted = true;

      await isar.writeTxn(() async {
        await isar.taskModels.put(pendingTask);
        await isar.taskModels.put(completedTask);
      });

      // Act
      final pending = await isar.taskModels
          .filter()
          .isCompletedEqualTo(false)
          .findAll();
      
      final completed = await isar.taskModels
          .filter()
          .isCompletedEqualTo(true)
          .findAll();

      // Assert
      expect(pending.length, equals(1));
      expect(pending.first.title, equals('Pending'));
      expect(completed.length, equals(1));
      expect(completed.first.title, equals('Completed'));
    });

    test('should delete a task', () async {
      // Arrange
      final task = TaskModel.create(title: 'To Delete');
      
      await isar.writeTxn(() async {
        await isar.taskModels.put(task);
      });

      // Act
      await isar.writeTxn(() async {
        await isar.taskModels.delete(task.id);
      });

      final deleted = await isar.taskModels.get(task.id);

      // Assert
      expect(deleted, isNull);
    });
  });
}
```

### Example 2: Task Stats Calculation

```dart
// test/task_stats_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:task_management/features/task_management/application/task_providers.dart';

void main() {
  group('TaskStats Tests', () {
    test('should calculate completion rate correctly', () {
      // Arrange
      const stats = TaskStats(
        total: 10,
        completed: 7,
        pending: 3,
        highPriority: 2,
      );

      // Act & Assert
      expect(stats.completionRate, equals(0.7));
    });

    test('should handle zero tasks', () {
      // Arrange
      const stats = TaskStats(
        total: 0,
        completed: 0,
        pending: 0,
        highPriority: 0,
      );

      // Act & Assert
      expect(stats.completionRate, equals(0.0));
    });

    test('should verify stats consistency', () {
      // Arrange
      const stats = TaskStats(
        total: 15,
        completed: 10,
        pending: 5,
        highPriority: 3,
      );

      // Assert
      expect(stats.total, equals(stats.completed + stats.pending));
    });
  });
}
```

---

## Integration Testing Guide

### Running Integration Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/task_repository_test.dart

# Run integration tests on device
flutter test integration_test/app_test.dart
```

### Integration Test Example

```dart
// integration_test/app_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:task_management/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Task Management App Integration Tests', () {
    testWidgets('add task flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify home screen
      expect(find.text("Today's Tasks"), findsOneWidget);

      // Tap add button
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Enter task details
      await tester.enterText(
        find.byType(TextFormField).first,
        'Integration Test Task',
      );
      
      // Save task
      await tester.tap(find.text('Save Task'));
      await tester.pumpAndSettle();

      // Verify task appears
      expect(find.text('Integration Test Task'), findsOneWidget);
    });
  });
}
```

---

## Performance Testing Checklist

- [ ] App launches within 2 seconds
- [ ] List scrolls at 60 FPS with 100+ tasks
- [ ] Calendar renders within 500ms
- [ ] Image loading doesn't block UI
- [ ] Database queries complete within 100ms
- [ ] Memory usage stays under 150MB

---

## Security Testing Checklist

- [ ] Local database is encrypted (Isar supports encryption)
- [ ] Image paths are validated before file operations
- [ ] No sensitive data in logs
- [ ] Input validation prevents injection attacks
- [ ] Secure storage for user credentials

---

## Accessibility Testing Checklist

- [ ] All buttons have minimum 44x44 tap target
- [ ] Color contrast meets WCAG 2.1 AA standards
- [ ] Screen reader labels on all interactive elements
- [ ] Font scaling works up to 200%
- [ ] High contrast mode support

---

## QA Sign-off

| Tester | Date | Result |
|--------|------|--------|
| [Name] | [Date] | [Pass/Fail] |

**Notes:**
- All critical paths tested
- 3 documented bugs fixed
- Unit tests passing: XX/XX
- Integration tests passing: XX/XX
