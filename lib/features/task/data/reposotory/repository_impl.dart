
import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/task/data/datasource/remote_data_source.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';

class RepositoryImpl  extends TaskRepository{
  
  RemoteDataSource remoteDataSource;

  RepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> addTask(UserTask task, String userId) async {
    return  await remoteDataSource.addTask(task, userId);
  }

  @override
  Future<Either<Failure, void>> deleteTask(String userId, String taskId) async {
    return await remoteDataSource.deleteTask(userId, taskId);
  }

  @override
  Future<Either<Failure, void>> editTask(String userId, String taskId, UserTask task) async {
    return await remoteDataSource.editTask(userId, taskId, task);
  }

  @override
  Future<Either<Failure, List<UserTask>>> fetchAllTasks(String userId) async {
    return await remoteDataSource.fetchAllTasks(userId);
  }

  // @override
  // Stream<Either<Failure, List<UserTask>>> fetchAllTasks(String userId) {
  //   // Return the stream from the RemoteDataSource that listens for real-time changes
  //   return remoteDataSource.fetchAllTasks(userId);
  // }

}