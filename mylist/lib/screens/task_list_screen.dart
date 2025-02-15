import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import 'add_task_screen.dart';

enum SortBy {
  dueDate,
  category,
  createdAt,
  title
}



class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final Box<Task> taskBox = Hive.box('tasks');
  String? selectedCategory;
  bool showCompleted = true;
  SortBy sortBy = SortBy.dueDate;

  void deleteTask(int index) {
    taskBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List', style: TextStyle(color: Colors.white)),
        actions: [
          PopupMenuButton<SortBy>(
            icon: Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                sortBy = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: SortBy.dueDate, child: Text('Sort by Due Date')),
              PopupMenuItem(value: SortBy.category, child: Text('Sort by Category')),
              PopupMenuItem(value: SortBy.createdAt, child: Text('Sort by Created Date')),
              PopupMenuItem(value: SortBy.title, child: Text('Sort by Title')),
            ],
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<Task>>(
        valueListenable: taskBox.listenable(),
        builder: (context, box, _) {
          List<Task> tasks = box.values.toList();

          // Apply sorting
          tasks.sort((a, b) {
            switch (sortBy) {
              case SortBy.category:

                return b.category.compareTo(a.category);
              case SortBy.createdAt:
                return b.createdAt.compareTo(a.createdAt);
              case SortBy.title:
                return a.title.toLowerCase().compareTo(b.title.toLowerCase());
              case SortBy.dueDate:
              default:
                if (a.dueDate == null || b.dueDate == null) {
                  return a.dueDate == null ? 1 : -1;
                }
                return a.dueDate.compareTo(b.dueDate);

            }
          });


          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(task.title, style: TextStyle(color: Colors.black87)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.category),
                      Text(
                        'Due: ${DateFormat('MMM d, y - h:mm a').format(task.dueDate)}',
                        style: TextStyle(
                          color: task.dueDate.isBefore(DateTime.now()) ? Colors.red : Colors.blue,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                  leading: Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                      final taskIndex = tasks.indexWhere((t) => t.key == task.key);
                      if (taskIndex != -1) {
                        final updatedTask = task.copyWith(isCompleted: value!);
                        taskBox.putAt(taskIndex, updatedTask);
                        setState(() {});
                      }




                      },
                      activeColor: Colors.orange,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTaskScreen(task: task),
                            ),
                          ).then((_) => setState(() {}));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete Task'),
                              content: Text('Are you sure you want to delete this task?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            deleteTask(index);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          ).then((_) => setState(() {}));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
}}
