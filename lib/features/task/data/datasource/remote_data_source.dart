
import 'package:firebase_database/firebase_database.dart';
import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';

abstract class RemoteDataSource {
  Future<Either<Failure, List<UserTask>>> fetchAllTasks(String userId);
  Future<Either<Failure, void>> addTask(UserTask task, String userId);
  Future<Either<Failure, void>> editTask(String userId, String taskId, UserTask task);
  Future<Either<Failure, void>> deleteTask(String userId, String taskId);
}

class RemoteDataSourceImpl extends RemoteDataSource {

  final DatabaseReference taskRef;

  RemoteDataSourceImpl({required this.taskRef});

  @override
  Future<Either<Failure, void>> addTask(UserTask task, String userId) async {
    try {
      final taskRefe = taskRef.child(userId).push();
      await taskRefe.set(task.toJson()); // Save task data under the new ID
      return const Right(null);
    } catch (error) {
      return Left(Failure("Failed to add task"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String userId, String taskId) async {
    try {
      // Check if the task exists before attempting to delete it
      final taskSnapshot = await taskRef.child(userId).child(taskId).get();
      print("here");
      if (!taskSnapshot.exists) {
        return Left(Failure('Task not found'));
      }

      // If task exists, delete it
      await taskRef.child(userId).child(taskId).remove();
      return const Right(null);
    } catch (e) {
      return Left(Failure('Failed to delete task: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> editTask(String userId, String taskId, UserTask task) async {
    try {
      // Check if the task exists before attempting to update it
      final taskSnapshot = await taskRef.child(userId).child(taskId).get();
      if (!taskSnapshot.exists) {
        return Left(Failure('Task not found'));
      }

      // If task exists, update it
      await taskRef.child(userId).child(taskId).update(task.toJson());
      return const Right(null);
    } catch (error) {
      return Left(Failure('Failed to edit task: $error'));
    }
  }

  @override
  Future<Either<Failure, List<UserTask>>> fetchAllTasks(String userId) async {
    try {
      final snapshot = await taskRef.child(userId).get();

      if (snapshot.exists) {
        final tasksMap = Map<String, dynamic>.from(snapshot.value as Map);
        List<UserTask> tasks = [];

        // Attaching taskId to each UserTask
        tasksMap.forEach((taskId, taskData) {
          tasks.add(UserTask.fromJson(taskData, taskId));
        });

        return Right(tasks);
      } else {
        return Left(Failure("No Task Found"));
      }
    } catch (error) {
      return Left(Failure('Failed to load tasks: $error'));
    }
  }
}
