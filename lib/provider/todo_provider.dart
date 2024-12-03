import 'package:flutter/material.dart';
import 'package:todo_list/models/todo_model.dart';

class TodoProvider with ChangeNotifier {
  
  final List<Todo> _todoList = [];

  //getter
  List<Todo> get todo => _todoList;

  bool addTodo(Todo todo) {
    
    bool exists = _todoList.any((currentTodo) => currentTodo.title == todo.title);

    if (exists) {
      return false;
    }

    _todoList.add(todo);
    notifyListeners();
    return true;
     
  }

  void toggleTodo(int index) {
    _todoList[index].isCompleted = !_todoList[index].isCompleted;
    notifyListeners(); 
  }

  void deleteTodo(int index) {
    _todoList.removeAt(index);
    notifyListeners();
  }
}
