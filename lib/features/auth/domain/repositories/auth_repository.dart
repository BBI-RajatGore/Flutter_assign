
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/auth/domain/entities/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Future<Either<Failure,User?>> signUpWithEmailPassword(AuthModel authModel);
  Future<Either<Failure,User?>> signInWithEmailPassword(AuthModel authModel);
  Future<Either<Failure,User?>> signInWithGoogle();
  Future<Either<Failure,void>> signOut();
  Future<Either<Failure,String?>> getCurrentUserIdFromLocal();
}