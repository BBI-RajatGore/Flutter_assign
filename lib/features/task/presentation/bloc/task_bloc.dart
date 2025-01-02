import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/utils/shared_preference_filter.dart';
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
    on<FilterTasksEvent>(_onFilterTasks);
  }


  Future<void> _onFetchTasks(FetchTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final res = await fetchTasks.call(event.userId);
    res.fold(
      (l) {
        emit(TaskError(message: l.message));
      },
      (r) {
        _sortedTasks = _sortTasksByDueDate(r);
        _applyFilterPreferences(); 
      },
    );
  }


  List<UserTask> _sortTasksByDueDate(List<UserTask> tasks) {
    tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return tasks;
  }


  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final res = await addTask.call(event.task, event.userId);
    res.fold(
      (l) => emit(TaskError(message: l.message)),
      (r) {
        _sortedTasks.add(event.task);
        _sortedTasks = _sortTasksByDueDate(_sortedTasks);
        _applyFilterPreferences(); 
      },
    );
  }


  Future<void> _onEditTask(EditTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final res = await editTask.call(event.userId, event.taskId, event.task);
    res.fold(
      (l) => emit(TaskError(message: l.message)),
      (r) {
        _sortedTasks = _sortedTasks.map((task) {
          return task.id == event.taskId ? event.task : task;
        }).toList();
        _sortedTasks = _sortTasksByDueDate(_sortedTasks);
        _applyFilterPreferences(); 
      },
    );
  }


  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    final res = await deleteTask.call(event.userId, event.taskId);
    res.fold(
      (l) => emit(TaskError(message: l.message)),
      (r) {
        _sortedTasks.removeWhere((task) => task.id == event.taskId);
        _applyFilterPreferences(); 
      },
    );
  }


  Future<void> _applyFilterPreferences() async {

    final priority = await FilterPreferences.getFilterPriority();
   
    final isDesc = await FilterPreferences.getFilterIsDesc();

    List<UserTask> filteredTasks = _sortedTasks;

    if (priority != 'all') {
      filteredTasks = filteredTasks.where((task) => task.priority.name == priority).toList();
    }

    if(isDesc!=null){
      filteredTasks.sort((a, b) {
        int dateComparison = (isDesc) ? b.dueDate.compareTo(a.dueDate) : a.dueDate.compareTo(b.dueDate) ;
        if (dateComparison != 0) {
          return dateComparison;
        }
        return (isDesc) ? b.title.compareTo(a.title) : (a.title.compareTo(b.title));} );
    }

    emit(TaskLoaded(tasks: filteredTasks));
  }

  Future<void> _onFilterTasks(FilterTasksEvent event, Emitter<TaskState> emit) async {
    await FilterPreferences.saveFilterPreferences(event.priority, event.isDesc);
    _applyFilterPreferences(); 
  }

}
