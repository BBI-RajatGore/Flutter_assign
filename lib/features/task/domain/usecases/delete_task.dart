import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteTask {

  final TaskRepository taskRepository;

  DeleteTask({required this.taskRepository});

  Future<Either<Failure, void>> call(String userId, String taskId) {
    return taskRepository.deleteTask(userId, taskId);
  }

}