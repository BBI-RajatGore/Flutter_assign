import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_manager/features/auth/domain/usecase/create_user.dart';


// Mock the AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {

  late CreateUser usecase;
  late MockAuthRepository repository;

  // Set up the instances of the usecase and repository
  setUp(() {
    repository = MockAuthRepository();
    usecase = CreateUser(authRepository: repository);
  });

  // Test case for Right (success)
  test('should return Right with user ID when createUser is successful', () async {

    const mockUserId = 'user_1';

    // Arrange
    when(() => repository.createUser()).thenAnswer((_) async => Right(mockUserId));

    // Act
    final result = await usecase.call();

    // Assert
    expect(result.isRight(), true); // Check if it's Right

    result.fold(
      (left) => fail('Expected a successful result, but got a failure.'),
      (right) => expect(right, mockUserId), // Ensure the mock user ID is returned
    );

    // Verify createUser was called once
    verify(() => repository.createUser()).called(1);  // Ensure that the createUser method is called once
  });

  // Test case for Left (failure)
  test('should return Left with a Failure when createUser fails', () async {
    // Arrange
    when(() => repository.createUser()).thenAnswer((_) async => Left(Failure('failed')));

    // Act
    final result = await usecase.call();

    // Assert
    expect(result.isLeft(), true); // Check if it's Left

    result.fold(
      (left) => expect(left.message, 'failed'), // Ensure the failure message matches
      (right) => fail('Expected a failure, but got a successful result.'),
    );

    // Verify createUser was called once
    verify(() => repository.createUser()).called(1);  // Ensure that the createUser method is called once
  });
}
