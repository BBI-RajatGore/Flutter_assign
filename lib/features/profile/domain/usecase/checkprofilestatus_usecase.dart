
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/profile/domain/repositories/profile_repositories.dart';
import 'package:fpdart/fpdart.dart';

class CheckprofilestatusUsecase{
  final ProfileRepository profileRepository;

  CheckprofilestatusUsecase(this.profileRepository);

  Future<Either<Failure, bool>> call(String userId) async {
    return await profileRepository.checkProfileStatus(userId);
  }
}
