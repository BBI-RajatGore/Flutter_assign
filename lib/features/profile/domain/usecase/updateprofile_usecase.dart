import 'package:ecommerce_app/features/profile/domain/entities/profile_model.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/profile/domain/repositories/profile_repositories.dart';
import 'package:fpdart/fpdart.dart';

class UpdateprofileUsecase{

  final ProfileRepository profileRepository;

  UpdateprofileUsecase(this.profileRepository);

  Future<Either<Failure, void>> call(ProfileModel profileModel, String userId) async {
    return await profileRepository.updateProfile(profileModel, userId);
  }
}