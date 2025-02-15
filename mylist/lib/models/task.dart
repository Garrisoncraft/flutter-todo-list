import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  String key;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String category;

  @HiveField(4)
  DateTime dueDate;

  @HiveField(5)
  TaskPriority priority;
  List<String> tags;
  bool isCompleted;

  Task copyWith({
    String? key,
    String? title,
    String? description,
    String? category,
    DateTime? dueDate,
    TaskPriority? priority,
    List<String>? tags,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Task(
      key: key ?? this.key,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }


  @HiveField(8)
  DateTime createdAt;

  Task({
    required this.key,
    required this.title,
    required this.description,
    required this.category,
    required this.dueDate,
    this.priority = TaskPriority.medium,
    this.tags = const [],
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

@HiveType(typeId: 1)
enum TaskPriority {
  @HiveField(0)
  low,
  
  @HiveField(1)
  medium,
  
  @HiveField(2)
  high
}
