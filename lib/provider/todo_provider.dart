import 'package:flutter/material.dart';
import 'package:todo_list/models/todo_model.dart';

class TodoProvider with ChangeNotifier {
  
  final List<Todo> _todoList = [];
  
  List<Todo> get todo => _todoList;

  // TodoProvider(){
  //   _loadTodo();

  // }

  // _loadTodo()
  //_saveTodo()


  bool addTodo(Todo todo) {
    
    bool exists = _todoList.any((currentTodo) => currentTodo.title == todo.title);

    if (exists) {
      return false;
    }

    _todoList.add(todo);
    // _saveTodo();
    notifyListeners();
    return true;
     
  }

  void toggleTodo(int index) {
    _todoList[index].isCompleted = !_todoList[index].isCompleted;
    // _saveTodo();
    notifyListeners(); 
  }

  void deleteTodo(int index) {
    _todoList.removeAt(index);
    // _saveTodo();
    notifyListeners();
  }

  void updateTodo(int index,String title,String desc){

    _todoList[index].title = title;
    _todoList[index].description = desc;

    // _saveTodo();

    notifyListeners();
  }

}
