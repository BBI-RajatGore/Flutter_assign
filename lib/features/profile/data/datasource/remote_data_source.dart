
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/profile/domain/entities/profile_model.dart';
import 'package:fpdart/fpdart.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, ProfileModel>> getProfile(String userId);
  Future<Either<Failure, void>> updateProfile(ProfileModel profileModel, String userId);
  Future<Either<Failure, void>> saveProfile(ProfileModel profileModel, String userId);
  Future<Either<Failure, bool>> checkProfileStatus(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  
  final FirebaseFirestore _firebaseFirestore;

  ProfileRemoteDataSourceImpl(
    this._firebaseFirestore,
  );  


  @override
  Future<Either<Failure, ProfileModel>> getProfile(String userId) async {
    try {

      DocumentSnapshot snapshot = await _firebaseFirestore.collection('profiles').doc(userId).get();

      if (!snapshot.exists) {
        return Left(Failure('Profile not found'));
      }

      var profileData = snapshot.data() as Map<String, dynamic>;

      ProfileModel profile = ProfileModel(
        username: profileData['username'] ?? '',
        phoneNumber: profileData['phoneNumber'] ?? '',
        address: profileData['address'] ?? '',
        imageUrl: profileData['imageUrl'] ?? '',
      );

      return Right(profile);
    } catch (e) {
      return Left(Failure('Error fetching profile: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(ProfileModel profileModel, String userId) async {
    try {

      await _firebaseFirestore.collection('profiles').doc(userId).update({
        'username': profileModel.username,
        'phoneNumber': profileModel.phoneNumber,
        'address': profileModel.address,
        'imageUrl': profileModel.imageUrl,
      });

      return const Right(null); 

    } catch (e) {

      return Left(Failure('Error updating profile: ${e.toString()}'));
      
    }
  }

  @override
  Future<Either<Failure, void>> saveProfile(ProfileModel profileModel, String userId) async {
    try {

      await _firebaseFirestore.collection('profiles').doc(userId).set({
        'username': profileModel.username,
        'phoneNumber': profileModel.phoneNumber,
        'address': profileModel.address,
        'imageUrl': profileModel.imageUrl,
      });

      return const  Right(null);

    } catch (e) {

      return Left(Failure('Error saving profile: ${e.toString()}'));

    }
  }

  @override
  Future<Either<Failure, bool>> checkProfileStatus(String userId) async {
    try {
   
      DocumentSnapshot snapshot = await _firebaseFirestore.collection('profiles').doc(userId).get();

      if (!snapshot.exists) {
        return const Right(false);
      }

      var profileData = snapshot.data() as Map<String, dynamic>;


      if (profileData['username'] == "" || profileData['phoneNumber'] == "" || profileData['address'] == "") {
        return const Right(false);
      }

      return const  Right(true);
    } catch (e) {
      return Left(Failure('Error checking profile status: ${e.toString()}'));
    }
  }
  
}