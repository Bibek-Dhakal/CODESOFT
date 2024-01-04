/// screens/launcher_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/task_provider.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({super.key});
  @override
  State<LauncherScreen> createState() => LauncherScreenState();
}

class LauncherScreenState extends State<LauncherScreen> {
  @override
  void initState() {
    super.initState();

    // Add a delay of 1 second (1000 milliseconds) using Future.delayed
    Future.delayed(const Duration(seconds: 1), () {
      /// Navigate to the second page after the delay
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });

  }

  @override
  Widget build(BuildContext context){
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 50, right: 50, top: screenHeight * 0.4
              ),
              child: Column(
                children: [
                  const Text(
                    'My Todo App',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Color(0xFF265CDF),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const CupertinoActivityIndicator(
                        color: Colors.black,
                        radius: 30,
                      )
                  ),
                ],
              ),
            ),
        ),
      ),

    );
  }
}











