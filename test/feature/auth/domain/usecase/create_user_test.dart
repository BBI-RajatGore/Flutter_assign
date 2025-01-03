import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_manager/features/auth/domain/usecase/create_user.dart';


class MockAuthRepository extends Mock implements AuthRepository {}

void main() {

  late CreateUser usecase;
  late MockAuthRepository repository;


  setUp(() {
    repository = MockAuthRepository();
    usecase = CreateUser(authRepository: repository);
  });


  test('should return Right with user ID when createUser is successful', () async {

    const mockUserId = 'user_1';

    // Arrange
    when(() => repository.createUser()).thenAnswer((_) async => Right(mockUserId));

    // Act
    final result = await usecase.call();

    // Assert
    expect(result.isRight(), true); 

    result.fold(
      (left) => fail('Expected a successful result, but got a failure.'),
      (right) => expect(right, mockUserId), 
    );

    // Verify createUser was called once
    verify(() => repository.createUser()).called(1); 
  });


  test('should return Left with a Failure when createUser fails', () async {
    // Arrange
    when(() => repository.createUser()).thenAnswer((_) async => Left(Failure('failed')));

    // Act
    final result = await usecase.call();

    // Assert
    expect(result.isLeft(), true); 

    result.fold(
      (left) => expect(left.message, 'failed'), 
      (right) => fail('Expected a failure, but got a successful result.'),
    );

    verify(() => repository.createUser()).called(1);  
  });
}
