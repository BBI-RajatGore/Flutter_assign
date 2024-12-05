import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_clean_archit/features/todo/domain/entities/todo.dart';
import 'package:todo_app_clean_archit/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_app_clean_archit/service_locator.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Fetch all todos when the HomePage is loaded
    context.read<TodoBloc>().add(FetchAllTodos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoFetchSuccess) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.description),
                );
              },
            );
          } else if (state is TodoFailure) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const Center(child: Text("No Todos Available"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final todo = Todo(
            id: DateTime.now().millisecondsSinceEpoch, // dynamically generate an ID
            title: 'New Todo',
            description: 'This is a new Todo description',
          );
          locator<TodoBloc>().addScreen(todo);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
