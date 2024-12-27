// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:task_manager/features/task/domain/entities/usertask.dart';
// import 'package:task_manager/features/task/presentation/bloc/task_bloc.dart';
// import 'package:task_manager/features/task/presentation/bloc/task_event.dart';
// import 'package:task_manager/features/task/presentation/bloc/task_state.dart';

// class AddTaskScreen extends StatefulWidget {
//   final String userId;
//   final UserTask? task;

//   AddTaskScreen({required this.userId, this.task});

//   @override
//   _AddTaskScreenState createState() => _AddTaskScreenState();
// }

// class _AddTaskScreenState extends State<AddTaskScreen> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   DateTime _dueDate = DateTime.now();
//   String _priority = 'High';

//   @override
//   void initState() {
//     super.initState();
//     if (widget.task != null) {
//       _titleController.text = widget.task!.title;
//       _descriptionController.text = widget.task!.description;
//       _dueDate = widget.task!.dueDate;
//       _priority = widget.task!.priority;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.task == null ? "Add Task" : "Edit Task"),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(labelText: "Task Title"),
//             ),
//             TextField(
//               controller: _descriptionController,
//               decoration: InputDecoration(labelText: "Task Description"),
//             ),
//             ListTile(
//               title: Text("Due Date: ${_dueDate.toLocal()}"),
//               onTap: () async {
//                 final pickedDate = await showDatePicker(
//                   context: context,
//                   initialDate: _dueDate,
//                   firstDate: DateTime(2000),
//                   lastDate: DateTime(2100),
//                 );
//                 if (pickedDate != null && pickedDate != _dueDate) {
//                   setState(() {
//                     _dueDate = pickedDate;
//                   });
//                 }
//               },
//             ),
//             DropdownButton<String>(
//               value: _priority,
//               onChanged: (value) {
//                 setState(() {
//                   _priority = value!;
//                 });
//               },
//               items: ['High', 'Medium', 'Low'].map((String priority) {
//                 return DropdownMenuItem<String>(
//                   value: priority,
//                   child: Text(priority),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 if (widget.task == null) {
//                   final task = UserTask(
//                     id: '',
//                     title: _titleController.text,
//                     description: _descriptionController.text,
//                     dueDate: _dueDate,
//                     priority: _priority,
//                   );
//                   context.read<TaskBloc>().add(AddTaskEvent(userId: widget.userId, task: task));
//                 } else {
//                   final updatedTask = widget.task!.copyWith(
//                     title: _titleController.text,
//                     description: _descriptionController.text,
//                     dueDate: _dueDate,
//                     priority: _priority,
//                   );
//                   context.read<TaskBloc>().add(EditTaskEvent(userId: widget.userId, taskId: widget.task!.id, task: updatedTask));
//                 }
//                 Navigator.pop(context);
//               },
//               child: Text(widget.task == null ? "Add Task" : "Save Changes"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:task_manager/features/task/domain/entities/usertask.dart';
// import 'package:task_manager/features/task/presentation/bloc/task_bloc.dart';
// import 'package:task_manager/features/task/presentation/bloc/task_event.dart';

// class AddTaskScreen extends StatefulWidget {
//   final String userId;
//   final UserTask? task;

//   AddTaskScreen({required this.userId, this.task});

//   @override
//   _AddTaskScreenState createState() => _AddTaskScreenState();
// }

// class _AddTaskScreenState extends State<AddTaskScreen> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   DateTime _dueDate = DateTime.now();
//   String _priority = 'High';

//   @override
//   void initState() {
//     super.initState();
//     if (widget.task != null) {
//       _titleController.text = widget.task!.title;
//       _descriptionController.text = widget.task!.description;
//       _dueDate = widget.task!.dueDate;
//       _priority = widget.task!.priority;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.task == null ? "Add Task" : "Edit Task"),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(labelText: "Task Title"),
//             ),
//             TextField(
//               controller: _descriptionController,
//               decoration: InputDecoration(labelText: "Task Description"),
//             ),
//             ListTile(
//               title: Text("Due Date: ${_dueDate.toLocal()}"),
//               onTap: () async {
//                 final pickedDate = await showDatePicker(
//                   context: context,
//                   initialDate: _dueDate,
//                   firstDate: DateTime(2000),
//                   lastDate: DateTime(2100),
//                 );
//                 if (pickedDate != null && pickedDate != _dueDate) {
//                   setState(() {
//                     _dueDate = pickedDate;
//                   });
//                 }
//               },
//             ),
//             DropdownButton<String>(
//               value: _priority,
//               onChanged: (value) {
//                 setState(() {
//                   _priority = value!;
//                 });
//               },
//               items: ['High', 'Medium', 'Low'].map((String priority) {
//                 return DropdownMenuItem<String>(
//                   value: priority,
//                   child: Text(priority),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 if (widget.task == null) {
//                   final task = UserTask(
//                     id: '',
//                     title: _titleController.text,
//                     description: _descriptionController.text,
//                     dueDate: _dueDate,
//                     priority: _priority,
//                   );
//                   context.read<TaskBloc>().add(AddTaskEvent(userId: widget.userId, task: task));
//                 } else {
//                   final updatedTask = widget.task!.copyWith(
//                     title: _titleController.text,
//                     description: _descriptionController.text,
//                     dueDate: _dueDate,
//                     priority: _priority,
//                   );
//                   context.read<TaskBloc>().add(EditTaskEvent(userId: widget.userId, taskId: widget.task!.id, task: updatedTask));
//                 }
//                 Navigator.pop(context);
//               },
//               child: Text(widget.task == null ? "Add Task" : "Save Changes"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';
import 'package:task_manager/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager/features/task/presentation/bloc/task_event.dart';

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
        title: Text(widget.task == null ? "Add Task" : "Edit Task",style: const TextStyle(color: Colors.white),),
        elevation: 0,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Input
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Task Title",
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),
              const SizedBox(height: 16),

              // Description Input
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Task Description",
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),

              // Due Date Picker
              ListTile(
                title: Text(
                  "Due Date: ${_dueDate.toLocal().toString().split(' ')[0]}",
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(Icons.calendar_today, color: Colors.deepPurple),
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
              const SizedBox(height: 16),

              // Priority Dropdown
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: InputDecoration(
                  labelText: 'Priority',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
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
              const SizedBox(height: 24),

              // Save Button
              Center(
                child: ElevatedButton(
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
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // primary: Colors.blueAccent,
                  ),
                  child: Text(
                    widget.task == null ? "Add Task" : "Save Changes",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
