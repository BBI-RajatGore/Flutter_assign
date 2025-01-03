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
    
    const String testUserId = 'user_1';
    const String testTaskId = 'task_1';

    test('should return void when task is successfully deleted', () async {
      // Arrange
      when(() => mockTaskRepository.deleteTask(testUserId, testTaskId))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await deleteTask(testUserId, testTaskId);

      // Assert
      expect(result.isRight(), true);


      result.fold(
        (failure) => fail('Expected success but got failure'),
        (_) => expect(null, null), 
      );
      verify(() => mockTaskRepository.deleteTask(testUserId, testTaskId)).called(1);
    });

    test('should return Failure when task deletion fails', () async {
      // Arrange
      final failure = Failure();  
      when(() => mockTaskRepository.deleteTask(testUserId, testTaskId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await deleteTask(testUserId, testTaskId);

      // Assert
      expect(result.isLeft(), true);


      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
        },
        (success) => fail('Expected failure but got success'),
      );

      verify(() => mockTaskRepository.deleteTask(testUserId, testTaskId)).called(1);
    });
  });
}
