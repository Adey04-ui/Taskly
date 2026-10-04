import 'package:flutter/material.dart';

class TaskScreen extends StatelessWidget {
  final int taskId;
  const TaskScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Task Screen, Task Id :$taskId'),
      ),
    );
  }
}