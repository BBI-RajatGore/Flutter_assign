import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';

class CreateUser {
  final AuthRepository authRepository;

  CreateUser({required this.authRepository});


  Future<Either<Failure, String>> call() async {
    return await authRepository.createUser();
  }
}
