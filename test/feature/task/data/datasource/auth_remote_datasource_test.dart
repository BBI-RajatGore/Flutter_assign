

import 'dart:ffi';

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
      expect(result.isRight(), true);  
      verify(() => taskRefe.set(any())).called(1);
    });

    test('should return failure when adding task fails', () async {
      // Arrange
      when(() => mockDatabaseReference.child(testUserId)).thenReturn(MockDatabaseReference());
      when(() => mockDatabaseReference.child(testUserId).push()).thenThrow(Exception("Failed to add task"));

      // Act
      final result = await remoteDataSource.addTask(testTask, testUserId);

      // Assert
      expect(result.isLeft(), true); 
      result.fold(
        (failure) => expect(failure.message, "Failed to add task"),
        (success) => fail('Expected failure but got success'),
      );
    });

    test('should delete a task successfully', () async {
    // Arrange
     final taskRef = MockDatabaseReference();
      when(() => mockDatabaseReference.child(testUserId)).thenReturn(taskRef);
      when(()=>taskRef.child(testTaskId)).thenReturn(taskRef);
     when(() => taskRef.remove()).thenAnswer((_) async => null);  
    // Act
    final result = await remoteDataSource.deleteTask(testUserId, testTaskId);

    // Assert
    expect(result.isRight(), true); 
    verify(() => mockDatabaseReference.child(testUserId).child(testTaskId).remove()).called(1);
  });

    test('should return failure when deleting task fails', () async {

      //Arrange
      final taskRef = MockDatabaseReference();
      when(() => mockDatabaseReference.child(testUserId)).thenReturn(taskRef);
      when(()=>taskRef.child(testTaskId)).thenReturn(taskRef);
     when(() => taskRef.remove()).thenThrow(Exception('Failed to delete task'));  
     
      // Act
      final result = await remoteDataSource.deleteTask(testUserId, testTaskId);

      // Assert
      expect(result.isLeft(), true);  
      result.fold(
        (failure) => expect(failure.message, 'Failed to delete task: Exception: Failed to delete task'),
        (success) => fail('Expected failure but got success'),
      );
    });

    test('should edit a task successfully', () async {
      // Arrange
       final taskRef = MockDatabaseReference();
      when(() => mockDatabaseReference.child(testUserId)).thenReturn(taskRef);
      when(()=>taskRef.child(testTaskId)).thenReturn(taskRef);
     when(() => taskRef.update(any())).thenAnswer((_) async => null);  
      

      // Act
      final result = await remoteDataSource.editTask(testUserId, testTaskId, testTask);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockDatabaseReference.child(testUserId).child(testTaskId).update(any())).called(1);
    });

    test('should return failure when editing task fails', () async {
      // Arrange
      final taskRef = MockDatabaseReference();
      when(() => mockDatabaseReference.child(testUserId)).thenReturn(taskRef);
      when(()=>taskRef.child(testTaskId)).thenReturn(taskRef);
      when(() => taskRef.update(any())).thenThrow(Exception('Failed to update task'));  
     
      // Act
      final result = await remoteDataSource.editTask(testUserId, testTaskId, testTask);

      // Assert
      expect(result.isLeft(), true);  
      result.fold(
        (failure) => expect(failure.message, 'Failed to edit task: Exception: Failed to update task'),
        (success) => fail('Expected failure but got success'),
      );
    });

    test('should fetch all tasks successfully', () async {
      // Arrange
      final taskRef = MockDatabaseReference();
      when(() => mockDatabaseReference.child(testUserId)).thenReturn(taskRef);
      final snapshot = MockDataSnapshot();
      when(() => taskRef.get()).thenAnswer((_) async => snapshot);
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
      expect(result.isRight(), true); 
      result.fold(
        (failure) => fail('Expected success but got failure'),
        (tasks) {
          expect(tasks.length, 2);  
          expect(tasks[0].title, 'task5');
          expect(tasks[1].title, 'task1');
        },
      );
      verify(() => mockDatabaseReference.child(testUserId).get()).called(1);
    });
    test('should return failure when fetching tasks fails', () async {
      // Arrange
      final taskRef = MockDatabaseReference();
      when(() => mockDatabaseReference.child(testUserId)).thenReturn(taskRef);
      when(() => taskRef.get()).thenThrow(Exception('Failed to load tasks'));

      // Act
      final result = await remoteDataSource.fetchAllTasks(testUserId);

      // Assert
      expect(result.isLeft(), true);  
      result.fold(
        (failure) => expect(failure.message, 'Failed to load tasks: Exception: Failed to load tasks'),
        (success) => fail('Expected failure but got success'),
      );
    });

  });
}
