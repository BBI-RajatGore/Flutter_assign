import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/auth/domain/usecase/create_user.dart';
import 'package:task_manager/features/auth/domain/usecase/get_user_status.dart';
import 'package:task_manager/features/auth/domain/usecase/login_user.dart';
import 'package:task_manager/features/auth/domain/usecase/logout_user.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CreateUser createUser;
  final LoginUser loginUser;
  final GetUserStatus getUserStatus;
  final LogoutUser logoutUser;

  AuthBloc(
      {required this.createUser,
      required this.loginUser,
      required this.getUserStatus,
      required this.logoutUser,
      })
      : super(AuthInitial()) {
    on<CreateUserEvent>(_onCreateUser);
    on<LoginUserEvent>(_onLoginUser);
    on<CheckUserStatusEvent>(_onCheckUserStatus);
    on<LogoutUserEvent>(_onLogoutUser);

  }


  Future<void> _onCheckUserStatus(
      CheckUserStatusEvent event, Emitter<AuthState> emit) async {
        emit(Loading());
    final result = await getUserStatus.call();

    result.fold(
      (l) => emit(
        AuthInitial(),
      ),
      (r) => emit(
        UserPresent(userId: r),
      ),
    );
  }

  Future<void> _onCreateUser(
      CreateUserEvent event, Emitter<AuthState> emit) async {
    emit(Loading());
    final result = await createUser.call();
    result.fold(
      (l) {
        emit(AuthError(message: l.message));
      },
      (r) {
        emit(UserLoggedIn(userId: r));
      },
    );
  }

  Future<void> _onLoginUser(
      LoginUserEvent event, Emitter<AuthState> emit) async {
        emit(Loading());
    final result = await loginUser.call(event.userId);
    result.fold(
      (l) {
        emit(AuthError(message: l.message));
      },
      (r) {
        emit(UserLoggedIn(userId: r));
      },
    );
  }

  Future<void> _onLogoutUser(LogoutUserEvent event,Emitter<AuthState> emit)async{

    emit(Loading());

    await logoutUser.call();

    emit(UserLoggedOut());
  }
}
