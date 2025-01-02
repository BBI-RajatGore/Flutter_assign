import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';
import 'package:task_manager/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager/features/task/presentation/bloc/task_event.dart';
import 'package:task_manager/features/task/domain/entities/priority.dart';
import 'package:intl/intl.dart';  
class AddTaskScreen extends StatefulWidget {
  final String userId;
  final UserTask? task;

  AddTaskScreen({required this.userId, this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>(); 
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  Priority _priority = Priority.high;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _dueDate = widget.task!.dueDate;
      _priority = widget.task!.priority;
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(), 
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate.isAfter(DateTime.now())) {
      setState(() {
        _dueDate = pickedDate;
      });
    } else {
      _showDateError();
    }
  }

  
  void _showDateError() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Invalid Date"),
          content: const Text("Please select a date that is today or later."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  String getFormattedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? "Add Task" : "Edit Task", style: const TextStyle(color: Colors.white)),
        elevation: 0,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,  
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Task Title",
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

  
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Task Description",
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                ListTile(
                  title: Text(
                    "Due Date: ${getFormattedDate(_dueDate)}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: const Icon(Icons.calendar_today, color: Colors.deepPurple),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 16),


                DropdownButtonFormField<Priority>(
                  value: _priority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  ),
                  onChanged: (Priority? newPriority) {
                    setState(() {
                      _priority = newPriority!;
                    });
                  },
                  items: Priority.values.map((Priority priority) {
                    return DropdownMenuItem<Priority>(
                      value: priority,
                      child: Text(priority.toString().split('.').last.capitalize()),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

             
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final task = UserTask(
                          id: widget.task?.id ?? '',
                          title: _titleController.text,
                          description: _descriptionController.text,
                          dueDate: _dueDate,
                          priority: _priority,
                        );

                        if (widget.task == null) {
                          context.read<TaskBloc>().add(AddTaskEvent(userId: widget.userId, task: task));
                        } else {
                          final updatedTask = widget.task!.copyWith(
                            title: _titleController.text,
                            description: _descriptionController.text,
                            dueDate: _dueDate,
                            priority: _priority,
                          );
                          context.read<TaskBloc>().add(EditTaskEvent(userId: widget.userId, taskId: widget.task!.id, task: updatedTask));
                        }
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      widget.task == null ? "Add Task" : "Save Changes",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension StringCasingExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
