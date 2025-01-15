import 'package:firebase_auth/firebase_auth.dart';


abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignedIn extends AuthState {
  final User user;
  AuthSignedIn(this.user);
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

class AuthSignedOut extends AuthState {}

class UserPresent extends AuthState {
  final String uid;
  UserPresent(this.uid);
}


