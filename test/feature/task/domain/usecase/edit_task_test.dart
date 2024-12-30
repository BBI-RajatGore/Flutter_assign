import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/task/domain/entities/priority.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';
import 'package:task_manager/features/task/domain/usecases/edit_task.dart';

// Mock TaskRepository
class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockTaskRepository;
  late EditTask editTask;

  // Initialize mock repository and use case
  setUp(() {
    mockTaskRepository = MockTaskRepository();
    editTask = EditTask(taskRepository: mockTaskRepository);
  });

  group('EditTask use case', () {
    // Test data for userId, taskId and UserTask entity
    const String testUserId = 'user_1';
    const String testTaskId = 'task_1';
    final UserTask testTask = UserTask(
      id: testTaskId,
      title: 'Updated Task Title',
      description: 'This task has been updated.',
      dueDate: DateTime.now(),
      priority: Priority.medium,
    );

    test('should return void when task is successfully edited', () async {
      // Arrange: Mock the editTask response to return a success
      when(() => mockTaskRepository.editTask(testUserId, testTaskId, testTask))
          .thenAnswer((_) async => const Right(null));

      // Act: Call the editTask use case
      final result = await editTask(testUserId, testTaskId, testTask);

      // Assert: Ensure the result is a success (Right)
      expect(result.isRight(), true);

      // Verify that the editTask method was called exactly once with correct arguments
      result.fold(
        (failure) => fail('Expected success but got failure'),
        (_) => expect(null, null),  // Right<void> should return `null`
      );
      verify(() => mockTaskRepository.editTask(testUserId, testTaskId, testTask)).called(1);
    });

    test('should return Failure when task editing fails', () async {
      // Arrange: Mock a failure response when editing the task
      final failure = Failure();  // Example failure
      when(() => mockTaskRepository.editTask(testUserId, testTaskId, testTask))
          .thenAnswer((_) async => Left(failure));

      // Act: Call the editTask use case
      final result = await editTask(testUserId, testTaskId, testTask);

      // Assert: Ensure the result is a failure (Left)
      expect(result.isLeft(), true);

      // Verify that the failure type is correct
      result.fold(
        (failure) {
          expect(failure, isA<Failure>()); // Ensure the failure is of type `Failure`
        },
        (success) => fail('Expected failure but got success'),
      );

      // Verify that the editTask method was called exactly once with correct arguments
      verify(() => mockTaskRepository.editTask(testUserId, testTaskId, testTask)).called(1);
    });
  });
}
