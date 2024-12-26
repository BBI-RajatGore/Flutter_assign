import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/task/domain/usecases/add_task.dart';
import 'package:task_manager/features/task/domain/usecases/delete_task.dart';
import 'package:task_manager/features/task/domain/usecases/edit_task.dart';
import 'package:task_manager/features/task/domain/usecases/fetch_task.dart';
import 'package:task_manager/features/task/presentation/bloc/task_event.dart';
import 'package:task_manager/features/task/presentation/bloc/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {

  final FetchTask fetchTasks;
  final AddTask addTask;
  final EditTask editTask;
  final DeleteTask deleteTask;

  TaskBloc({
    required this.fetchTasks,
    required this.addTask,
    required this.editTask,
    required this.deleteTask,
  }) : super(TaskInitial()) {
    on<FetchTasksEvent>(_onFetchTasks);
    on<AddTaskEvent>(_onAddTask);
  }

  Future<void> _onFetchTasks(FetchTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final res = await fetchTasks.call(event.userId);
    res.fold(
      (l) => emit(TaskError(message: l.message)),
      (r) { 
        print(r.length);
        emit(TaskLoaded(tasks: r));
      },
    );
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final res = await addTask.call(event.task,event.userId);
    res.fold(
      (l) => emit(TaskError(message: l.message)),
      (r) { 
        print("right message from add task");
        // emit(TaskLoaded(tasks));
      },
    );
  }



  
}



/*



    on<EditTaskEvent>(_onEditTask);
    on<DeleteTaskEvent>(_onDeleteTask);

  Future<void> _onEditTask(EditTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final res = await editTask.call(event.userId, event.taskId, event.task);
    res.fold(
      (l) => emit(TaskError(message: l)),
      (r) => emit(TaskEdited(task: r)),
    );
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final res = await deleteTask.call(event.userId, event.taskId);
    res.fold(
      (l) => emit(TaskError(message: l)),
      (r) => emit(TaskDeleted()),
    );
  }

 */