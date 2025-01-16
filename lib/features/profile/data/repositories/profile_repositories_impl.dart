import 'dart:io';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/profile/data/datasource/remote_data_source.dart';
import 'package:ecommerce_app/features/profile/domain/entities/profile_model.dart';
import 'package:ecommerce_app/features/profile/domain/repositories/profile_repositories.dart';
import 'package:fpdart/fpdart.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  
  final ProfileRemoteDataSource profileRemoteDataSource;
 
  ProfileRepositoryImpl({
    required this.profileRemoteDataSource,
  });

  @override
  Future<Either<Failure, ProfileModel>> getProfile(String userId) async {
    return await profileRemoteDataSource.getProfile(userId);
  }

  @override
  Future<Either<Failure, void>> updateProfile(ProfileModel profileModel, String userId) async {
    return await profileRemoteDataSource.updateProfile(profileModel, userId);
  }

  @override
  Future<Either<Failure, void>> saveProfile(ProfileModel profileModel, String userId) async {
    return await profileRemoteDataSource.saveProfile(profileModel, userId);
  }


  @override
  Future<Either<Failure, bool>> checkProfileStatus(String userId) async {
    return await profileRemoteDataSource.checkProfileStatus(userId);
  }
}
