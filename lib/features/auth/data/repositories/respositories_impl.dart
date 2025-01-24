
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/auth/data/datasource/local_datasource.dart';
import 'package:ecommerce_app/features/auth/data/datasource/remote_datasource.dart';
import 'package:ecommerce_app/features/auth/domain/entities/auth_model.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl(this.authRemoteDataSource,this.authLocalDataSource);

  @override
  Future<Either<Failure, User?>> signUpWithEmailPassword(AuthModel authModel) async {
    return await authRemoteDataSource.signUpWithEmailPassword(authModel);
  }

  @override
  Future<Either<Failure, User?>> signInWithEmailPassword(AuthModel authModel) async {
    return await authRemoteDataSource.signInWithEmailPassword(authModel);
  }

  @override
  Future<Either<Failure, User?>> signInWithGoogle() async {
    return await authRemoteDataSource.signInWithGoogle();
  }

  @override
  Future<Either<Failure,void>> signOut() async {
    return await authRemoteDataSource.signOut();
  }

  @override
  Future<Either<Failure,String?>> getCurrentUserIdFromLocal() async {
    try{
      final userId = await authLocalDataSource.getUserId();
      if(userId == null){
        return Left(Failure("No user id found"),);
      }
      return Right(userId);
    }
    catch(e){
      return Left(Failure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> forgotPassword(String email) {
      return authRemoteDataSource.forgotPassword(email);
  }

}
