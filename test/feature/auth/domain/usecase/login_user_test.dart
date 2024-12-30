import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_manager/features/auth/domain/usecase/login_user.dart';

// Mock the AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUser usecase;
  late MockAuthRepository repository;

  // Set up the instances of the usecase and repository
  setUp(() {
    repository = MockAuthRepository();
    usecase = LoginUser(authRepository: repository);
  });

  // Test case for Right (success)
  test('should return Right with a token when loginUser is successful', () async {
    const userId = 'user_1';

    // Arrange: Simulate a successful login
    when(() => repository.loginUser(userId)).thenAnswer((_) async => Right(userId));

    // Act: Call the usecase
    final result = await usecase.call(userId);

    // Assert: Check if the result is Right (success)
    expect(result.isRight(), true);

    result.fold(
      (left) => fail('Expected a successful result, but got a failure.'),
      (right) => expect(right, userId), // Ensure the mock token is returned
    );

    // Verify: Ensure loginUser was called once with the correct userId
    verify(() => repository.loginUser(userId)).called(1);
  });

  // Test case for Left (failure)
  test('should return Left with a Failure when loginUser fails', () async {
    const userId = 'user_1';

    // Arrange: Simulate a failure
    when(() => repository.loginUser(userId)).thenAnswer((_) async => Left(Failure('Login failed')));

    // Act: Call the usecase
    final result = await usecase.call(userId);

    // Assert: Check if the result is Left (failure)
    expect(result.isLeft(), true);

    result.fold(
      (left) => expect(left.message, 'Login failed'), // Ensure the failure message matches
      (right) => fail('Expected a failure, but got a successful result.'),
    );

    // Verify: Ensure loginUser was called once with the correct userId
    verify(() => repository.loginUser(userId)).called(1);
  });
}
