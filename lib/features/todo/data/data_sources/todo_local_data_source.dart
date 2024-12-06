import 'package:hive/hive.dart';
import 'package:todo_app_clean_archit/features/todo/domain/entities/todo.dart';


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



