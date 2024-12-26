abstract class AuthState {}

class AuthInitial extends AuthState{}

class AuthError extends AuthState{
  final String message;
  AuthError({required this.message});
}

class UserCreated extends AuthState {
  final String userId;
  UserCreated({required this.userId});
}