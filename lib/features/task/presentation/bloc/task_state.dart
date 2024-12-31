// // task_state.dart

// import 'package:task_manager/features/task/domain/entities/usertask.dart';

// abstract class TaskState {}

// class TaskInitial extends TaskState {}

// class TaskLoading extends TaskState {}

// class TaskLoaded extends TaskState {
//   final List<UserTask> tasks;

//   TaskLoaded({required this.tasks});
// }

// class TaskAdded extends TaskState {

//   final UserTask task;

//   TaskAdded({required this.task});
// }

// class TaskEdited extends TaskState {}

// class TaskDeleted extends TaskState {}

// class TaskError extends TaskState {
//   final String message;

//   TaskError({required this.message});

// }



// import 'package:task_manager/features/task/domain/entities/usertask.dart';

// abstract class TaskState {}

// class TaskInitial extends TaskState {}

// class TaskLoading extends TaskState {}

// class TaskLoaded extends TaskState {
//   final List<UserTask> tasks;

//   TaskLoaded({required this.tasks});
// }

// class TaskAdded extends TaskState {
//   final UserTask task;

//   TaskAdded({required this.task});
// }

// class TaskEdited extends TaskState {}

// class TaskDeleted extends TaskState {}

// class TaskError extends TaskState {
//   final String message;

//   TaskError({required this.message});
// }


import 'package:task_manager/features/task/domain/entities/usertask.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<UserTask> tasks;
  TaskLoaded({required this.tasks});
}

class TaskAdded extends TaskState {
  final UserTask task;
  TaskAdded({required this.task});
}

class TaskEdited extends TaskState {}

class TaskDeleted extends TaskState {}

class TaskError extends TaskState {
  final String message;
  TaskError({required this.message});
}
