import 'package:flutter/material.dart';
import 'package:todo_app_clean_archit/features/todo/domain/entities/todo.dart';
import 'package:todo_app_clean_archit/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_app_clean_archit/service_locator.dart';

Future<void> showTodoDialog(
  BuildContext context, {
  Todo? todo,
}) async {
  final titleController = TextEditingController(text: todo?.title ?? '');
  final descriptionController = TextEditingController(text: todo?.description ?? '');
  
  return showDialog<void>(
    context: context,
    barrierDismissible: false, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(todo == null ? 'Add Todo' : 'Edit Todo'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final title = titleController.text;
              final description = descriptionController.text;

              if (title.isNotEmpty && description.isNotEmpty) {
                if (todo == null) {
                  // Add a new Todo
                  final newTodo = Todo(
                    id: DateTime.now().millisecondsSinceEpoch, // Generate a new ID
                    title: title,
                    description: description,
                  );
                  locator<TodoBloc>().add(TodoAdd(todo: newTodo)); // Dispatch Add Todo event
                } else {
                  // Edit existing Todo
                  final updatedTodo = todo.copyWith(
                    title: title,
                    description: description,
                  );
                  locator<TodoBloc>().add(UpdateTodoById(todo: updatedTodo)); 
                }
                Navigator.of(context).pop(); 
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
