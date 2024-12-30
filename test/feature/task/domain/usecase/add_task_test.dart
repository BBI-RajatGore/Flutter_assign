import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/task/domain/entities/priority.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';
import 'package:task_manager/features/task/domain/usecases/add_task.dart';

// Mock TaskRepository
class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockTaskRepository;
  late AddTask addTask;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    addTask = AddTask(taskRespository: mockTaskRepository);
  });

  group('AddTask use case', () {
    final UserTask testTask = UserTask(
      id: 'task_1',
      title: 'Test Task',
      description: 'This is a test task.', 
      dueDate: DateTime.now(),
      priority: Priority.high,
    );
    
    final String testUserId = 'user_1';

    test('should return void when task is successfully added', () async {
      // Arrange
      when(() => mockTaskRepository.addTask(testTask, testUserId))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await addTask(testTask, testUserId);

      // Assert
      expect(result.isRight(), true);  // Check that the result is a success (Right)
      result.fold(
        (failure) => fail('Expected success but got failure'),
        (_) => expect(null, null),  // Right<void> so should be `unit`
      );
      verify(() => mockTaskRepository.addTask(testTask, testUserId)).called(1);
    });

    test('should return Failure when task addition fails', () async {
      // Arrange
      final failure = Failure();  // Example of a failure
      when(() => mockTaskRepository.addTask(testTask, testUserId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await addTask(testTask, testUserId);

      // Assert
      expect(result.isLeft(), true);  // Check that the result is a failure (Left)
      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
        },
        (success) => fail('Expected failure but got success'),
      );
      verify(() => mockTaskRepository.addTask(testTask, testUserId)).called(1);
    });
  });
}
