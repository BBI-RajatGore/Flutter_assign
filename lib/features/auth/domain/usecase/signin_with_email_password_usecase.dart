import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/auth/domain/entities/auth_model.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInWithEmailPassword {
  final AuthRepository authRepository;

  SignInWithEmailPassword(this.authRepository);

  Future<Either<Failure, User?>> call(AuthModel authModel) async {
    return await authRepository.signInWithEmailPassword(authModel);
  }
}
