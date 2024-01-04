import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController _titleController = TextEditingController();
  late TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDueDate = DateTime(1947);
  String? _priorityString = 'low';

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F9FB),
        title: const Text('Add New Task'),
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
                  Text((_selectedDueDate == DateTime(1947))
                      ? '${DateTime.now().toLocal()}'.split(' ')[0]
                      : '${_selectedDueDate.toLocal()}'.split(' ')[0]
                  ),
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

                      if (pickedDate != null && pickedDate != _selectedDueDate) {
                        setState(() {
                          _selectedDueDate = pickedDate;
                        });
                      }
                    },
                    child: const Text('Select Due Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
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
                    Task newTask = Task(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      dueDate: _selectedDueDate,
                      priority: getPriorityFromPriorityString(_priorityString),
                    );

                    taskProvider.addNewTask(newTask);

                    Navigator.pop(context); // Close the AddTaskScreen
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                            'Title is required'
                          ),
                    ));
                  }
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}







