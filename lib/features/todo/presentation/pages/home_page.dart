import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app_clean_archit/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_app_clean_archit/features/todo/presentation/pages/add_edit_todo_screen.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo List',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            print("loadinggg.........");
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TodoFetchSuccess) {
            print("TodoSuccessState.......");
            return SlidableAutoCloseBehavior(
              child: ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, index) {
                  final todo = state.todos[index];
                  return Slidable(
                    key: Key(todo.id.toString()),
                    endActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          padding: const EdgeInsets.all(10),
                          onPressed: (context) {
                            context.read<TodoBloc>()
                                .add(DeleteTodoById(id: todo.id));
                          },
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ],
                    ),
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      elevation: 5,
                      child: ListTile(
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            size: 25,
                            color: Colors.teal,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddEditTodoScreen(todo: todo),
                              ),
                            ).then((_) {
                              context.read<TodoBloc>().add(FetchAllTodos());
                            });
                          },
                        ),
                        title: Text(
                          todo.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          todo.description,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is TodoFailure) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const Center(child: Text("No Todos Available"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditTodoScreen(),
            ),
          ).then((_) {
            context.read<TodoBloc>().add(FetchAllTodos());
          });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
