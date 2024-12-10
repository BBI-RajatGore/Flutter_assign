import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/provider/todo_provider.dart';
import 'package:todo_list/widgets/reusable_widgets.dart';
import 'package:todo_list/widgets/snackbar_widget.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Todo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(controller: _titleController, label: 'Title'),
            const SizedBox(height: 10),
            CustomTextField(controller: _descController, label: 'Description'),
            const SizedBox(height: 20),
            CustomElevatedButton(
              label: "Add Todo",
              onPressed: () {
                final String title = _titleController.text;
                final String description = _descController.text;

                if (title.isEmpty) {
                  ShowSnackBarWidget.showSnackBar(context, 'Title is Empty');
                } else if (description.isEmpty) {
                  ShowSnackBarWidget.showSnackBar(context, 'Description is Empty');
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
                    ShowSnackBarWidget.showSnackBar(context, 'Todo with this title already exists');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  
}
