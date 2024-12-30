import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_manager/features/auth/domain/usecase/logout_user.dart';

// Mock the AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LogoutUser usecase;
  late MockAuthRepository repository;

  // Set up the instances of the usecase and repository
  setUp(() {
    repository = MockAuthRepository();
    usecase = LogoutUser(authRepository: repository);
  });

  // Test case for Right (success)
  test('should return Right with no value when logoutUser is successful', () async {
    // Arrange: Simulate a successful logout (no return value)
    when(() => repository.logoutUser()).thenAnswer((_) async => Right(null));

    // Act: Call the usecase
    final result = await usecase.call();

    // Assert: Check if the result is Right (success)
    expect(result.isRight(), true);

    result.fold(
      (left) => fail('Expected a successful result, but got a failure.'),
      (_) => expect(null, null), // Expecting `null` as there is no return value from the logout method
    );

    // Verify: Ensure logoutUser was called once
    verify(() => repository.logoutUser()).called(1);
  });

  // Test case for Left (failure)
  test('should return Left with a Failure when logoutUser fails', () async {
    // Arrange: Simulate a failure in logout
    when(() => repository.logoutUser()).thenAnswer((_) async => Left(Failure('Logout failed')));

    // Act: Call the usecase
    final result = await usecase.call();

    // Assert: Check if the result is Left (failure)
    expect(result.isLeft(), true);

    result.fold(
      (left) => expect(left.message, 'Logout failed'), // Ensure the failure message matches
      (right) => fail('Expected a failure, but got a successful result.'),
    );

    // Verify: Ensure logoutUser was called once
    verify(() => repository.logoutUser()).called(1);
  });
}
