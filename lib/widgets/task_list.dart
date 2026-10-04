import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/screens/task_screen.dart';
import 'package:taskly/utils/page_transitions.dart';
import 'package:taskly/utils/string_extensions.dart';
import 'package:taskly/widgets/checkbox.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key, required this.activeTabId, required this.tasks, this.onSelect});

  final int activeTabId;
  final List<Task> tasks;

  final ValueChanged<Task>? onSelect;

  static const Color _activeColor = Color(0xFF3134DE);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  int? _selectedId;

  @override
  Widget build(BuildContext context) {
    final filteredTasks = widget.activeTabId == 1
      ? widget.tasks
      : widget.tasks.where((task) {
          // adjust these numbers to match your actual tab id/category mapping
          final category = widget.activeTabId == 2 ? 'personal' : 'work';
          return task.category == category;
        }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Day ',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight(500)
            ),
          ),
        ),
        ...filteredTasks.map((task) {
            final isSelected = task.key == _selectedId;
            final priority = task.priority;
            final textColor = priority == 'high' ? Colors.red[100] : priority == 'medium' ? Colors.yellow[100] : Colors.green[100];
            final color = priority == 'high' ? Colors.red[900] : priority == 'medium' ? Colors.yellow[900] : Colors.green[900];
        
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(vertical: 0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: !isSelected ? BorderSide(
                    color: const Color.fromARGB(29, 255, 255, 255),
                    width: 1
                  ) : BorderSide.none
                ),
                color: isSelected
                  ? const Color.fromARGB(255, 54, 55, 83).withOpacity(0.18)
                  : Colors.transparent,
                borderRadius: isSelected ? BorderRadius.circular(12) : null,
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.only(right: 15, left: 12, bottom: 13, top: 13),
                visualDensity: VisualDensity.compact,
                leading: PremiumCheckbox(
                  value: task.isDone, 
                  onChanged: (value) {
                    setState(() {
                      _selectedId = value == true ? task.key as int : null;
                    });
                    task.isDone = value;
                    task.save();
                  }
                ),
                title: Text(task.title,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                subtitle: task.dueDate != ''
                  ? Text(task.dueDate)
                  : const SizedBox.shrink(),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(priority.capitalize(),
                    style: TextStyle(
                      color: textColor,
                      fontSize: 12,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context, slideRoute(TaskScreen(taskId: task.key), transitionDuration: const Duration(milliseconds: 400)));
                },
              ),
            );
          },
        )
      ],
    );
  }
}