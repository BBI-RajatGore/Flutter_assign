import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_clean_archit/features/todo/domain/entities/todo.dart';
import 'package:todo_app_clean_archit/features/todo/domain/usecase/add_todo.dart';
import 'package:todo_app_clean_archit/features/todo/domain/usecase/delete_todo.dart';
import 'package:todo_app_clean_archit/features/todo/domain/usecase/get_todo.dart';
import 'package:todo_app_clean_archit/features/todo/domain/usecase/update_todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final AddTodo _addTodo;
  final GetTodos _getAllTodo;
  final DeleteTodo _deleteTodoById;
  final UpdateTodo _updateTodo;

  TodoBloc({
    required AddTodo addTodo,
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

  void addScreen(Todo todo) {
    add(TodoAdd(todo: todo));
  }

  void _onTodoAdd(TodoAdd event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    final res = await _addTodo.call(event.todo);

    res.fold(
      (l) {
        emit(TodoFailure(l.message));
      },
      (r) {
        // After adding a todo, fetch all todos
        add(FetchAllTodos());
      },
    );
  }

  void _onFetchAllTodos(FetchAllTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    final res = await _getAllTodo.call();

    res.fold(
      (l) => emit(TodoFailure(l.message)),
      (r) => emit(TodoFetchSuccess(r)),
    );
  }

  void _onDeleteTodo(DeleteTodoById event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    final res = await _deleteTodoById.call(event.id);

    res.fold(
      (l) => emit(TodoFailure(l.message)),
      (r) => emit(TodoDeleteSuccess()),
    );
  }

  void _onUpdateTodoById(UpdateTodoById event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    final res = await _updateTodo.call(
      event.index,
      event.newTitle,
      event.newDescription,
    );

    res.fold(
      (l) => emit(TodoFailure(l.message)),
      (r) => emit(TodoUpdateSuccess()),
    );
  }
}
