import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/auth/domain/entities/auth_model.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpWithEmailPassword {
  final AuthRepository authRepository;

  SignUpWithEmailPassword(this.authRepository);

  Future<Either<Failure, User?>> call(AuthModel authModel) async {
    return await authRepository.signUpWithEmailPassword(authModel);
  }
}
