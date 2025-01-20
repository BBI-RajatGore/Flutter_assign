
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/profile/domain/entities/profile_model.dart';import 'package:ecommerce_app/features/profile/domain/repositories/profile_repositories.dart';
import 'package:fpdart/fpdart.dart';

class GetprofileUsecase{
  
  final ProfileRepository profileRepository;

  GetprofileUsecase(this.profileRepository);

  Future<Either<Failure, ProfileModel>> call(String userId) async {
    return await profileRepository.getProfile(userId);
  }

}
      