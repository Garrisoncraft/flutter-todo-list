import 'package:hive/hive.dart';
import '../models/task.dart';
import '../models/task_adapter.dart';

class TaskService {
  final String boxName = 'tasks';

  Future<void> init() async {
    // Initialize Hive without initFlutter
    Hive.init('path_to_your_hive_directory'); // Specify a valid path for Hive storage

    Hive.registerAdapter(TaskAdapter()); // Register the TaskAdapter

    await Hive.openBox<Task>(boxName);
  }

  Future<void> addTask(Task task) async {
    final box = Hive.box<Task>(boxName);
    await box.add(task);
  }

  Future<List<Task>> getTasks() async {
    final box = Hive.box<Task>(boxName);
    return box.values.toList();
  }

  Future<void> updateTask(int index, Task task) async {
    final box = Hive.box<Task>(boxName);
    await box.putAt(index, task);
  }

  Future<void> deleteTask(int index) async {
    final box = Hive.box<Task>(boxName);
    await box.deleteAt(index);
  }
}
