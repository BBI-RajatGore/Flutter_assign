// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:task_manager/features/task/domain/usecases/add_task.dart';
// import 'package:task_manager/features/task/domain/usecases/delete_task.dart';
// import 'package:task_manager/features/task/domain/usecases/edit_task.dart';
// import 'package:task_manager/features/task/domain/usecases/fetch_task.dart';
// import 'package:task_manager/features/task/presentation/bloc/task_event.dart';
// import 'package:task_manager/features/task/presentation/bloc/task_state.dart';

// class TaskBloc extends Bloc<TaskEvent, TaskState> {

//   final FetchTask fetchTasks;
//   final AddTask addTask;
//   final EditTask editTask;
//   final DeleteTask deleteTask;

//   final DatabaseReference _taskRef = FirebaseDatabase.instance.ref('tasks');

//   TaskBloc({
//     required this.fetchTasks,
//     required this.addTask,
//     required this.editTask,
//     required this.deleteTask,
//   }) : super(TaskInitial()) {
//     on<FetchTasksEvent>(_onFetchTasks);
//     on<AddTaskEvent>(_onAddTask);
//     on<EditTaskEvent>(_onEditTask);
//     on<DeleteTaskEvent>(_onDeleteTask);
//   }

//   Future<void> _onFetchTasks(FetchTasksEvent event, Emitter<TaskState> emit) async {
//     emit(TaskLoading());
//     final res = await fetchTasks.call(event.userId);
//     res.fold(
//       (l) => emit(TaskError(message: l.message)),
//       (r) { 
//         print(r.length);
//         emit(TaskLoaded(tasks: r));
//       },
//     );
//   }

//   Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
//     emit(TaskLoading());
//     final res = await addTask.call(event.task,event.userId);
//     res.fold(
//       (l) => emit(TaskError(message: l.message)),
//       (r) { 
//         print("right message from add task");
//         // emit(TaskLoaded(tasks));
//       },
//     );
//   }


//   Future<void> _onEditTask(EditTaskEvent event, Emitter<TaskState> emit) async {
//     emit(TaskLoading());
//     final res = await editTask.call(event.userId, event.taskId, event.task);
//     res.fold(
//       (l) => emit(TaskError(message: l.message)),
//       (r) => emit(TaskEdited()),
//     );
//   }

//   Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
//     emit(TaskLoading());
//     final res = await deleteTask.call(event.userId, event.taskId);
//     res.fold(
//       (l) => emit(TaskError(message: l.message),),
//       (r) => emit(TaskDeleted(),),
//     );
//   }

// }


import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/task/domain/usecases/add_task.dart';
import 'package:task_manager/features/task/domain/usecases/delete_task.dart';
import 'package:task_manager/features/task/domain/usecases/edit_task.dart';
import 'package:task_manager/features/task/domain/usecases/fetch_task.dart';
import 'package:task_manager/features/task/presentation/bloc/task_event.dart';
import 'package:task_manager/features/task/presentation/bloc/task_state.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final FetchTask fetchTasks;
  final AddTask addTask;
  final EditTask editTask;
  final DeleteTask deleteTask;

  final DatabaseReference _taskRef = FirebaseDatabase.instance.ref('tasks');

  List<UserTask> _sortedTasks = [];

  TaskBloc({
    required this.fetchTasks,
    required this.addTask,
    required this.editTask,
    required this.deleteTask,
  }) : super(TaskInitial()) {
    on<FetchTasksEvent>(_onFetchTasks);
    on<AddTaskEvent>(_onAddTask);
    on<EditTaskEvent>(_onEditTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  // Sort tasks by due date
  List<UserTask> _sortTasksByDueDate(List<UserTask> tasks) {
    tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return tasks;
  }

  // Handle fetching tasks
  Future<void> _onFetchTasks(FetchTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final res = await fetchTasks.call(event.userId);
    res.fold(
      (l){
        emit(TaskError(message: l.message));
      },
      (r) {
        _sortedTasks = _sortTasksByDueDate(r);
        emit(TaskLoaded(tasks: _sortedTasks));
      },
    );
  }

  // Handle adding a task
  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final res = await addTask.call(event.task, event.userId);
    res.fold(
      (l) => emit(TaskError(message: l.message)),
      (r) {
        // Add the new task to the sorted list
        _sortedTasks.add(event.task);
        _sortedTasks = _sortTasksByDueDate(_sortedTasks);
        emit(TaskLoaded(tasks: _sortedTasks));
      },
    );
  }

  // Handle editing a task
  Future<void> _onEditTask(EditTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final res = await editTask.call(event.userId, event.taskId, event.task);
    res.fold(
      (l) => emit(TaskError(message: l.message)),
      (r) {
        // Update the task and resort the list
        _sortedTasks = _sortedTasks.map((task) {
          return task.id == event.taskId ? event.task : task;
        }).toList();
        _sortedTasks = _sortTasksByDueDate(_sortedTasks);
        emit(TaskLoaded(tasks: _sortedTasks));
      },
    );
  }

  // Handle deleting a task
  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    // emit(TaskLoading());
    final res = await deleteTask.call(event.userId, event.taskId);
    res.fold(
      (l) => emit(TaskError(message: l.message)),
      (r) {
        // Remove the task from the sorted list
        _sortedTasks.removeWhere((task) => task.id == event.taskId);
        emit(TaskLoaded(tasks: _sortedTasks));
      },
    );
  }
}
