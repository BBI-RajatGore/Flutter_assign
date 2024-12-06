// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:todo_app_clean_archit/features/todo/domain/entities/todo.dart';

// abstract class TodoLocalDataSource {
//   Future<List<Todo>> getTodos();
//   Future<void> saveTodo(Todo todo);
//   Future<void> deleteTodo(int index);
//   Future<void> updateTodo(Todo todo);
// }

// class TodoLocalDataSourceImpl implements TodoLocalDataSource {
//   final SharedPreferences sharedPreferences;

//   TodoLocalDataSourceImpl({required this.sharedPreferences});

//   static const String _todoKey = 'todos';
//   static const String _todoIdCounterKey = 'todoIdCounter';

//   // List<Todo> _getTodosFromPrefs() {

//   //   print(sharedPreferences);

//   //   final String? todosJson = sharedPreferences.getString(_todoKey);

//   //   print("_getTodosFromPrefs :${todosJson}");
    
//   //   if (todosJson != null) {
//   //     List<dynamic> jsonList = json.decode(todosJson);
//   //     return jsonList.map((jsonItem) => Todo.fromJson(jsonItem)).toList();
//   //   }

    
//   //   return [];
//   // }


//   List<Todo> _getTodosFromPrefs() {
//   final String? todosJson = sharedPreferences.getString(_todoKey);

//   print("_getTodosFromPrefs : $todosJson");

//   if (todosJson != null && todosJson.isNotEmpty) {
//     try {
//       // Decode the JSON string into a list of dynamic items
//       List<dynamic> jsonList = json.decode(todosJson);
      
//       // Ensure that the items can be converted into Todo objects
//       return jsonList.map((jsonItem) => Todo.fromJson(jsonItem)).toList();
//     } catch (e) {
//       print("Error decoding todos: $e");
//       return [];  // Return an empty list if the decoding fails
//     }
//   } else {
//     return [];  // Return an empty list if todosJson is null or empty
//   }
// }


//   // Future<void> _saveTodosToPrefs(List<Todo> todos) async {
//   //   final List<Map<String, dynamic>> jsonList =
//   //       todos.map((todo) => todo.toJson()).toList();
//   //   final String todosJson = json.encode(jsonList);
//   //   await sharedPreferences.setString(_todoKey, todosJson);
//   // }

//   Future<void> _saveTodosToPrefs(List<Todo> todos) async {
//     final List<Map<String, dynamic>> jsonList =
//         todos.map((todo) => todo.toJson()).toList();
//     final String todosJson = json.encode(jsonList);

//     print("Saving todos to SharedPreferences: $todosJson");

//     await sharedPreferences.setString(_todoKey, todosJson);
//   }


//   int _getCurrentIdCounter() {
//     return sharedPreferences.getInt(_todoIdCounterKey) ?? 0;
//   }

//   Future<void> _incrementIdCounter() async {
//     final currentId = _getCurrentIdCounter();
//     await sharedPreferences.setInt(_todoIdCounterKey, currentId + 1);
//   }

//   @override
//   Future<List<Todo>> getTodos() async {
//     return _getTodosFromPrefs();
//   }

//   // @override
//   // Future<void> saveTodo(Todo todo) async {


//   //   print("save todo called");

//   //   List<Todo> todos = _getTodosFromPrefs();

    
//   //   final newId = _getCurrentIdCounter();


//   //   final newTodo = Todo(
//   //     id: newId,
//   //     title: todo.title,
//   //     description: todo.description,
//   //   );

 
//   //   todos.add(newTodo);

 
//   //   await _saveTodosToPrefs(todos);

//   //   await _incrementIdCounter();
//   // }

//   Future<void> saveTodo(Todo todo) async {
//   print("save todo called");

//   List<Todo> todos = _getTodosFromPrefs();

//   // Ensure the new todo has valid data
//   if (todo.title.isEmpty || todo.description.isEmpty) {
//     print("Invalid todo data: title or description is empty.");
//     return;
//   }

//   final newId = _getCurrentIdCounter();

//   final newTodo = Todo(
//     id: newId,
//     title: todo.title,
//     description: todo.description,
//   );

//   todos.add(newTodo);

//   await _saveTodosToPrefs(todos);

//   await _incrementIdCounter();
// }


//   @override
//   Future<void> deleteTodo(int index) async {
//     List<Todo> todos = _getTodosFromPrefs();
//     if (index >= 0 && index < todos.length) {
//       // Remove the todo at the given index
//       todos.removeAt(index);

//       // Save the updated list back to SharedPreferences
//       await _saveTodosToPrefs(todos);
//     }
//   }

//   @override
//   Future<void> updateTodo(Todo todo) async {
//     List<Todo> todos = _getTodosFromPrefs();

//     // Find the index of the todo with the given ID
//     final index = todos.indexWhere((t) => t.id == todo.id);

//     if (index != -1) {
//       // Update the todo at the found index
//       todos[index] = todo.copyWith(
//         title: todo.title,
//         description: todo.description,
//       );

//       // Save the updated list back to SharedPreferences
//       await _saveTodosToPrefs(todos);
//     } else {
//       throw Exception("Todo not found");
//     }
//   }
// }



// // import 'dart:convert';

// // import 'package:todo_app_clean_archit/features/todo/domain/entities/todo.dart';

// // abstract class TodoLocalDataSource {
// //   Future<List<Todo>> getTodos();
// //   Future<void> saveTodo(Todo todo);
// //   Future<void> deleteTodo(int index);
// //   Future<void> updateTodo(Todo todo);
// // }

// // class TodoLocalDataSourceImpl implements TodoLocalDataSource {
// //   // In-memory storage for todos
// //   List<Todo> _todos = [];
// //   int _todoIdCounter = 0;

// //   List<Todo> _getTodosFromMemory() {
// //     return List<Todo>.from(_todos);
// //   }

// //   Future<void> _saveTodosToMemory(List<Todo> todos) async {
// //     _todos = List<Todo>.from(todos);
// //   }

// //   int _getCurrentIdCounter() {
// //     return _todoIdCounter;
// //   }

// //   Future<void> _incrementIdCounter() async {
// //     _todoIdCounter++;
// //   }

// //   @override
// //   Future<List<Todo>> getTodos() async {
// //     return _getTodosFromMemory();
// //   }

// //   @override
// //   Future<void> saveTodo(Todo todo) async {
// //     List<Todo> todos = _getTodosFromMemory();

// //     // Assign a new ID to the todo
// //     final newId = _getCurrentIdCounter();

// //     final newTodo = Todo(
// //       id: newId,
// //       title: todo.title,
// //       description: todo.description,
// //     );

// //     // Add the new todo to the list
// //     todos.add(newTodo);

// //     // Save the updated list to in-memory storage
// //     await _saveTodosToMemory(todos);

// //     // Increment the ID counter
// //     await _incrementIdCounter();
// //   }

// //   @override
// //   Future<void> deleteTodo(int index) async {
// //     List<Todo> todos = _getTodosFromMemory();
// //     if (index >= 0 && index < todos.length) {
// //       // Remove the todo at the given index
// //       todos.removeAt(index);

// //       // Save the updated list to in-memory storage
// //       await _saveTodosToMemory(todos);
// //     }
// //   }

// //   @override
// //   Future<void> updateTodo(Todo todo) async {
// //     List<Todo> todos = _getTodosFromMemory();

// //     // Find the index of the todo with the given ID
// //     final index = todos.indexWhere((t) => t.id == todo.id);

// //     if (index != -1) {
// //       // Update the todo at the found index
// //       todos[index] = todo.copyWith(
// //         title: todo.title,
// //         description: todo.description,
// //       );

// //       // Save the updated list to in-memory storage
// //       await _saveTodosToMemory(todos);
// //     } else {
// //       throw Exception("Todo not found");
// //     }
// //   }
// // }


import 'package:hive/hive.dart';
import 'package:todo_app_clean_archit/features/todo/domain/entities/todo.dart';
import 'package:todo_app_clean_archit/service_locator.dart';

abstract class TodoLocalDataSource {
  Future<List<Todo>> getTodos();
  Future<void> saveTodo(Todo todo);
  Future<void> deleteTodo(int index);
  Future<void> updateTodo(Todo todo);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {

  final Box<Todo> todoBox;

  TodoLocalDataSourceImpl({required this.todoBox});

  @override
  Future<List<Todo>> getTodos() async {
    return todoBox.values.toList();
  }

  @override
  Future<void> saveTodo(Todo todo) async {
    await todoBox.add(todo); 
  }

  @override
  Future<void> deleteTodo(int id) async {

    final todoIndex = todoBox.values.toList().indexWhere((todo) => todo.id == id);

    if (todoIndex != -1) {
      await todoBox.deleteAt(todoIndex);
    } else {
      print("Todo with id $id not found.");
    }
  }


  @override
  Future<void> updateTodo(Todo todo) async {
    final index = todoBox.values.toList().indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      await todoBox.putAt(index, todo);
    } else {
      throw Exception("Todo not found");
    }
  }

}



