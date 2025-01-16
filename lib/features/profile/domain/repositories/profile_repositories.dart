import 'package:fpdart/fpdart.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/profile/domain/entities/profile_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileModel>> getProfile(String userId);
  Future<Either<Failure, void>> updateProfile(ProfileModel profileModel, String userId);
  Future<Either<Failure, void>> saveProfile(ProfileModel profileModel, String userId); //skip
  Future<Either<Failure,bool>> checkProfileStatus(String userId);
}
