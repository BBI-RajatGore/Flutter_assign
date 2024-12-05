
import 'package:fpdart/fpdart.dart';
import 'package:todo_app_clean_archit/core/error/failure.dart';
import 'package:todo_app_clean_archit/features/todo/data/data_sources/todo_local_data_source.dart';
import 'package:todo_app_clean_archit/features/todo/domain/entities/todo.dart';
import 'package:todo_app_clean_archit/features/todo/domain/repository/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {

  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Todo>>> addTodo(Todo todo) async {
    try {
      print("repo impl  ${todo.title}");
      final todos = await localDataSource.saveTodo(todo);
      print(todo);
      return   Right(todos);
    } catch (e) {
      print("message form repo implawdawd ${e}");
      return Left(Failure("Failed to add todo"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(int index) async {
    try {
      await localDataSource.deleteTodo(index);
      return const Right(null);
    } catch (e) {
      return Left(Failure("Failed to delete todo"));
    }
  }

  @override
  Future<Either<Failure, void>> updateTodo(int index, String newTitle, String newDescription) async {
    try {
      await localDataSource.updateTodo(index, newTitle, newDescription);
      return const Right(null);
    } catch (e) {
      return Left(Failure("Failed to update todo"));
    }
  }

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    try {
      final todos = await localDataSource.getTodos();
      return Right(todos);
    } catch (e) {
      return Left(Failure("Failed to fetch todos"));
    }
  }
}
