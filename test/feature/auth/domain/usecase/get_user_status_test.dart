import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_manager/features/auth/domain/usecase/get_user_status.dart';


class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late GetUserStatus usecase;
  late MockAuthRepository repository;


  setUp(() {
    repository = MockAuthRepository();
    usecase = GetUserStatus(authRepository: repository);
  });


  test('should return Right with user status when getUserStatus is successful', () async {
    const mockStatus = 'user_1';

    // Arrange
    when(() => repository.getUserStatus()).thenAnswer((_) async => Right(mockStatus));

    // Act
    final result = await usecase.call();

    // Assert
    expect(result.isRight(), true); 

    result.fold(
      (left) => fail('Expected a successful result, but got a failure.'),
      (right) => expect(right, mockStatus), 
    );

    verify(() => repository.getUserStatus()).called(1);  
  });


  test('should return Left with a Failure when getUserStatus fails', () async {
    // Arrange
    when(() => repository.getUserStatus()).thenAnswer((_) async => Left(Failure('failed')));

    // Act
    final result = await usecase.call();

    // Assert
    expect(result.isLeft(), true); 

    result.fold(
      (left) => expect(left.message, 'failed'), 
      (right) => fail('Expected a failure, but got a successful result.'),
    );

    verify(() => repository.getUserStatus()).called(1);  
  });
}
