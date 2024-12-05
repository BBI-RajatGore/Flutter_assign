
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/provider/todo_provider.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

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
        title: const Text('Add Todo'),
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
              decoration:  InputDecoration(
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
                  final todo = Todo(
                    title: title,
                    description: description,
                  );
                  final added = Provider.of<TodoProvider>(context, listen: false)
                      .addTodo(todo);
                  if (added) {
                    Navigator.of(context).pop(todo);
                  } else {
                    _showSnackBar(context, 'Todo with this title already exists');
                  }
                }
              },
              child: const Text("Add Todo",style: TextStyle(color: Colors.teal),),
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
