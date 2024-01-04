/// models/task_model.dart

import 'package:uuid/uuid.dart';

class Task {
  String id;
  String title;
  String description;
  DateTime dueDate;
  Priority priority;
  CompletionStatus completionStatus;

  Task({
    String? id, // id can be null (no need to provide it)
    required this.title,
    this.description = '',
    DateTime? dueDate,
    this.priority = Priority.low,
    this.completionStatus = CompletionStatus.pending,
  }) : id = id ?? const Uuid().v4(), // id ll be generated if null
       dueDate = dueDate ?? DateTime(1947); // 1947 means not set

  // task to map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority.index,
      'completionStatus': completionStatus.index,
    };
  }

  // task from map. (map to task)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      priority: Priority.values[map['priority']],
      completionStatus: CompletionStatus.values[map['completionStatus']],
    );

  }
}

enum Priority { low, medium, high }
enum CompletionStatus { pending, completed }

// Method to get priority string from priority..
String getPriorityStringFromPriority(Priority priority){
  if (priority == Priority.medium) {
    return 'medium';
  } else if (priority == Priority.high) {
    return 'high';
  }
  return 'low';
}

// Method to get priority from priority string.
Priority getPriorityFromPriorityString(String? priorityString){
  if (priorityString == 'medium') {
    return Priority.medium;
  } else if (priorityString == 'high') {
    return Priority.high;
  }
  return Priority.low;
}

// Method to get status string from status..
String getStatusStringFromStatus(CompletionStatus status) {
  if (status == CompletionStatus.pending) {
    return 'pending';
  }
  return 'completed';
}

// Method to get status from status string.
CompletionStatus getStatusFromStatusString(String? statusString){
  if(statusString == 'pending') {
    return CompletionStatus.pending;
  }
  return CompletionStatus.completed;
}

// Method to check if a due date is set or not.
bool isDueDateSet(DateTime dueDate){
  if (dueDate == DateTime(1947)) {
    return false;
  }
  return true;
}

// Method to check if a task is completed or not.
bool isTaskCompleted(Task task){
  if(task.completionStatus == CompletionStatus.completed){
    return true;
  }
  return false;
}























