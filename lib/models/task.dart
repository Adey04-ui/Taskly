import 'package:hive_ce/hive_ce.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isDone;

  @HiveField(2)
  String category;

  @HiveField(3)
  DateTime createdAt; // kept at its original number — unchanged

  @HiveField(4)
  String description; // new fields get the NEXT unused numbers

  @HiveField(5)
  String priority;

  @HiveField(6)
  String dueDate;

  Task({
    required this.title,
    this.isDone = false,
    required this.category,
    DateTime? createdAt,
    this.description = '',
    this.priority = 'medium',
    this.dueDate = '',
  }) : createdAt = createdAt ?? DateTime.now();
}