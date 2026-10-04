import 'package:flutter/material.dart';
import 'package:taskly/data/task_box.dart';
import 'package:taskly/screens/splash_screen.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:taskly/models/task.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');

  // await taskBox.clear();

  if (taskBox.isEmpty) {
    await taskBox.addAll([
      Task(title: 'Read a magazine', category: 'personal', description: 'Remember to read the willy magazine', priority: 'low', dueDate: ''),
      Task(title: 'Book appointment', category: 'personal', description: 'Remember to book an appointment with the doctor', priority: 'medium', dueDate: ''),
      Task(title: 'Take a walk', category: 'personal', description: 'want to take a walk with the dog', priority: 'high', dueDate: ''),
    ]);
  }
  // taskBox.addAll([
  //     Task(title: 'Read a magazine', category: 'work', description: 'Remember to read the willy magazine', priority: 'low', dueDate: ''),
  //     Task(title: 'Book appointment', category: 'work', description: 'Remember to book an appointment with the doctor', priority: 'medium', dueDate: ''),
  //     Task(title: 'Take a walk', category: 'work', description: 'want to take a walk with the dog', priority: 'high', dueDate: ''),
  //   ]);


  runApp(const TasklyApp());
}

class TasklyApp extends StatelessWidget {
  const TasklyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(overscroll: false),
      title: 'Taskly',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, // follow the OS setting automatically
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color.fromARGB(255, 6, 8, 17),
      ),
      home: const SplashScreen(),
    );
  }
}