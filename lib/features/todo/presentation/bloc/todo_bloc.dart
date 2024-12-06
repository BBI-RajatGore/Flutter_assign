
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_clean_archit/features/todo/domain/entities/todo.dart';
import 'package:todo_app_clean_archit/features/todo/domain/usecase/delete_todo.dart';
import 'package:todo_app_clean_archit/features/todo/domain/usecase/get_todo.dart';
import 'package:todo_app_clean_archit/features/todo/domain/usecase/save_todo.dart';
import 'package:todo_app_clean_archit/features/todo/domain/usecase/update_todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {

  final SaveTodo _addTodo;
  final GetTodos _getAllTodo;
  final DeleteTodo _deleteTodoById;
  final UpdateTodo _updateTodo;

  TodoBloc({
    required SaveTodo addTodo,
    required GetTodos getAllTodo,
    required DeleteTodo deleteTodoById,
    required UpdateTodo updateTodo,
  })  : _addTodo = addTodo,
        _getAllTodo = getAllTodo,
        _deleteTodoById = deleteTodoById,
        _updateTodo = updateTodo,
        super(TodoInitial()) {



      on<TodoAdd>(_onTodoAdd);
      on<FetchAllTodos>(_onFetchAllTodos);
      on<DeleteTodoById>(_onDeleteTodo);
      on<UpdateTodoById>(_onUpdateTodoById);

  }

  // void addScreen(Todo todo) {
  //   add(TodoAdd(todo: todo));
  // }

  void _onTodoAdd(TodoAdd event, Emitter<TodoState> emit) async {

    emit(TodoLoading());

    print("call in addtodo");

    final res = await _addTodo.call(event.todo);

    res.fold(
      (l) {
        print("failure in add todo : ${l}");
        emit(TodoFailure(l.message));
      },
      (r) {
        print("success in add todo ");
        add(FetchAllTodos());
      },
    );
  }

  void _onFetchAllTodos(FetchAllTodos event, Emitter<TodoState> emit) async {

    print("featching doto....");
    emit(TodoLoading());

    final res = await _getAllTodo.call();

    res.fold(
      (l){ 
        print("failure in fetching todo");
        emit(TodoFailure(l.message));
      },
      (r) { 
        print("success in fetching todo ${r}");
        emit(TodoFetchSuccess(r));
      },
    );
  }

void _onDeleteTodo(DeleteTodoById event, Emitter<TodoState> emit) async {

  print("deleteing todo called ${event.id}");

  emit(TodoLoading());

  final res = await _deleteTodoById.call(event.id);

  res.fold(
    (l) {
      print("failed to delete tod ${l.message}");
      emit(TodoFailure(l.message));
    },
    (r){
      print("success in delete todo ");
      add(FetchAllTodos());
    },
  );
}

void _onUpdateTodoById(UpdateTodoById event, Emitter<TodoState> emit) async {
  emit(TodoLoading());

  final updatedTodo = event.todo;

  final res = await _updateTodo.call(updatedTodo);

  res.fold(
    (l) => emit(TodoFailure(l.message)),
    (r) => add(FetchAllTodos()),
  );
}

}