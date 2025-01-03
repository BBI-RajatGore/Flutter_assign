

import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';

abstract class TaskRepository{
  Future<Either<Failure,List<UserTask>>> fetchAllTasks(String userId);
  // Stream<Either<Failure,List<UserTask>>> fetchAllTasks(String userId);
  Future<Either<Failure,void>> addTask(UserTask task,String userId);
  Future<Either<Failure, void>> editTask(String userId, String taskId, UserTask task);
  Future<Either<Failure, void>> deleteTask(String userId, String taskId);
  
}