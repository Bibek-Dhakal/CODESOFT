/// main.dart

import 'package:flutter/material.dart';
import 'package:my_quotes_app_project/screens/launcher_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_quotes_app_project/providers/quote_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => QuoteProvider(),
      child: const MyQuotesApp(),
    ),
  );
}

class MyQuotesApp extends StatelessWidget {
  const MyQuotesApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Quotes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LauncherScreen(),
    );
  }
}














