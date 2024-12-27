import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:task_manager/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<Either<Failure, String>> createUser() async {
    return await authRemoteDataSource.createUser();
  }

  @override
  Future<Either<Failure, String>> loginUser(String userId) async {
    return await authRemoteDataSource.loginUser(userId);
  }

  @override
  Future<Either<Failure, String>> getUserStatus() async {
    final userId = await SharedPreferencesHelper.getUserId();
    if (userId != null) {
      return Right(userId);
    } else {
      return Left(Failure("No user present in shared preference"));
    }
  }
  
  @override
  Future<Either<Failure, void>> logoutUser() async {
    try{
      await SharedPreferencesHelper.removeUserId();
      return const  Right(null);
    }
    catch(e){
      return Left(Failure("Failed to logout user"));
    }
  }

}
