// User Provider - This is a sample state management provider for the Flutter project
// Team can modify this according to their feature topic

import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';


class UserProvider extends ChangeNotifier {
  List<UserModel> _users = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get user by ID
  UserModel? getUserById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  // Fetch users from API
  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService().get('/users');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _users = data.map((json) => UserModel.fromJson(json)).toList();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // Add a new user
  Future<bool> addUser(UserModel user) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService().post('/users', user.toJson());
      if (response.statusCode == 201 || response.statusCode == 200) {
        _users.add(user);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }


  // Update an existing user
  Future<bool> updateUser(UserModel user) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService().put('/users/${user.id}', user.toJson());
      if (response.statusCode == 200) {
        final index = _users.indexWhere((u) => u.id == user.id);
        if (index != -1) {
          _users[index] = user;
        }
        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }


  // Delete a user
  Future<bool> deleteUser(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService().delete('/users/$id');
      if (response.statusCode == 200 || response.statusCode == 204) {
        _users.removeWhere((user) => user.id == id);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }


  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
