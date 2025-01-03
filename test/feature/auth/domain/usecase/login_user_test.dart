import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_manager/features/auth/domain/usecase/login_user.dart';


class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUser usecase;
  late MockAuthRepository repository;


  setUp(() {
    repository = MockAuthRepository();
    usecase = LoginUser(authRepository: repository);
  });

  test('should return Right with a token when loginUser is successful', () async {
    const userId = 'user_1';


    when(() => repository.loginUser(userId)).thenAnswer((_) async => Right(userId));

    final result = await usecase.call(userId);

 
    expect(result.isRight(), true);

    result.fold(
      (left) => fail('Expected a successful result, but got a failure.'),
      (right) => expect(right, userId), 
    );

   
    verify(() => repository.loginUser(userId)).called(1);
  });


  test('should return Left with a Failure when loginUser fails', () async {
    const userId = 'user_1';


    when(() => repository.loginUser(userId)).thenAnswer((_) async => Left(Failure('Login failed')));


    final result = await usecase.call(userId);


    expect(result.isLeft(), true);

    result.fold(
      (left) => expect(left.message, 'Login failed'),
      (right) => fail('Expected a failure, but got a successful result.'),
    );


    verify(() => repository.loginUser(userId)).called(1);
  });
}
