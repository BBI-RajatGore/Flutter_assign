import 'package:ecommerce_app/features/auth/domain/entities/auth_model.dart';

abstract class AuthEvent {}

class SignUpEvent extends AuthEvent {
  final AuthModel authModel;
  SignUpEvent(this.authModel);
}

class SignInEvent extends AuthEvent {
  final AuthModel authModel;
  SignInEvent(this.authModel);
}

class SignInWithGoogleEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

class GetCurrentUserIdFromLocalEvent extends AuthEvent {}


class ForgotPasswordEvent extends AuthEvent{
  String email;

  ForgotPasswordEvent({required this.email});
}
