import 'package:firebase_database/firebase_database.dart';
import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, String>> createUser();
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  
  final DatabaseReference _userCounterRef = FirebaseDatabase.instance.ref('user_count');

  @override
  Future<Either<Failure, String>> createUser() async {
    try {

      final snapshot = await _userCounterRef.get();

      final currentUserId = snapshot.exists && snapshot.value != null
          ? (snapshot.value as int)
          : 0;

      final newUserId = 'user_${currentUserId + 1}';

      await _userCounterRef.set(currentUserId + 1);

      return Right(newUserId);

    } catch (error) {
      return Left(Failure('Failed to create user: $error'));
    }
  }
}
