part of 'todo_bloc.dart';

abstract class TodoEvent {}

class TodoAdd extends TodoEvent {
  Todo todo;

  TodoAdd({
    required this.todo
  });
}

class FetchAllTodos extends TodoEvent {}

class DeleteTodoById extends TodoEvent {

  final int id;

  DeleteTodoById(this.id);
}

class UpdateTodoById extends TodoEvent {
  final int index;
  final String newTitle;
  final String newDescription;

  UpdateTodoById({
    required this.index,
    required this.newTitle,
    required this.newDescription,
  });
}
