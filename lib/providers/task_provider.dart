import 'package:flutter/material.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/utils/storage.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];

  // Getter to access the tasks
  List<Task> get tasks => _tasks;

  // Method to initialize tasks from storage
  Future<void> initializeTasks() async {
    try {
      _tasks = await TaskStorage.getTasks();
      /// notify listeners
      notifyListeners();
    } catch (e) {
      debugPrint("Error initializing tasks: $e");
    }
  }

  // Method to get the number of active tasks (completion status active tasks)
  int getActiveTasksCount() {
    return _tasks.where((task) => task.completionStatus == CompletionStatus.pending).length;
  }

  // Method to add a new task.
  Future<void> addNewTask(Task newTask) async {
    // _tasks.add(newOrUpdatedTask);
    _tasks.insert(0, newTask); // add at first
    await TaskStorage.saveTasks(_tasks);
    /// notify listeners
    notifyListeners();
  }

  // Method to update an existing task.
  Future<void> updateTask(String oldTaskId, Task updatedTask) async {
    _tasks.removeWhere((task) => task.id == oldTaskId);
    addNewTask(updatedTask);
  }

  // Method to toggle completion status of a task.
  Future<void> toggleCompletionStatus(String taskId) async {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if(index != -1) {
      _tasks[index].completionStatus =
      _tasks[index].completionStatus == CompletionStatus.pending
          ? CompletionStatus.completed
          : CompletionStatus.pending;
      await TaskStorage.saveTasks(_tasks);
      /// notify listeners
      notifyListeners();
    }
  }

  // Method to delete a task
  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    await TaskStorage.saveTasks(_tasks);
    /// notify listeners
    notifyListeners();
  }

  // Method to delete all tasks
  Future<void> deleteAllTasks() async {
    _tasks.clear();
    await TaskStorage.deleteAllTasks();
    /// notify listeners
    notifyListeners();
  }

}























