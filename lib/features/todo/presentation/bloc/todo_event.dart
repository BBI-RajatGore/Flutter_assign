part of 'todo_bloc.dart';

abstract class TodoEvent {}

class TodoAdd extends TodoEvent {
  Todo todo;

  TodoAdd({
    required this.todo
  });
}

class FetchAllTodos extends TodoEvent {}


class UpdateTodoById extends TodoEvent {
  final Todo todo;

  UpdateTodoById({required this.todo});
}

class DeleteTodoById extends TodoEvent {
  final int id;

  DeleteTodoById({required this.id});
}