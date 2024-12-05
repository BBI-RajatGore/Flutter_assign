import 'package:fpdart/fpdart.dart';
import 'package:todo_app_clean_archit/core/error/failure.dart';
import 'package:todo_app_clean_archit/features/todo/domain/entities/todo.dart';
import 'package:todo_app_clean_archit/features/todo/domain/repository/todo_repository.dart';

class AddTodo {

  final TodoRepository repository;

  AddTodo(this.repository);

  Future<Either<Failure, List<Todo>>> call(Todo todo) {
    print("AddTodo  ${todo.id}");
    return repository.addTodo(todo);
    
  }

}
