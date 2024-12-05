// lib/screens/edit_todo_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/provider/todo_provider.dart';

class EditTodoPage extends StatefulWidget {
  final Todo todo;
  final int index;

  const EditTodoPage({super.key, required this.todo, required this.index});

  @override
  _EditTodoPageState createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.todo.title;
    _descController.text = widget.todo.description;
  }

  @override
  void dispose() {
    _titleController.clear();
    _descController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.teal, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                labelStyle: const TextStyle(color: Colors.teal),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.teal, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                labelStyle: const TextStyle(color: Colors.teal),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final String title = _titleController.text;
                final String description = _descController.text;
                if (title.isEmpty) {
                  _showSnackBar(context, 'Title is Empty');
                } else if (description.isEmpty) {
                  _showSnackBar(context, 'Description is Empty');
                } else {
                  Provider.of<TodoProvider>(context, listen: false)
                      .updateTodo(widget.index, title, description);
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Save Changes",style: TextStyle(color: Colors.teal),),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
