
import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';

class FetchTask {
  
  final TaskRepository taskRespository;
  FetchTask({required this.taskRespository});

  Future<Either<Failure,List<UserTask>>> call(String userId) async{
    return await taskRespository.fetchAllTasks(userId);
  }

}