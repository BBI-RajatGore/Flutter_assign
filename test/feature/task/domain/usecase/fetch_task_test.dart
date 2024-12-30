import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/task/domain/entities/priority.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';
import 'package:task_manager/features/task/domain/usecases/fetch_task.dart';

// Mock TaskRepository
class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockTaskRepository;
  late FetchTask fetchTask;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    fetchTask = FetchTask(taskRespository: mockTaskRepository);
  });

  group('FetchTask use case', () {
    final String testUserId = 'user_1';
    final List<UserTask> testUserTasks = [
      UserTask(
        id: 'task_1',
        title: 'Task 1',
        description: 'This is task 1.',
        dueDate: DateTime.now(),
        priority: Priority.high,
      ),
      UserTask(
        id: 'task_2',
        title: 'Task 2',
        description: 'This is task 2.',
        dueDate: DateTime.now(),
        priority: Priority.medium,
      ),
    ];

    test('should return list of tasks when fetching tasks is successful', () async {
      // Arrange: Mock fetchAllTasks to return a list of tasks
      when(() => mockTaskRepository.fetchAllTasks(testUserId))
          .thenAnswer((_) async => Right(testUserTasks));

      // Act: Call the FetchTask use case
      final result = await fetchTask(testUserId);

      // Assert: Check that the result is a success (Right)
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Expected success but got failure'),
        (tasks) {
          expect(tasks, equals(testUserTasks)); // Verify the list of tasks
        },
      );

      // Verify that fetchAllTasks was called with the correct userId
      verify(() => mockTaskRepository.fetchAllTasks(testUserId)).called(1);
    });

    test('should return Failure when fetching tasks fails', () async {
      // Arrange: Mock fetchAllTasks to return a failure
      final failure = Failure(); // Example of a failure
      when(() => mockTaskRepository.fetchAllTasks(testUserId))
          .thenAnswer((_) async => Left(failure));

      // Act: Call the FetchTask use case
      final result = await fetchTask(testUserId);

      // Assert: Check that the result is a failure (Left)
      expect(result.isLeft(), true);

      // Verify that the failure is of type Failure
      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
        },
        (tasks) => fail('Expected failure but got success'),
      );

      // Verify that fetchAllTasks was called with the correct userId
      verify(() => mockTaskRepository.fetchAllTasks(testUserId)).called(1);
    });
  });
}
