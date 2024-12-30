import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';
import 'package:task_manager/features/task/domain/usecases/delete_task.dart';

// Mock TaskRepository
class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockTaskRepository;
  late DeleteTask deleteTask;

  // Initialize mock repository and use case
  setUp(() {
    mockTaskRepository = MockTaskRepository();
    deleteTask = DeleteTask(taskRepository: mockTaskRepository);
  });

  group('DeleteTask use case', () {
    // Test data for taskId and userId
    const String testUserId = 'user_1';
    const String testTaskId = 'task_1';

    test('should return void when task is successfully deleted', () async {
      // Arrange: Mock the successful task deletion response
      when(() => mockTaskRepository.deleteTask(testUserId, testTaskId))
          .thenAnswer((_) async => const Right(null));

      // Act: Call the deleteTask use case
      final result = await deleteTask(testUserId, testTaskId);

      // Assert: Ensure the result is a success (Right)
      expect(result.isRight(), true);

      // Verify that the deleteTask method was called exactly once
      result.fold(
        (failure) => fail('Expected success but got failure'),
        (_) => expect(null, null), // Right<void> so it should be `null`
      );
      verify(() => mockTaskRepository.deleteTask(testUserId, testTaskId)).called(1);
    });

    test('should return Failure when task deletion fails', () async {
      // Arrange: Mock a failure response when deleting the task
      final failure = Failure();  // Example of a failure (can be extended)
      when(() => mockTaskRepository.deleteTask(testUserId, testTaskId))
          .thenAnswer((_) async => Left(failure));

      // Act: Call the deleteTask use case
      final result = await deleteTask(testUserId, testTaskId);

      // Assert: Ensure the result is a failure (Left)
      expect(result.isLeft(), true);

      // Verify that the failure type is correct
      result.fold(
        (failure) {
          expect(failure, isA<Failure>()); // Check that the failure is of the correct type
        },
        (success) => fail('Expected failure but got success'),
      );

      // Verify that the deleteTask method was called exactly once
      verify(() => mockTaskRepository.deleteTask(testUserId, testTaskId)).called(1);
    });
  });
}
