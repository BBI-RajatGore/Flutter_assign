import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_clean_archit/features/todo/domain/usecase/add_todo.dart';
import 'package:todo_app_clean_archit/features/todo/domain/usecase/delete_todo.dart';
import 'package:todo_app_clean_archit/features/todo/domain/usecase/get_todo.dart';
import 'package:todo_app_clean_archit/features/todo/domain/usecase/update_todo.dart';
import 'package:todo_app_clean_archit/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_app_clean_archit/features/todo/presentation/pages/home_page.dart';
import 'package:todo_app_clean_archit/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      home: BlocProvider<TodoBloc>(
        create: (_) => TodoBloc(
          addTodo: locator(),
          getAllTodo: locator(),
          deleteTodoById: locator(),
          updateTodo: locator(),
        ),
        child: HomePage(),
      ),
    );
  }
}
