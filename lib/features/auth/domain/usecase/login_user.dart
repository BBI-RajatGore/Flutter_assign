import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository authRepository;

  LoginUser({required this.authRepository});


  Future<Either<Failure, String>> call(String userId) async {
    return await authRepository.loginUser(userId);
  }
}
