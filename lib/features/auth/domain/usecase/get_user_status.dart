

import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';

class GetUserStatus {
  AuthRepository authRepository;
  
  GetUserStatus({required this.authRepository});

  Future<Either<Failure, String>> call() async {
    return await authRepository.getUserStatus();
  }
  
}