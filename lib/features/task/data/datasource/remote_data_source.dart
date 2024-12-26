import 'package:firebase_database/firebase_database.dart';
import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';

abstract class RemoteDataSource {
  Future<Either<Failure, List<UserTask>>> fetchAllTasks(String userId);
  Future<Either<Failure, void>> addTask(UserTask task, String userId);
  Future<Either<Failure, void>> editTask(
      String userId, String taskId, UserTask task);
  Future<Either<Failure, void>> deleteTask(String userId, String taskId);
}

class RemoteDataSourceImpl extends RemoteDataSource {
  final DatabaseReference _taskRef = FirebaseDatabase.instance.ref('tasks');

  @override
  Future<Either<Failure, void>> addTask(UserTask task, String userId) async {
    try {

      final taskRef = _taskRef.child(userId).push();

      // not attaching id to toJson
      await taskRef.set(
        task.toJson(),
      );

      return const Right(null);

    } catch (error) {
      return Left(Failure("message"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String userId, String taskId) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> editTask(
      String userId, String taskId, UserTask task) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<UserTask>>> fetchAllTasks(String userId) async {
    try {
      final snapshot = await _taskRef.child(userId).get();

      if (snapshot.exists) {

        final tasksMap = Map<String, dynamic>.from(snapshot.value as Map);

        List<UserTask> tasks = [];

        // attaching taskid to each 
        tasksMap.forEach((taskId, taskData) {
          tasks.add(UserTask.fromJson(taskData, taskId));
        });

        tasks.sort((a, b) => b.dueDate.compareTo(a.dueDate));

        return Right(tasks);

      } else {
        return Left(Failure("Now task found"));
      }
    } catch (error) {
      return Left(Failure('Failed to load tasks: $error'));
    }
  }
}
