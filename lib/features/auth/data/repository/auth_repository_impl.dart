

import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository{
  AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});
  
  @override
  Future<Either<Failure, String>> createUser() async{
    return await authRemoteDataSource.createUser();
  }
}