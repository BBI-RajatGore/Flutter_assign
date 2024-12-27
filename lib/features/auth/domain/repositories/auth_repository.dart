
import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> createUser();
  Future<Either<Failure, String>> loginUser(String userId);
  Future<Either<Failure,String>> getUserStatus();
  Future<Either<Failure,void>> logoutUser();
}
