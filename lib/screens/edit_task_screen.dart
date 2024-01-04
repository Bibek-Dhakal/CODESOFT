import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/models/task_model.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final int index;

  const EditTaskScreen({super.key, required this.task, required this.index});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController = TextEditingController();
  late TextEditingController _descriptionController = TextEditingController();
  String? _priorityString = 'low';
  DateTime _dueDate = DateTime(1947);

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _dueDate = widget.task.dueDate;
    _priorityString = getPriorityStringFromPriority(widget.task.priority);
  }

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F9FB),
        title: const Text('Edit Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F9FB),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.5, 0.5),
                      spreadRadius: 0.1,
                      blurRadius: 0.2,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    const Text('Description'),
                    SingleChildScrollView(
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 6, // maximum lines
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Text('Due Date: '),
                  isDueDateSet(_dueDate) ? Text('${_dueDate.toLocal()}'.split(' ')[0])
                  : const Text('not set'),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () async {
                      // Open a date picker and set the selected due date
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 10),
                      );

                      if (pickedDate != null && pickedDate != _dueDate) {
                        setState(() {
                          _dueDate = pickedDate;
                        });
                      }
                    },
                    child: const Text('Select Due Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16,),
              const Text('Priority:'),
              DropdownButton<String>(
                value: _priorityString,
                items: ['low', 'medium', 'high']
                    .map((String option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    _priorityString = value;
                  });
                },
                hint: const Text('Select an option'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Check (required) before adding the task
                  if (_titleController.text.isNotEmpty) {
                    Task updatedTask = Task(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      dueDate: _dueDate,
                      priority: getPriorityFromPriorityString(_priorityString),
                    );

                    debugPrint(updatedTask.id);

                    taskProvider.updateTask(widget.task.id, updatedTask);

                    Navigator.pop(context); // Close the AddTaskScreen
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'Title is required'
                      ),
                    ));
                  }
                },
                child: const Text('Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

















