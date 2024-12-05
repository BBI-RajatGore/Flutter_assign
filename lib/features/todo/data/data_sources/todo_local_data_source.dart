// import 'dart:convert'; // For JSON decoding
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:todo_app_clean_archit/features/todo/domain/entities/todo.dart';

// abstract class TodoLocalDataSource {
//   Future<List<Todo>> getTodos();
//   Future<List<Todo>> saveTodo(Todo todo);
//   Future<void> deleteTodo(int index);
//   Future<void> updateTodo(int index, String newTitle, String newDescription);
// }

// class TodoLocalDataSourceImpl implements TodoLocalDataSource {
//   final SharedPreferences sharedPreferences;

//   TodoLocalDataSourceImpl({required this.sharedPreferences});

//   @override
//   Future<List<Todo>> getTodos() async {
//     // Fetch the list of JSON strings from SharedPreferences
//     List<String> todoJsonList = sharedPreferences.getStringList('todos') ?? [];

//     // Convert each JSON string into a Todo object
//     return todoJsonList.map((todoJson) {
//       Map<String, dynamic> map = jsonDecode(todoJson);  // Deserialize JSON
//       return Todo.fromMap(map);
//     }).toList();
//   }

//   @override
//   Future<List<Todo>> saveTodo(Todo todo) async {
//     print("Local data sourceeee");

//     // Fetch the list of current todos
//     List<String> todoJsonList = sharedPreferences.getStringList('todos') ?? [];

//     // Add the new Todo to the list
//     todoJsonList.add(jsonEncode(todo.toMap()));  // Serialize Todo to JSON

//     // Save the updated list back to SharedPreferences
//     await sharedPreferences.setStringList('todos', todoJsonList);

//     // Return the updated list of Todo objects
//     return todoJsonList.map((todoJson) {
//       Map<String, dynamic> map = jsonDecode(todoJson);  // Deserialize JSON
//       return Todo.fromMap(map);
//     }).toList();
//   }

//   @override
//   Future<void> deleteTodo(int index) async {
//     List<String> todoJsonList = sharedPreferences.getStringList('todos') ?? [];
    
//     // Remove the todo at the specified index
//     todoJsonList.removeAt(index);

//     // Save the updated list to SharedPreferences
//     await sharedPreferences.setStringList('todos', todoJsonList);
//   }

//   @override
//   Future<void> updateTodo(int index, String newTitle, String newDescription) async {
//     List<String> todoJsonList = sharedPreferences.getStringList('todos') ?? [];

//     // Update the todo at the specified index
//     Map<String, dynamic> updatedTodo = {
//       'title': newTitle,
//       'description': newDescription,
//       'isCompleted': 0,  // You may need to update the 'isCompleted' value as well
//     };

//     // Replace the old todo with the new one
//     todoJsonList[index] = jsonEncode(updatedTodo); // Serialize updated Todo to JSON

//     // Save the updated list to SharedPreferences
//     await sharedPreferences.setStringList('todos', todoJsonList);
//   }
// }







import 'dart:convert'; // For JSON decoding
import 'package:todo_app_clean_archit/features/todo/domain/entities/todo.dart';

abstract class TodoLocalDataSource {
  Future<List<Todo>> getTodos();
  Future<List<Todo>> saveTodo(Todo todo);
  Future<void> deleteTodo(int index);
  Future<void> updateTodo(int index, String newTitle, String newDescription);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  // In-memory list to store the todos
  List<Todo> _todos = [];

  @override
  Future<List<Todo>> getTodos() async {
    // Return the list of todos
    return _todos;
  }

  @override
  Future<List<Todo>> saveTodo(Todo todo) async {
    // Add the new Todo to the list
    _todos.add(todo);

    // Return the updated list of Todo objects
    return _todos;
  }

  @override
  Future<void> deleteTodo(int index) async {
    // Remove the todo at the specified index
    if (index >= 0 && index < _todos.length) {
      _todos.removeAt(index);
    }
  }

  @override
  Future<void> updateTodo(int index, String newTitle, String newDescription) async {
    // Update the todo at the specified index
    if (index >= 0 && index < _todos.length) {
      _todos[index] = Todo(
        id: _todos[index].id,
        title: newTitle,
        description: newDescription,
        isCompleted: _todos[index].isCompleted,
      );
    }
  }
}

