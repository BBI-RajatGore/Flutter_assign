import 'package:fpdart/fpdart.dart';
import 'package:todo_app_clean_archit/core/error/failure.dart';
import 'package:todo_app_clean_archit/features/todo/domain/entities/todo.dart';
import 'package:todo_app_clean_archit/features/todo/domain/repository/todo_repository.dart';

class GetTodos {
  final TodoRepository repository;

  GetTodos(this.repository);

  Future<Either<Failure, List<Todo>>> call() {
    return repository.getTodos();
  }
}
