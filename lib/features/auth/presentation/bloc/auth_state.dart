abstract class AuthState {}

class AuthInitial extends AuthState{}

class Loading extends AuthState{}

class AuthError extends AuthState{
  final String message;
  AuthError({required this.message});
}

class UserLoggedIn extends AuthState{
  final String userId;
  UserLoggedIn({required this.userId});
}

class UserPresent extends AuthState{
  final String userId;
  UserPresent({required this.userId});
}


class UserLoggedOut extends AuthState{}