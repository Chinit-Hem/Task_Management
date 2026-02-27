import 'dart:convert';
import 'package:http/http.dart' as http;
import '../features/task_management/domain/models/task_model.dart';
import '../models/user_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Base URL for API - replace with your actual API endpoint
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Flag to use mock data instead of real API
  bool useMockData = true;

  // Mock data for testing
  final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': '1',
      'name': 'Chinit Hem',
      'email': 'chinithem81@gmail.com',
      'avatarUrl': 'https://i.pravatar.cc/150?img=1',
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '2',
      'name': 'Chinit Hem',
      'email': 'chinithem81@gmail.com',
      'avatarUrl': 'https://i.pravatar.cc/150?img=2',
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '3',
      'name': 'Chinit Hem',
      'email': 'chinithem81@gmail.com',
      'avatarUrl': 'https://i.pravatar.cc/150?img=3',
      'createdAt': DateTime.now().toIso8601String(),
    },
  ];

  // Mock tasks data
  final List<Map<String, dynamic>> _mockTasks = [
    {
      'id': '1',
      'title': 'Design system documentation',
      'category': 'Design',
      'priority': 'HIGH',
      'due': 'Today',
      'time': '10:00 AM',
      'image':
          'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=100&h=100&fit=crop',
      'completed': false,
    },
    {
      'id': '2',
      'title': 'Review pull requests',
      'category': 'Development',
      'priority': 'MEDIUM',
      'due': 'Today',
      'time': '2:00 PM',
      'image':
          'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=100&h=100&fit=crop',
      'completed': false,
    },
    {
      'id': '3',
      'title': 'Team standup meeting',
      'category': 'Meeting',
      'priority': 'LOW',
      'due': 'Today',
      'time': '9:00 AM',
      'image':
          'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=100&h=100&fit=crop',
      'completed': true,
    },
    {
      'id': '4',
      'title': 'Update user interface mockups',
      'category': 'Design',
      'priority': 'MEDIUM',
      'due': 'Tomorrow',
      'time': '11:00 AM',
      'image':
          'https://images.unsplash.com/photo-1586717791821-3f44a563fa4c?w=100&h=100&fit=crop',
      'completed': false,
    },
    {
      'id': '5',
      'title': 'Fix navigation bug',
      'category': 'Development',
      'priority': 'HIGH',
      'due': 'Tomorrow',
      'time': '3:00 PM',
      'image':
          'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=100&h=100&fit=crop',
      'completed': false,
    },
  ];

  // Get all users
  Future<List<UserModel>> getUsers() async {
    if (useMockData) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      return _mockUsers.map((json) => UserModel.fromJson(json)).toList();
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/users'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  // Get user by ID
  Future<UserModel> getUserById(String id) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      final user = _mockUsers.firstWhere(
        (u) => u['id'] == id,
        orElse: () => throw Exception('User not found'),
      );
      return UserModel.fromJson(user);
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/users/$id'));

      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  // Create new user
  Future<UserModel> createUser(UserModel user) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      final newUser = user.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
      );
      _mockUsers.add(newUser.toJson());
      return newUser;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  // Update user
  Future<UserModel> updateUser(UserModel user) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      final index = _mockUsers.indexWhere((u) => u['id'] == user.id);
      if (index != -1) {
        _mockUsers[index] = user.toJson();
        return user;
      } else {
        throw Exception('User not found');
      }
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/${user.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  // Delete user
  Future<void> deleteUser(String id) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      _mockUsers.removeWhere((u) => u['id'] == id);
      return;
    }

    try {
      final response = await http.delete(Uri.parse('$baseUrl/users/$id'));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  // Convert JSON to TaskModel
  TaskModel _jsonToTaskModel(Map<String, dynamic> json) {
    return TaskModel.create(
      title: json['title'] ?? '',
      description: json['description'],
      priority: _parsePriority(json['priority']),
      category: json['category'] ?? 'Personal',
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      imagePath: json['imagePath'],
      subtasks:
          json['subtasks'] != null ? List<String>.from(json['subtasks']) : [],
    )..isCompleted = json['isCompleted'] ?? false;
  }

  // Convert TaskModel to JSON
  Map<String, dynamic> _taskModelToJson(TaskModel task) {
    return {
      'id': task.id.toString(),
      'title': task.title,
      'description': task.description,
      'priority': task.priority.name,
      'category': task.category,
      'dueDate': task.dueDate?.toIso8601String(),
      'isCompleted': task.isCompleted,
      'subtasks': task.subtasks,
      'imagePath': task.imagePath,
      'createdAt': task.createdAt.toIso8601String(),
      'updatedAt': task.updatedAt.toIso8601String(),
    };
  }

  // Parse priority from string
  Priority _parsePriority(String? value) {
    switch (value?.toUpperCase()) {
      case 'HIGH':
        return Priority.high;
      case 'LOW':
        return Priority.low;
      case 'MEDIUM':
      default:
        return Priority.medium;
    }
  }

  // Get all tasks
  Future<List<TaskModel>> getTasks() async {
    if (useMockData) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      return _mockTasks.map((json) => _jsonToTaskModel(json)).toList();
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/tasks'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => _jsonToTaskModel(json)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  // Get task by ID
  Future<TaskModel> getTaskById(String id) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      final task = _mockTasks.firstWhere(
        (t) => t['id'] == id,
        orElse: () => throw Exception('Task not found'),
      );
      return _jsonToTaskModel(task);
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/tasks/$id'));

      if (response.statusCode == 200) {
        return _jsonToTaskModel(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching task: $e');
    }
  }

  // Create new task
  Future<TaskModel> createTask(TaskModel task) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      final newTask = TaskModel.create(
        title: task.title,
        description: task.description,
        priority: task.priority,
        category: task.category,
        dueDate: task.dueDate,
        imagePath: task.imagePath,
        subtasks: task.subtasks,
      )..isCompleted = task.isCompleted;
      _mockTasks.add(_taskModelToJson(newTask));
      return newTask;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tasks'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_taskModelToJson(task)),
      );

      if (response.statusCode == 201) {
        return _jsonToTaskModel(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating task: $e');
    }
  }

  // Update task
  Future<TaskModel> updateTask(TaskModel task) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      final index = _mockTasks.indexWhere((t) => t['id'] == task.id.toString());
      if (index != -1) {
        _mockTasks[index] = _taskModelToJson(task);
        return task;
      } else {
        throw Exception('Task not found');
      }
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/tasks/${task.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_taskModelToJson(task)),
      );

      if (response.statusCode == 200) {
        return _jsonToTaskModel(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  // Delete task
  Future<void> deleteTask(String id) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      _mockTasks.removeWhere((t) => t['id'] == id);
      return;
    }

    try {
      final response = await http.delete(Uri.parse('$baseUrl/tasks/$id'));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting task: $e');
    }
  }

  // Generic GET request
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  // Generic POST request
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  // Generic PUT request
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }

  // Generic DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('DELETE request failed: $e');
    }
  }

  // Handle HTTP response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return jsonDecode(response.body);
      }
      return null;
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }
}
