/// utils/search_and_filter_helpers.dart

import 'package:todo_app/models/task_model.dart';

List<Task> getTasksByTitle(List<Task> tasks, String title) {
  return tasks.where((task) =>
      task.title.toLowerCase().contains(title.toLowerCase())).toList();
}

List<Task> getFilteredTasks(
    List<Task> tasks, String? priorityString, String? completionStatusString
    ) {
  if(priorityString == 'all' && completionStatusString == 'all') {
    return tasks;
  }
  if(priorityString != 'all' && completionStatusString != 'all') {
    Priority priority = getPriorityFromPriorityString(priorityString);
    CompletionStatus completionStatus = getStatusFromStatusString(completionStatusString);
    return tasks.where((task) {
      return (task.priority == priority) && (task.completionStatus == completionStatus);
    }).toList();
  }
  if(priorityString != 'all') {
    Priority priority = getPriorityFromPriorityString(priorityString);
    return tasks.where((task) {
      return (task.priority == priority);
    }).toList();
  }
  CompletionStatus completionStatus = getStatusFromStatusString(completionStatusString);
  return tasks.where((task) {
    return (task.completionStatus == completionStatus);
  }).toList();
}

List<Task> getFilteredTasksAfterTaskDeleted(
    List<Task> filteredTasks, String deletedTaskId,
    ) {
  List<Task> updatedFilteredTasks = List.from(filteredTasks); // Create a new list
  updatedFilteredTasks.removeWhere((task) => task.id == deletedTaskId);
  return updatedFilteredTasks;
}

List<Task> getFilteredTasksAfterTaskStatusToggled(
    List<Task> filteredTasks, String statusToggledTaskId
) {
  List<Task> updatedFilteredTasks = List.from(filteredTasks); // Create a new list
  final index = updatedFilteredTasks.indexWhere((task) => task.id == statusToggledTaskId);
  if (index != -1) {
    updatedFilteredTasks[index].completionStatus =
    (updatedFilteredTasks[index].completionStatus == CompletionStatus.pending)
     ? CompletionStatus.completed
     : CompletionStatus.pending;
    return updatedFilteredTasks;
  }
  return filteredTasks;
}



























