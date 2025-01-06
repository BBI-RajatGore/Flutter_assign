
import 'package:firebase_database/firebase_database.dart';
import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';

abstract class RemoteDataSource {
  Future<Either<Failure, List<UserTask>>> fetchAllTasks(String userId);
  // Stream<Either<Failure, List<UserTask>>> fetchAllTasks(String userId);
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
      await taskRefe.set(task.toJson()); 
      return const Right(null);
    } catch (error) {
      return Left(Failure("Failed to add task"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String userId, String taskId) async {
    try {
      final taskRefe = taskRef.child(userId).child(taskId);
      await taskRefe.remove();
      return const Right(null);
    } catch (e) {
      return Left(Failure('Failed to delete task: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> editTask(String userId, String taskId, UserTask task) async {
    try {
      final taskRefe =  taskRef.child(userId).child(taskId);
      await taskRefe.update(task.toJson());
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


  //   @override
  // Stream<Either<Failure, List<UserTask>>> fetchAllTasks(String userId) async* {
  //   try {
  //     final taskStream = taskRef.child(userId).onValue;
      
  //     await for (var snapshot in taskStream) {
  //       if (snapshot.snapshot.exists) {
  //         final tasksMap = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
  //         List<UserTask> tasks = [];

  //         tasksMap.forEach((taskId, taskData) {
  //           tasks.add(UserTask.fromJson(taskData, taskId));
  //         });

  //         yield Right(tasks); // Emit the fetched tasks
  //       } else {
  //         yield Left(Failure("No tasks found"));
  //       }
  //     }
  //   } catch (error) {
  //     yield Left(Failure('Failed to fetch tasks: $error'));
  //   }
  // }
}
