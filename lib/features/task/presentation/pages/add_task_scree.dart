import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';
import 'package:task_manager/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager/features/task/presentation/bloc/task_event.dart';
import 'package:task_manager/features/task/presentation/bloc/task_state.dart';

class AddTaskScreen extends StatefulWidget {
  final String userId;
  final UserTask? task;

  AddTaskScreen({required this.userId, this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  String _priority = 'High';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? "Add Task" : "Edit Task"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Task Title"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Task Description"),
            ),
            ListTile(
              title: Text("Due Date: ${_dueDate.toLocal()}"),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _dueDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null && pickedDate != _dueDate) {
                  setState(() {
                    _dueDate = pickedDate;
                  });
                }
              },
            ),
            DropdownButton<String>(
              value: _priority,
              onChanged: (value) {
                setState(() {
                  _priority = value!;
                });
              },
              items: ['High', 'Medium', 'Low'].map((String priority) {
                return DropdownMenuItem<String>(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (widget.task == null) {
                  final task = UserTask(
                    id: '',
                    title: _titleController.text,
                    description: _descriptionController.text,
                    dueDate: _dueDate,
                    priority: _priority,
                  );
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
              },
              child: Text(widget.task == null ? "Add Task" : "Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}