import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SignOut {
  final AuthRepository authRepository;

  SignOut(this.authRepository);

  Future<Either<Failure, void>> call() async {
    return await authRepository.signOut();
  }
}
