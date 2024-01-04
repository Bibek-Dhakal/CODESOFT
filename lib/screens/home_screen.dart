import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/screens/add_task_screen.dart';
import 'package:todo_app/utils/storage.dart';
import 'package:todo_app/utils/search_and_filter_helpers.dart';
import 'package:todo_app/widgets/display_tasks.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

  class HomeScreenState extends State<HomeScreen> {
    late TextEditingController usernameController = TextEditingController();
    bool canEditUsername = false;

    String searchedKey = "";
    List<Task> taskSearchResults = [];

    String? priorityString = 'all';
    String? completionStatusString = 'all';
    List<Task> filteredTasks = [];

     void handleUserRenameIconButtonClick() {
       if(canEditUsername){
         if(usernameController.text.isEmpty){
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
             content: Text(
                 'please enter a username'
             ),
           ));
           return;
         }
         UserStorage.saveUsernameInStorage(usernameController.text);
       }
       setState(() {
         canEditUsername = !canEditUsername;
       });
    }

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context, listen: true);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // extendBody: true,
      backgroundColor: const Color(0xFFF6F9FB),
      body: WillPopScope(
        onWillPop: () async {
          bool shouldPop = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color(0xFFEFF4FF),
                title: const Text('Confirmation'),
                content: const Text('Do you want to exit?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => {
                      /// EXIT APP.
                      SystemChannels.platform.invokeMethod('SystemNavigator.pop')
                    },
                    child: const Text('Yes'),
                  ),
                ],
              );
            },
          );
          return shouldPop ?? false; // Default to false if there's an issue.
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 10, left: 16, right: 16),
            child: Column(
              children: [
                SizedBox(
                  width: screenWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Hello ',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          canEditUsername
                              ? Row(
                               children: [
                                SizedBox(
                                width: 180,
                                child: TextField(
                                  controller: usernameController,
                                ),
                               ),
                               IconButton(
                                onPressed: () => {
                                  setState(() {
                                    canEditUsername = false;
                                  })
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ) :  FutureBuilder<String>(
                            future: UserStorage.getUsernameFromStorage(),
                            builder: (context, snapshot) {
                              final username = snapshot.data ?? 'User';
                              return Text(
                                username,
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                          IconButton(
                            onPressed: () => {
                              handleUserRenameIconButtonClick()
                            },
                            icon: Icon(canEditUsername ? Icons.save : Icons.drive_file_rename_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    (taskProvider.getActiveTasksCount() == 1) ? 'A task is pending'
                        : (taskProvider.getActiveTasksCount() == 0)
                        ? 'No tasks are pending'
                        : '${taskProvider.getActiveTasksCount()} tasks are pending',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 300,
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: screenWidth,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: TextField(
                      onChanged: (String value) => {
                        /// SEARCH for the task.
                        setState(() {
                          searchedKey = value;
                          taskSearchResults = getTasksByTitle(
                              taskProvider.tasks, value
                          );
                        })
                      },
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        icon: Icon(
                          Icons.search_rounded,
                          color: Colors.grey,
                          size: 25,
                        ),
                        hintText: 'search task by title',
                        hintStyle: TextStyle(
                          color: Color(0xFFB6BDD2),
                        ),
                      ),
                    ),
                  ),
                ),
                (searchedKey.isNotEmpty
                    && taskSearchResults.isEmpty)
                    ?  const Column(
                     children: [
                      SizedBox(height: 10,),
                      Text(
                      'No task found',
                      style: TextStyle(
                        color: Color(0xFF9BA6C3),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ) : const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      (searchedKey.isNotEmpty
                          && taskSearchResults.isNotEmpty)
                          ? 'Search results' : 'Tasks',
                      style: const TextStyle(
                        color: Color(0xFF9BA6C3),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: screenWidth,
                  height: screenHeight - 330,
                  decoration: const BoxDecoration(
                    // color: Colors.black12,
                  ),
                  child: (taskSearchResults.isEmpty)
                      ? TasksDisplay(tasks: taskProvider.tasks)
                  : TasksDisplay(tasks: taskSearchResults),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF6F9FB),
        onPressed: () {
          // Navigate to add task screen when pressing the FAB
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
































