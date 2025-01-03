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
      // Arrange
      when(() => mockTaskRepository.editTask(testUserId, testTaskId, testTask))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await editTask(testUserId, testTaskId, testTask);

      // Assert
      expect(result.isRight(), true);


      result.fold(
        (failure) => fail('Expected success but got failure'),
        (_) => expect(null, null), 
      );
      verify(() => mockTaskRepository.editTask(testUserId, testTaskId, testTask)).called(1);
    });

    test('should return Failure when task editing fails', () async {
      // Arrange
      final failure = Failure();  
      when(() => mockTaskRepository.editTask(testUserId, testTaskId, testTask))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await editTask(testUserId, testTaskId, testTask);

      // Assert
      expect(result.isLeft(), true);


      result.fold(
        (failure) {
          expect(failure, isA<Failure>()); 
        },
        (success) => fail('Expected failure but got success'),
      );

    
      verify(() => mockTaskRepository.editTask(testUserId, testTaskId, testTask)).called(1);
    });
  });
}
