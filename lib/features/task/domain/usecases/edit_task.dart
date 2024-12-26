import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';

import 'package:fpdart/fpdart.dart';

class EditTask {
  final TaskRepository taskRepository;

  EditTask({required this.taskRepository});

  Future<Either<Failure, void>> call(String userId, String taskId, UserTask task) {
    return taskRepository.editTask(userId, taskId, task);
  }
}