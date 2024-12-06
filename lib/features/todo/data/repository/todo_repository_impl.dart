import 'package:fpdart/fpdart.dart';
import 'package:todo_app_clean_archit/core/error/failure.dart';
import 'package:todo_app_clean_archit/features/todo/domain/entities/todo.dart';
import 'package:todo_app_clean_archit/features/todo/domain/repository/todo_repository.dart';
import 'package:todo_app_clean_archit/features/todo/data/data_sources/todo_local_data_source.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> saveTodo(Todo todo) async {
    try {
      await localDataSource.saveTodo(todo);
      return const Right(null);
    } catch (e) {
      return Left(Failure("Failed to add todo"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(int index) async {
    try {
      print("delelet doto impl calledd");
      await localDataSource.deleteTodo(index);
      return const Right(null);
    } catch (e) {
      print("delete todo ${e}");
      return Left(Failure("Failed to delete todo"));
    }
  }

  @override
  Future<Either<Failure, void>> updateTodo(Todo todo) async {
    try {
      await localDataSource.updateTodo(todo);
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
