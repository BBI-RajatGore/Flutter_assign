

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:task_manager/features/task/data/datasource/remote_data_source.dart';
import 'package:task_manager/features/task/domain/entities/priority.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';


class MockDatabaseReference extends Mock implements DatabaseReference {}

class MockDataSnapshot extends Mock implements DataSnapshot {}

void main() {
  late RemoteDataSourceImpl remoteDataSource;
  late MockDatabaseReference mockDatabaseReference;
  late MockDataSnapshot mockDataSnapshot;

  const testUserId = 'user_1';
  const testTaskId = '-OFLzZqmd35yPy2kU86i';

  final testTask = UserTask(
    id: testTaskId,
    title: 'Test Task',
    description: 'Test task description',
    dueDate: DateTime.now(),
    priority: Priority.high,
  );

  setUp(() {
    mockDataSnapshot = MockDataSnapshot();
    mockDatabaseReference = MockDatabaseReference();
    remoteDataSource = RemoteDataSourceImpl(taskRef: mockDatabaseReference);
  });

  group('RemoteDataSourceImpl', () {
    test('should add a task successfully', () async {
      // Arrange
      final taskRef = MockDatabaseReference();
      when(() => mockDatabaseReference.child(testUserId)).thenReturn(taskRef);
      final taskRefe = MockDatabaseReference();
      when(() => taskRef.push()).thenReturn(taskRefe);
      when(() => taskRefe.set(any())).thenAnswer((_) async => null);

      // Act
      final result = await remoteDataSource.addTask(testTask, testUserId);

      // Assert
      expect(result.isRight(), true);  // Should be a success (Right)
      verify(() => taskRefe.set(any())).called(1);
    });

    test('should return failure when adding task fails', () async {
      // Arrange
      when(() => mockDatabaseReference.child(testUserId)).thenReturn(MockDatabaseReference());
      when(() => mockDatabaseReference.child(testUserId).push()).thenThrow(Exception("Failed to add task"));

      // Act
      final result = await remoteDataSource.addTask(testTask, testUserId);

      // Assert
      expect(result.isLeft(), true);  // Should be a failure (Left)
      result.fold(
        (failure) => expect(failure.message, "Failed to add task"),
        (success) => fail('Expected failure but got success'),
      );
    });

    test('should delete a task successfully', () async {
      // Arrange
      final taskRef = MockDatabaseReference();
      when(() => mockDatabaseReference.child(testUserId)).thenAnswer((_)=> taskRef);
      // when(() => taskRef.exists).thenReturn(true);  // Simulate that task exists
      // when(() => taskRef.child(testUserId))
      //     .thenAnswer((_)=>taskRef);

      // when(() => taskRef.get())
      //     .thenAnswer((_) async =>mockDataSnapshot);

      

      

      // Act
      final result = await remoteDataSource.deleteTask(testUserId, testTaskId);

      // Assert
      expect(result.isRight(), true);  // Should be a success (Right)
      verify(() => mockDatabaseReference.child(testUserId).child(testTaskId).remove()).called(1);
    });

    test('should return failure when deleting task fails', () async {
      // Arrange
      when(() => mockDatabaseReference.child(testUserId).child(testTaskId).get())
          .thenThrow(Exception('Failed to get task'));
      
      // Act
      final result = await remoteDataSource.deleteTask(testUserId, testTaskId);

      // Assert
      expect(result.isLeft(), true);  // Should be a failure (Left)
      result.fold(
        (failure) => expect(failure.message, 'Failed to delete task: Exception: Failed to get task'),
        (success) => fail('Expected failure but got success'),
      );
    });

    test('should edit a task successfully', () async {
      // Arrange
      final taskSnapshot = MockDataSnapshot();
      when(() => mockDatabaseReference.child(testUserId).child(testTaskId).get())
          .thenAnswer((_) async => taskSnapshot);
      when(() => taskSnapshot.exists).thenReturn(true);  // Simulate that task exists
      when(() => mockDatabaseReference.child(testUserId).child(testTaskId).update(any()))
          .thenAnswer((_) async => null);

      // Act
      final result = await remoteDataSource.editTask(testUserId, testTaskId, testTask);

      // Assert
      expect(result.isRight(), true);  // Should be a success (Right)
      verify(() => mockDatabaseReference.child(testUserId).child(testTaskId).update(any())).called(1);
    });

    test('should return failure when editing task fails', () async {
      // Arrange
      when(() => mockDatabaseReference.child(testUserId).child(testTaskId).get())
          .thenThrow(Exception('Failed to get task'));
      
      // Act
      final result = await remoteDataSource.editTask(testUserId, testTaskId, testTask);

      // Assert
      expect(result.isLeft(), true);  // Should be a failure (Left)
      result.fold(
        (failure) => expect(failure.message, 'Failed to edit task: Exception: Failed to get task'),
        (success) => fail('Expected failure but got success'),
      );
    });

    test('should fetch all tasks successfully', () async {
      // Arrange
      final snapshot = MockDataSnapshot();
      when(() => mockDatabaseReference.child(testUserId).get()).thenAnswer((_) async => snapshot);
      when(() => snapshot.exists).thenReturn(true);
      when(() => snapshot.value).thenReturn({
        '-OFLzZqmd35yPy2kU86i': {
          'description': 'task5 desc',
          'dueDate': '2024-12-30T15:25:38.096406',
          'priority': 'high',
          'title': 'task5',
        },
        '-OFMGSGuMb6Td5j151e1': {
          'description': 'task1 desc',
          'dueDate': '2024-12-30T00:00:00.000',
          'priority': 'medium',
          'title': 'task1',
        },
      });

      // Act
      final result = await remoteDataSource.fetchAllTasks(testUserId);

      // Assert
      expect(result.isRight(), true);  // Should be a success (Right)
      result.fold(
        (failure) => fail('Expected success but got failure'),
        (tasks) {
          expect(tasks.length, 2);  // Should return two tasks
          expect(tasks[0].title, 'task5');
          expect(tasks[1].title, 'task1');
        },
      );
      verify(() => mockDatabaseReference.child(testUserId).get()).called(1);
    });

    test('should return failure when fetching tasks fails', () async {
      // Arrange
      when(() => mockDatabaseReference.child(testUserId).get())
          .thenThrow(Exception('Failed to load tasks'));

      // Act
      final result = await remoteDataSource.fetchAllTasks(testUserId);

      // Assert
      expect(result.isLeft(), true);  // Should be a failure (Left)
      result.fold(
        (failure) => expect(failure.message, 'Failed to load tasks'),
        (success) => fail('Expected failure but got success'),
      );
    });
  });
}
