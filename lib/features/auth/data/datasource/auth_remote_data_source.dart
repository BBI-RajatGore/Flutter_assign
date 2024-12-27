

import 'package:firebase_database/firebase_database.dart';
import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/auth/data/datasource/auth_local_data_source.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, String>> createUser();
  Future<Either<Failure, String>> loginUser(String userId);
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  
  final DatabaseReference _userCounterRef = FirebaseDatabase.instance.ref('user_count');
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');

  @override
  Future<Either<Failure, String>> createUser() async {
    try {
      final snapshot = await _userCounterRef.get();
      final currentUserId = snapshot.exists && snapshot.value != null
          ? (snapshot.value as int)
          : 0;

      final newUserId = 'user_${currentUserId + 1}';
      await _userCounterRef.set(currentUserId + 1);
      

      await _usersRef.child(newUserId).set({
        'userId': newUserId,
      });

      await SharedPreferencesHelper.saveUserId(newUserId);  

      return Right(newUserId);
    } catch (error) {
      return Left(Failure('Failed to create user: $error'));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(String userId) async {
    try {
      final snapshot = await _usersRef.child(userId).get();

      if (snapshot.exists) {
        await SharedPreferencesHelper.saveUserId(userId);  
        return Right(userId); 
      } else {
        return Left(Failure('User not registered'));
      }
    } catch (error) {
      return Left(Failure('Failed to login: $error'));
    }
  }
}
