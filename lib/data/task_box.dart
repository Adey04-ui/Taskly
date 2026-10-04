// lib/data/task_box.dart
import 'package:hive_ce/hive_ce.dart';
import 'package:taskly/models/task.dart';

Box<Task> get taskBox => Hive.box<Task>('tasks');