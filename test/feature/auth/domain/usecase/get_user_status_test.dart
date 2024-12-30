import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_manager/features/auth/domain/usecase/get_user_status.dart';

// Mock the AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late GetUserStatus usecase;
  late MockAuthRepository repository;

  // Set up the instances of the usecase and repository
  setUp(() {
    repository = MockAuthRepository();
    usecase = GetUserStatus(authRepository: repository);
  });

  // Test case for Right (success)
  test('should return Right with user status when getUserStatus is successful', () async {
    const mockStatus = 'user_1';

    // Arrange
    when(() => repository.getUserStatus()).thenAnswer((_) async => Right(mockStatus));

    // Act
    final result = await usecase.call();

    // Assert
    expect(result.isRight(), true); // Check if it's Right

    result.fold(
      (left) => fail('Expected a successful result, but got a failure.'),
      (right) => expect(right, mockStatus), // Ensure the mock status is returned
    );

    // Verify getUserStatus was called once
    verify(() => repository.getUserStatus()).called(1);  // Ensure that the getUserStatus method is called once
  });

  // Test case for Left (failure)
  test('should return Left with a Failure when getUserStatus fails', () async {
    // Arrange
    when(() => repository.getUserStatus()).thenAnswer((_) async => Left(Failure('failed')));

    // Act
    final result = await usecase.call();

    // Assert
    expect(result.isLeft(), true); // Check if it's Left

    result.fold(
      (left) => expect(left.message, 'failed'), // Ensure the failure message matches
      (right) => fail('Expected a failure, but got a successful result.'),
    );

    // Verify getUserStatus was called once
    verify(() => repository.getUserStatus()).called(1);  // Ensure that the getUserStatus method is called once
  });
}
