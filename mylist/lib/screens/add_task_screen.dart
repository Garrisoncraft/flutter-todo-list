 import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;

  const AddTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  DateTime? _dueDate;
  TimeOfDay? _dueTime;

  final List<String> _categories = [
    'Work',
    'Personal',
    'Study',
    'Shopping',
    'Health'
  ]..sort();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedCategory = widget.task!.category;
      _dueDate = widget.task!.dueDate;
      _dueTime = TimeOfDay.fromDateTime(widget.task!.dueDate);
    }
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null ? 'Add Task' : 'Edit Task',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Task Details', 
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800]
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title *',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 2),
                  ),
                  contentPadding: EdgeInsets.all(12),
                  prefixIcon: Icon(Icons.title, color: Colors.blue[800]),
                ),
                style: TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description *',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 2),
                  ),
                  contentPadding: EdgeInsets.all(12),
                  prefixIcon: Icon(Icons.description, color: Colors.blue[800]),
                ),
                style: TextStyle(fontSize: 16),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category *',
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 2),
                  ),
                  contentPadding: EdgeInsets.all(12),
                  prefixIcon: Icon(Icons.category, color: Colors.blue[800]),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(
                        _dueDate == null
                            ? 'Select Date *'
                            : 'Date: ${DateFormat('MMM d, y').format(_dueDate!.toLocal())}',
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: Icon(Icons.calendar_today, color: Colors.blue[800]),
                      tileColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _dueDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _dueDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        _dueTime == null
                            ? 'Select Time'
                            : 'Time: ${_dueTime!.format(context)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: Icon(Icons.access_time, color: Colors.blue[800]),
                      tileColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onTap: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: _dueTime ?? TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _dueTime = pickedTime;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Icon(Icons.save, size: 20),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_dueDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a due date')),
                      );
                      return;
                    }
                    
                    final combinedDateTime = _combineDateAndTime(
                      _dueDate!,
                      _dueTime ?? TimeOfDay.now(),
                    );

                    final taskBox = Hive.box<Task>('tasks');
                    
                    if (widget.task != null) {
                      final updatedTask = Task(
                        key: widget.task!.key,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        category: _selectedCategory!,
                        dueDate: combinedDateTime,
                      );
                      taskBox.put(updatedTask.key, updatedTask);
                    } else {
                      final task = Task(
                        key: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: _titleController.text,
                        description: _descriptionController.text,
                        category: _selectedCategory!,
                        dueDate: combinedDateTime,
                        createdAt: DateTime.now(),
                      );
                      taskBox.add(task);
                    }
                    Navigator.pop(context);
                  }
                },
                label: Text('Save Task', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
