import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/task/data/datasource/remote_data_source.dart';
import 'package:task_manager/features/task/data/reposotory/repository_impl.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';
import 'package:task_manager/features/task/domain/entities/priority.dart';

// Mock RemoteDataSource
class MockRemoteDataSource extends Mock implements RemoteDataSource {}

void main() {
  late MockRemoteDataSource mockRemoteDataSource;
  late RepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = RepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final UserTask testTask = UserTask(
    id: 'task_1',
    title: 'Test Task',
    description: 'This is a test task.',
    dueDate: DateTime.now(),
    priority: Priority.high,
  );
  
  final String testUserId = 'user_1';
  final String testTaskId = 'task_1';

  group('RepositoryImpl', () {
    test('should delegate addTask to RemoteDataSource and return success', () async {
      // Arrange
      when(() => mockRemoteDataSource.addTask(testTask, testUserId))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await repository.addTask(testTask, testUserId);

      // Assert
      expect(result.isRight(), true);  // Should be a success (Right)
      verify(() => mockRemoteDataSource.addTask(testTask, testUserId)).called(1);
    });

    test('should delegate addTask to RemoteDataSource and return failure', () async {
      // Arrange
      final failure = Failure();
      when(() => mockRemoteDataSource.addTask(testTask, testUserId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await repository.addTask(testTask, testUserId);

      // Assert
      expect(result.isLeft(), true);  // Should be a failure (Left)
      verify(() => mockRemoteDataSource.addTask(testTask, testUserId)).called(1);
    });

    test('should delegate deleteTask to RemoteDataSource and return success', () async {
      // Arrange
      when(() => mockRemoteDataSource.deleteTask(testUserId, testTaskId))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await repository.deleteTask(testUserId, testTaskId);

      // Assert
      expect(result.isRight(), true);  // Should be a success (Right)
      verify(() => mockRemoteDataSource.deleteTask(testUserId, testTaskId)).called(1);
    });

    test('should delegate deleteTask to RemoteDataSource and return failure', () async {
      // Arrange
      final failure = Failure();
      when(() => mockRemoteDataSource.deleteTask(testUserId, testTaskId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await repository.deleteTask(testUserId, testTaskId);

      // Assert
      expect(result.isLeft(), true);  // Should be a failure (Left)
      verify(() => mockRemoteDataSource.deleteTask(testUserId, testTaskId)).called(1);
    });

    test('should delegate editTask to RemoteDataSource and return success', () async {
      // Arrange
      when(() => mockRemoteDataSource.editTask(testUserId, testTaskId, testTask))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await repository.editTask(testUserId, testTaskId, testTask);

      // Assert
      expect(result.isRight(), true);  // Should be a success (Right)
      verify(() => mockRemoteDataSource.editTask(testUserId, testTaskId, testTask)).called(1);
    });

    test('should delegate editTask to RemoteDataSource and return failure', () async {
      // Arrange
      final failure = Failure();
      when(() => mockRemoteDataSource.editTask(testUserId, testTaskId, testTask))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await repository.editTask(testUserId, testTaskId, testTask);

      // Assert
      expect(result.isLeft(), true);  // Should be a failure (Left)
      verify(() => mockRemoteDataSource.editTask(testUserId, testTaskId, testTask)).called(1);
    });

    test('should delegate fetchAllTasks to RemoteDataSource and return success', () async {
      // Arrange
      final taskList = [testTask];
      when(() => mockRemoteDataSource.fetchAllTasks(testUserId))
          .thenAnswer((_) async => Right(taskList));

      // Act
      final result = await repository.fetchAllTasks(testUserId);

      // Assert
      expect(result.isRight(), true);  // Should be a success (Right)
      result.fold(
        (failure) => fail('Expected success but got failure'),
        (tasks) {
          expect(tasks, taskList);  // Should return the correct list of tasks
        },
      );
      verify(() => mockRemoteDataSource.fetchAllTasks(testUserId)).called(1);
    });

    test('should delegate fetchAllTasks to RemoteDataSource and return failure', () async {
      // Arrange
      final failure = Failure();
      when(() => mockRemoteDataSource.fetchAllTasks(testUserId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await repository.fetchAllTasks(testUserId);

      // Assert
      expect(result.isLeft(), true);  // Should be a failure (Left)
      verify(() => mockRemoteDataSource.fetchAllTasks(testUserId)).called(1);
    });
  });
}
