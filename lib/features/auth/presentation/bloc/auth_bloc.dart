import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/auth/domain/usecase/create_user.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final CreateUser createUser;

  AuthBloc({
    required this.createUser,
  }) : super(AuthInitial()) {
    on<CreateUserEvent>(_onCreateUser);
  }

  Future<void> _onCreateUser(CreateUserEvent event, Emitter<AuthState> emit) async {
    final result = await createUser.call();
    result.fold(
      (l) => emit(AuthError(message: l.message)),
      (r) {
        print(r);
        emit(UserCreated(userId: r));
      },
    );
  }
}