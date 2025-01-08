import 'package:firebase_database/firebase_database.dart';
import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/core/utils/constant.dart';
import 'package:task_manager/features/auth/data/datasource/auth_local_data_source.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, String>> createUser();
  Future<Either<Failure, String>> loginUser(String userId);
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  
  final SharedPreferencesHelper sharedPreferencesHelper;
  final DatabaseReference userCounterRef;
  final DatabaseReference usersRef;

  AuthRemoteDataSourceImpl({required this.sharedPreferencesHelper,required this.userCounterRef,required this.usersRef});
  
  @override
  Future<Either<Failure, String>> createUser() async {
    try {
      final snapshot = await userCounterRef.get();
      print(snapshot);
      final currentUserId = snapshot.exists && snapshot.value != null
          ? (snapshot.value as int)
          : 0;
      print(currentUserId);

      final newUserId = 'user_${currentUserId + 1}';
      await userCounterRef.set(currentUserId + 1);
      

      await usersRef.child(newUserId).set({
        'userId': newUserId,
      });

      await sharedPreferencesHelper.saveUserId(newUserId);  

      return Right(newUserId);
    } catch (error) {
      return Left(Failure(AuthRemoteDataSourceConstant.failedUserCreationText));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(String userId) async {
    try {
      final snapshot = await usersRef.child(userId).get();

      if (snapshot.exists) {
        await sharedPreferencesHelper.saveUserId(userId);  
        return Right(userId); 
      } else {
        return Left(Failure(AuthRemoteDataSourceConstant.userNotRegiText));
      }
    } catch (error) {
      return Left(Failure(AuthRemoteDataSourceConstant.failedToLoginText));
    }
  }
}

