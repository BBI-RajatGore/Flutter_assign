
part of 'todo_bloc.dart';

abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoAddSuccess extends TodoState {
  final List<Todo> todos;

  TodoAddSuccess(this.todos);
}

class TodoFetchSuccess extends TodoState {

  final List<Todo> todos;

  TodoFetchSuccess(this.todos);

}

class TodoDeleteSuccess extends TodoState {}

class TodoUpdateSuccess extends TodoState {}

class TodoFailure extends TodoState {
  final String message;

  TodoFailure(this.message);
}
