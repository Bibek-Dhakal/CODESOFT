/// utils/storage.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/task_model.dart';

// USER STORAGE ================================================================
class UserStorage {
  static const _userKey = 'username';

// Method to save username in storage.
  static Future<void> saveUsernameInStorage(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedUsername = json.encode(username);
    prefs.setString(_userKey, encodedUsername);
  }

// Method to get username from storage.
  static Future<String> getUsernameFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedUsername = prefs.getString(_userKey);
    if (encodedUsername != null) {
      final String username = json.decode(encodedUsername);
      return username;
    }
    // return 'User' if username not found.
    return 'User';
  }

}

/* TASK STORAGE ================================================================ */
class TaskStorage {
  static const _tasksKey = 'tasks';

  // Method to save a list of tasks.
  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    // convert tasks to list of maps.
    final taskMapsList = tasks.map((task) => task.toMap()).toList();
    final encodedTasks = json.encode(taskMapsList);
    // update the tasks list in storage, if not exists creates it.
    prefs.setString(_tasksKey, encodedTasks);
  }

  // Method to retrieve a list of tasks from SharedPreferences
  static Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedTasks = prefs.getString(_tasksKey);
    if (encodedTasks != null) {
      final List<dynamic> taskList = json.decode(encodedTasks);
      // convert task maps list to tasks
      final tasks = taskList.map((taskMap) => Task.fromMap(taskMap)).toList();
      return tasks;
    }
    // tasks not found in storage.
    return [];
  }

  // Method to delete all tasks
  static Future<void> deleteAllTasks() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_tasksKey);
  }

}



























