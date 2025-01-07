import 'package:task_manager/features/task/domain/entities/usertask.dart';

abstract class TaskEvent {}

class FetchTasksEvent extends TaskEvent {
  final String userId;
  FetchTasksEvent({required this.userId});
}

class AddTaskEvent extends TaskEvent {
  final String userId;
  final UserTask task;
  AddTaskEvent({required this.userId, required this.task});
}

class EditTaskEvent extends TaskEvent {
  final String userId;
  final String taskId;
  final UserTask task;
  EditTaskEvent({required this.userId, required this.taskId, required this.task});
}

class DeleteTaskEvent extends TaskEvent {
  final String userId;
  final String taskId;
  DeleteTaskEvent({required this.userId, required this.taskId});
}

class FilterTasksEvent extends TaskEvent {
  final String userId;
  final String? priority;
  final bool? isDesc;
  
  FilterTasksEvent({required this.userId, this.priority,this.isDesc});
}


class UserLoggedOutEvent extends TaskEvent {}


// class FetchTasksEvent extends TaskEvent {
//   final String userId;

//   FetchTasksEvent({required this.userId});
// }