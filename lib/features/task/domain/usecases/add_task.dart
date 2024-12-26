
import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';

class AddTask {

  final TaskRepository taskRespository;

  AddTask({required this.taskRespository});

  Future<Either<Failure,void>>  call(UserTask task,String userId) async{
    return await taskRespository.addTask(task, userId);
  }

}