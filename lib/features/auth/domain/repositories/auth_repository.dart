import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> createUser();
}