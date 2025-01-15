import 'package:ecommerce_app/features/auth/domain/usecase/get_uid_from_local_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/signin_with_email_password_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/signin_with_google_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/signout_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/signup_with_email_password_usecase.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpWithEmailPassword signUpWithEmailPassword;
  final SignInWithEmailPassword signInWithEmailPassword;
  final SignInWithGoogle signInWithGoogle;
  final SignOut signOut;
  final GetUidFromLocalDataSource getUidFromLocalDataSource;

  AuthBloc({
    required this.signUpWithEmailPassword,
    required this.signInWithEmailPassword,
    required this.signInWithGoogle,
    required this.signOut,
    required this.getUidFromLocalDataSource
  }) : super(AuthInitial()) {
    on<SignUpEvent>(_onSignUp);
    on<SignInEvent>(_onSignIn);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignOutEvent>(_onSignOut);
    on<GetCurrentUserIdFromLocalEvent>(_onGetCurrentUserIdFromLocal);
  }


  Future<void> _onSignUp(
      SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signUpWithEmailPassword.call(event.authModel);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) {
        print("This is user signup : ${user!.uid}" );
        emit(AuthSignedIn(user!));
      },
    );
  }


  Future<void> _onSignIn(
      SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signInWithEmailPassword.call(event.authModel);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
       (user) {
        print("This is user signin: ${user!.uid}" );
        emit(AuthSignedIn(user!));
      },
    );
  }

  Future<void> _onSignInWithGoogle(
      SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signInWithGoogle.call();
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) {
        print("This is user signin with google: ${user!.photoURL}" );
        emit(AuthSignedIn(user!));
      },
    );
  }


  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signOut.call();
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(AuthSignedOut()),
    );
  }

  Future<void> _onGetCurrentUserIdFromLocal(
      GetCurrentUserIdFromLocalEvent event, Emitter<AuthState> emit) async {
        print("getting uid from local");
    final result = await getUidFromLocalDataSource.call();
    result.fold(
      (failure){
        print("error while getting uid");
        emit(AuthInitial());
      },
      (userId){ 
        print("This is user id from local: $userId");
        emit(UserPresent(userId!));
      },
    );
  }



}
