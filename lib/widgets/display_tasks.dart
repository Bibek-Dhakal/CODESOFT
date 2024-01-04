import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/utils/search_and_filter_helpers.dart';
import 'package:todo_app/screens/edit_task_screen.dart';

class TasksDisplay extends StatefulWidget {
  final List<Task> tasks;

  const TasksDisplay({
    Key? key,
    required this.tasks,
  }) : super(key: key);

  @override
  State<TasksDisplay> createState() => TasksDisplayState();
}

class TasksDisplayState extends State<TasksDisplay> {
  String? priorityString = 'all';
  String? completionStatusString = 'all';
  List<Task> filteredTasks = [];

  List<Task> getTasks() {
    if(priorityString == 'all' && completionStatusString == 'all'
        && filteredTasks.isEmpty) {
      return widget.tasks;
    }
    return filteredTasks;
  }

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context, listen: true);

    return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text('priority'),
                  SizedBox(
                    width: 150,
                    child: DropdownButton<String>(
                      value: priorityString,
                      items: ['all', 'low', 'medium', 'high']
                          .map((String option) => DropdownMenuItem<String>(
                        value: option,
                        child: Container(
                          margin: const EdgeInsets.only(left: 30),
                          child: Text(option),
                        ),
                      )).toList(),
                      onChanged: (String? value) {
                        /// handle priority filter change
                        setState(() {
                          priorityString = value;
                          filteredTasks = getFilteredTasks(
                              widget.tasks, value, completionStatusString
                          );
                        });
                      },
                      hint: const Text('Select an option'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('status'),
                  SizedBox(
                    width: 150,
                    child: DropdownButton<String>(
                      value: completionStatusString,
                      items: ['all', 'pending', 'completed']
                          .map((String option) => DropdownMenuItem<String>(
                        value: option,
                        child: Container(
                          margin: const EdgeInsets.only(left: 30),
                          child: Text(option),
                        ),
                      )).toList(),
                      onChanged: (String? value) {
                        /// handle status filter change
                        setState(() {
                          completionStatusString = value;
                          filteredTasks = getFilteredTasks(
                              widget.tasks, priorityString, value
                          );
                        });
                      },
                      hint: const Text('Select an option'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            /// size = remaining space
            child: ListView.builder(
              itemCount: getTasks().length,
              itemBuilder: (context, index) {
                return TaskRow(
                    task: getTasks()[index],
                    index: index,
                  onDeleteTask: (Task task) {
                   taskProvider.deleteTask(task.id);
                   setState(() {
                     filteredTasks = getFilteredTasksAfterTaskDeleted(filteredTasks, task.id);
                   });
                  },
                  onToggleTaskStatus: (Task task) {
                   taskProvider.toggleCompletionStatus(task.id);
                   setState(() {
                     filteredTasks = getFilteredTasksAfterTaskStatusToggled(filteredTasks, task.id);
                   });
                  },
                );
              },
            ),
          ),
        ],
      );
  }

}

class TaskRow extends StatelessWidget {
  final Task task;
  final int index;
  final Function(Task task) onDeleteTask;
  final Function(Task task) onToggleTaskStatus;

  const TaskRow({
    Key? key,
    required this.task,
    required this.index,
    required this.onDeleteTask,
    required this.onToggleTaskStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: ListTile(
        title: Text(
          task.title,
          maxLines: 1,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          task.description,
          maxLines: 2,
        ),
        trailing: SizedBox(
          width: 96,
          child: Row(
            children: [
              IconButton(
                onPressed: ()=> {
                  onDeleteTask(task)
                },
                icon: const Icon(Icons.delete),
              ),
              Checkbox(
                value: isTaskCompleted(task),
                onChanged: (value) {
                  onToggleTaskStatus(task);
                },
              ),
            ],
          ),
        ),
        onTap: () => {
          // Navigate to edit task screen when tapping on a task
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditTaskScreen(task: task, index: index),
            ),
          )
        },
      ),
    );
  }
}













