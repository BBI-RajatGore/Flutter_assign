import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:task_manager/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:firebase_database/firebase_database.dart';


class MockSharedPreferencesHelper extends Mock implements SharedPreferencesHelper {}
class MockDatabaseReference extends Mock implements DatabaseReference {}
class MockDataSnapshot extends Mock implements DataSnapshot {}

void main() {
  late AuthRemoteDataSourceImpl authRemoteDataSource;
  late MockSharedPreferencesHelper mockSharedPreferencesHelper;
  late MockDatabaseReference mockUserCounterRef;
  late MockDatabaseReference mockUsersRef;
  late MockDataSnapshot mockDataSnapshot;

  setUp(() {
    mockSharedPreferencesHelper = MockSharedPreferencesHelper();
    mockUserCounterRef = MockDatabaseReference();
    mockUsersRef = MockDatabaseReference();
    mockDataSnapshot = MockDataSnapshot();

    authRemoteDataSource = AuthRemoteDataSourceImpl(
      sharedPreferencesHelper: mockSharedPreferencesHelper,
      userCounterRef: mockUserCounterRef,
      usersRef: mockUsersRef,
    );
  });

  group('createUser', () {
    test('should create a new user and return the userId', () async {
      // Arrange
      when(() => mockUserCounterRef.get()).thenAnswer((_) async => mockDataSnapshot);
      when(() => mockDataSnapshot.exists).thenReturn(true);  
      when(() => mockDataSnapshot.value).thenReturn(1);     
      final mockDatabaseReference = MockDatabaseReference();
      when(() => mockUsersRef.child('user_2')).thenReturn(mockDatabaseReference);
      when(() => mockDatabaseReference.set(any())).thenAnswer((_) async => Future.value());

      when(() => mockUserCounterRef.set(2)).thenAnswer((_) async => null); 
      when(() => mockSharedPreferencesHelper.saveUserId('user_2')).thenAnswer((_) async => true); 

      // Act
      final result = await authRemoteDataSource.createUser();

      // Assert
      expect(result.isRight(), true); 
      result.fold(
        (failure) => fail('Expected a user id, but got failure: ${failure.message}'),
        (userId) => expect(userId, 'user_2'),
      );
      verify(() => mockUserCounterRef.get()).called(1);
      verify(() => mockUserCounterRef.set(2)).called(1);
      verify(() => mockUsersRef.child('user_2').set({'userId': 'user_2'})).called(1);
      verify(() => mockSharedPreferencesHelper.saveUserId('user_2')).called(1);
    });

    test('should return failure if an error occurs during user creation', () async {
      // Arrange
      when(() => mockUserCounterRef.get()).thenThrow(Exception('Error')); 

      // Act
      final result = await authRemoteDataSource.createUser();

      // Assert
      expect(result.isLeft(), true); 

      result.fold(
        (failure) => expect(failure.message, 'Failed to create user: Exception: Error'),
        (userId) => fail('Expected failure, but got $userId'),
      );
    });
  });

  group('loginUser', () {
    test('should login the user successfully and save the userId', () async {

      // Arrange
      const testUserId = 'user_2';
      final mockDatabaseReference = MockDatabaseReference();
       when(() => mockUsersRef.child(testUserId)).thenReturn(mockDatabaseReference);
       when(() => mockDatabaseReference.get()).thenAnswer((_) async => mockDataSnapshot);
      when(() => mockDataSnapshot.exists).thenReturn(true); 
      when(() => mockSharedPreferencesHelper.saveUserId(testUserId)).thenAnswer((_) async => true);

      // Act
      final result = await authRemoteDataSource.loginUser(testUserId);

      // Assert
      expect(result.isRight(), true);  

      result.fold(
        (failure) => fail('Expected a userId, but got failure: ${failure.message}'),
        (userId) => expect(userId, testUserId),
      );
      verify(() => mockUsersRef.child(testUserId).get()).called(1);
      verify(() => mockSharedPreferencesHelper.saveUserId(testUserId)).called(1);
    });

    test('should return failure if user is not found', () async {
      // Arrange
      const testUserId = 'user_2';
      final mockDatabaseReference = MockDatabaseReference();
      when(()=>mockUsersRef.child(testUserId)).thenReturn(mockDatabaseReference);
      when(() => mockDatabaseReference.get()).thenAnswer((_) async => mockDataSnapshot);
      when(() => mockDataSnapshot.exists).thenReturn(false); 

      // Act
      final result = await authRemoteDataSource.loginUser(testUserId);

      // Assert
      expect(result.isLeft(), true);  
      result.fold(
        (failure) => expect(failure.message, "User not registered"),
        (userId) => fail('Expected failure, but got $userId'),
      );
    });

    test('should return failure if an error occurs during login', () async {
      // Arrange
      const testUserId = 'user_2';
      when(() => mockUsersRef.child(testUserId).get()).thenThrow(Exception("Error"));

      // Act
      final result = await authRemoteDataSource.loginUser(testUserId);

      // Assert
      expect(result.isLeft(), true);  
      result.fold(
        (failure) => expect(failure.message, "Failed to login: Exception: Error"),
        (userId) => fail('Expected failure, but got $userId'),
      );
    });
  });
}
