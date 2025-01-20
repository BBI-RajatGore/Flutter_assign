import 'package:ecommerce_app/features/auth/domain/usecase/forgot_password_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/get_uid_from_local_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/signin_with_email_password_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/signin_with_google_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/signout_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/signup_with_email_password_usecase.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpWithEmailPassword signUpWithEmailPassword;
  final SignInWithEmailPassword signInWithEmailPassword;
  final SignInWithGoogle signInWithGoogle;
  final SignOut signOut;
  final GetUidFromLocalDataSource getUidFromLocalDataSource;
  final ForgotPasswordUsecase forgotPassword;

  AuthBloc({
    required this.signUpWithEmailPassword,
    required this.signInWithEmailPassword,
    required this.signInWithGoogle,
    required this.signOut,
    required this.getUidFromLocalDataSource,
    required this.forgotPassword,

  }) : super(AuthInitial()) {
    on<SignUpEvent>(_onSignUp);
    on<SignInEvent>(_onSignIn);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignOutEvent>(_onSignOut);
    on<GetCurrentUserIdFromLocalEvent>(_onGetCurrentUserIdFromLocal);
    on<ForgotPasswordEvent>(_forgotPassword);
  }


  Future<void> _onSignUp(
      SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signUpWithEmailPassword.call(event.authModel);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) {
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

    final result = await getUidFromLocalDataSource.call();
    result.fold(
      (failure){
        emit(AuthInitial());
      },
      (userId){ 
        final user = FirebaseAuth.instance.currentUser;

        emit(AuthSignedIn(user!));
      },
    );
  }

  Future<void> _forgotPassword(ForgotPasswordEvent event,Emitter<AuthState> emit) async{

    final result =  await forgotPassword.call(event.email);

    result.fold(
      (failure){
        print("failed while reseting password");
      },
      (userId){ 
        print("password reset success");
      },
    );


  }

}
