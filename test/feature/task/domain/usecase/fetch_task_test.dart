import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/task/domain/entities/priority.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';
import 'package:task_manager/features/task/domain/usecases/fetch_task.dart';


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
      // Arrange
      when(() => mockTaskRepository.fetchAllTasks(testUserId))
          .thenAnswer((_) async => Right(testUserTasks));

      // Act
      final result = await fetchTask(testUserId);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Expected success but got failure'),
        (tasks) {
          expect(tasks, equals(testUserTasks)); 
        },
      );

 
      verify(() => mockTaskRepository.fetchAllTasks(testUserId)).called(1);
    });

    test('should return Failure when fetching tasks fails', () async {
      // Arrange
      final failure = Failure(); 
      when(() => mockTaskRepository.fetchAllTasks(testUserId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await fetchTask(testUserId);

      // Assert
      expect(result.isLeft(), true);


      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
        },
        (tasks) => fail('Expected failure but got success'),
      );

      verify(() => mockTaskRepository.fetchAllTasks(testUserId)).called(1);
    });
  });
}
