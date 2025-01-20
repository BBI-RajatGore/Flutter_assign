
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class ForgotPasswordUsecase {
  final AuthRepository authRepository;

  ForgotPasswordUsecase(this.authRepository);

  Future<Either<Failure, void>> call(String email) async {
    return await authRepository.forgotPassword(email);
  }
}
