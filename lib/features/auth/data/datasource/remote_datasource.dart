import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/features/auth/data/datasource/local_datasource.dart';
import 'package:ecommerce_app/features/auth/domain/entities/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, User?>> signUpWithEmailPassword(AuthModel authModel);
  Future<Either<Failure, User?>> signInWithEmailPassword(AuthModel authModel);
  Future<Either<Failure, User?>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleAuthProvider _googleAuthProvider;
  final AuthLocalDataSource _authLocalDataSource; 

  AuthRemoteDataSourceImpl(
    this._firebaseAuth,
    this._googleAuthProvider,
    this._authLocalDataSource, 
  );

  @override
  Future<Either<Failure, User?>> signUpWithEmailPassword(AuthModel authModel) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: authModel.email,
        password: authModel.password,
      );
      final user = userCredential.user;
      

      if (user != null) {
        await _authLocalDataSource.saveUserId(user.uid);
      }

      return Right(user);
    } catch (e) {
      return Left(Failure("Error signing up with email and password"));
    }
  }

  @override
  Future<Either<Failure, User?>> signInWithEmailPassword(AuthModel authModel) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: authModel.email,
        password: authModel.password,
      );
      final user = userCredential.user;
      

      if (user != null) {
        await _authLocalDataSource.saveUserId(user.uid);
      }

      return Right(user);
    } catch (e) {
      return Left(Failure("No user found with that email and password"));
    }
  }

  @override
  Future<Either<Failure, User?>> signInWithGoogle() async {
    try {
      var user = await _firebaseAuth.signInWithProvider(_googleAuthProvider);

      if (user == null) {
        return Left(Failure('Google sign-in aborted'));
      }

      if (user != null) {
        await _authLocalDataSource.saveUserId(_firebaseAuth.currentUser!.uid);
      }

      return Right(_firebaseAuth.currentUser!);

    } catch (e) {
      return Left(Failure("Error signing in with Google"));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
    
      await _authLocalDataSource.clearUserId();

      return Right(null);
    } catch (e) {
      return Left(Failure("Error signing out"));
    }
  }
}
