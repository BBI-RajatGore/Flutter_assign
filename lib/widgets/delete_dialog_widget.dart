import 'package:flutter/material.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/provider/todo_provider.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/widgets/snackbar_widget.dart';

class DeleteDialogWidget {
  static Future<void> showDeleteDialog(
      BuildContext context, int index, Todo todo) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Todo"),
          content: Text("Are you sure you want to delete ${todo.title}?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {

                Provider.of<TodoProvider>(context, listen: false)
                    .deleteTodo(index);

                Navigator.of(context).pop();
                
                ShowSnackBarWidget.showSnackBar(context, '${todo.title} Deleted');
                
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
