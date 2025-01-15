
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetUidFromLocalDataSource {
  final AuthRepository authRepository;

  GetUidFromLocalDataSource(this.authRepository);

  Future<Either<Failure, String?>> call() async {
    return await authRepository.getCurrentUserIdFromLocal();
  }
}
