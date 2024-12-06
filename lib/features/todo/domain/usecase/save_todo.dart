import 'package:fpdart/fpdart.dart';
import 'package:todo_app_clean_archit/core/error/failure.dart';
import 'package:todo_app_clean_archit/features/todo/domain/entities/todo.dart';
import 'package:todo_app_clean_archit/features/todo/domain/repository/todo_repository.dart';

class SaveTodo {
  final TodoRepository repository;

  SaveTodo(this.repository);

  Future<Either<Failure,void>> call(Todo todo) async {
    return await repository.saveTodo(todo);
  }
}
