import 'package:fpdart/fpdart.dart';
import 'package:todo_app_clean_archit/core/error/failure.dart';
import 'package:todo_app_clean_archit/features/todo/domain/entities/todo.dart';


abstract class TodoRepository {
  Future<Either<Failure,List<Todo>>> getTodos();
  Future<Either<Failure,List<Todo>>> addTodo(Todo todo);
  Future<Either<Failure,void>> deleteTodo(int index);
  Future<Either<Failure,void>> updateTodo(int index, String newTitle, String newDescription);
}
