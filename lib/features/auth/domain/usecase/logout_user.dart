
import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';

class LogoutUser {
  final AuthRepository authRepository;
  LogoutUser({required this.authRepository});

  Future<Either<Failure, void>> call() async {
    return await authRepository.logoutUser();
  }

}