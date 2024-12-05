import 'package:fpdart/fpdart.dart';
import 'package:todo_app_clean_archit/core/error/failure.dart';
import 'package:todo_app_clean_archit/features/todo/domain/repository/todo_repository.dart';

class UpdateTodo {

  final TodoRepository repository;

  UpdateTodo(this.repository);

  Future<Either<Failure, void>> call(int index, String newTitle, String newDescription) {
    return repository.updateTodo(index, newTitle, newDescription);
  }

}
