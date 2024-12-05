// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/pages/add_todo_page.dart';
import 'package:todo_list/pages/edit_todo_page.dart';
import 'package:todo_list/provider/todo_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Color> _colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.teal,
    Colors.yellow,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
      ),
      body: Consumer<TodoProvider>(builder: (context, todoProvider, _) {
        if (todoProvider.todo.isEmpty) {
          return const Center(
            child: Text(
              "No Todo Added Yet",
              style: TextStyle(fontSize: 20),
            ),
          );
        }

        return SlidableAutoCloseBehavior(
          child: ListView.builder(
            itemCount: todoProvider.todo.length,
            itemBuilder: (context, index) {
              final todo = todoProvider.todo[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Slidable(
                  key: Key(todo.title),
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        padding: const EdgeInsets.all(10),
                        onPressed: (context) {
                          _showDeleteDialog(context, index, todo);
                        },
                        icon: Icons.delete,
                        backgroundColor: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      SlidableAction(
                        padding: const EdgeInsets.all(10),
                        onPressed: (context) {
                          if (todo.isCompleted) {
                            showSnackBarFun("Completed Todo cant be deleted");
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTodoPage(
                                todo: todo,
                                index: index,
                              ),
                            ),
                          );
                        },
                        icon: Icons.edit,
                        backgroundColor: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _colors[index % _colors.length],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        todo.description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      trailing: IconButton(
                        icon: todo.isCompleted
                            ? const Icon(
                                Icons.check_box,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.check_box_outline_blank,
                                color: Colors.white,
                              ),
                        onPressed: () {
                          todoProvider.toggleTodo(index);
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTodo = await Navigator.push<Todo>(
            context,
            MaterialPageRoute(builder: (context) => const AddTodoPage(),),
          );

          if (newTodo != null) {
            Provider.of<TodoProvider>(context, listen: false).addTodo(newTodo);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index, Todo todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Todo"),
          content: Text("Are you sure you want to delete ${todo.title}?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Provider.of<TodoProvider>(context, listen: false)
                    .deleteTodo(index);
                Navigator.of(context).pop();
                showSnackBarFun('${todo.title} deleted');
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void showSnackBarFun(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
