import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:task_manager/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:task_manager/features/auth/data/repository/auth_repository_impl.dart';



class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockSharedPreferencesHelper extends Mock implements SharedPreferencesHelper {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  late MockSharedPreferencesHelper mockSharedPreferencesHelper;


  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    mockSharedPreferencesHelper = MockSharedPreferencesHelper();
    repository = AuthRepositoryImpl(authRemoteDataSource: mockAuthRemoteDataSource,sharedPreferencesHelper: mockSharedPreferencesHelper);
  });


  group('createUser', () {
    test('should return Right with a token when createUser is successful', () async {
      const userId = 'user_1';
      when(() => mockAuthRemoteDataSource.createUser()).thenAnswer((_) async => const Right(userId));

      final result = await repository.createUser();

      expect(result.isRight(), true);
      result.fold(
        (left) => fail('Expected a successful result, but got a failure.'),
        (right) => expect(right, userId),
      );
      verify(() => mockAuthRemoteDataSource.createUser()).called(1);
    });

    test('should return Left with a Failure when createUser fails', () async {
      when(() => mockAuthRemoteDataSource.createUser()).thenAnswer((_) async => Left(Failure('Failed to create user')));

      final result = await repository.createUser();

      expect(result.isLeft(), true);
      result.fold(
        (left) => expect(left.message, 'Failed to create user'),
        (right) => fail('Expected a failure, but got a successful result.'),
      );
      verify(() => mockAuthRemoteDataSource.createUser()).called(1);
    });
  });


  group('loginUser', () {
    const userId = 'user_1';

    test('should return Right with a token when loginUser is successful', () async {
      const mockToken = 'user_1';
      when(() => mockAuthRemoteDataSource.loginUser(userId)).thenAnswer((_) async => Right(mockToken));

      final result = await repository.loginUser(userId);

      expect(result.isRight(), true);
      result.fold(
        (left) => fail('Expected a successful result, but got a failure.'),
        (right) => expect(right, mockToken),
      );
      verify(() => mockAuthRemoteDataSource.loginUser(userId)).called(1);
    });

    test('should return Left with a Failure when loginUser fails', () async {
      when(() => mockAuthRemoteDataSource.loginUser(userId)).thenAnswer((_) async => Left(Failure('Failed to login user')));

      final result = await repository.loginUser(userId);

      expect(result.isLeft(), true);
      result.fold(
        (left) => expect(left.message, 'Failed to login user'),
        (right) => fail('Expected a failure, but got a successful result.'),
      );
      verify(() => mockAuthRemoteDataSource.loginUser(userId)).called(1);
    });
  });


  group('getUserStatus', () {
    test('should return Right with userId when getUserStatus is successful', () async {
      const userId = 'user_1';
   
      when(() => mockSharedPreferencesHelper.getUserId()).thenAnswer((_) async => userId);

      final result = await repository.getUserStatus();

      expect(result.isRight(), true);
      result.fold(
        (left) => fail('Expected a successful result, but got a failure.'),
        (right) => expect(right, userId),
      );
      verify(() => mockSharedPreferencesHelper.getUserId()).called(1);
    });

    test('should return Left with a Failure when there is no user in shared preferences', () async {
      when(() => mockSharedPreferencesHelper.getUserId()).thenAnswer((_) async => null);

      final result = await repository.getUserStatus();

      expect(result.isLeft(), true);
      result.fold(
        (left) => expect(left.message, 'No user present in shared preference'),
        (right) => fail('Expected a failure, but got a successful result.'),
      );
      verify(() => mockSharedPreferencesHelper.getUserId()).called(1);
    });
  });

  group('logoutUser', () {
    test('should return Right with null when logoutUser is successful', () async {
      when(() => mockSharedPreferencesHelper.removeUserId()).thenAnswer((_) async => Future.value());

      final result = await repository.logoutUser();

      expect(result.isRight(), true);
      result.fold(
        (left) => fail('Expected a successful result, but got a failure.'),
        (_) => expect(null, null),
      );
      verify(() => mockSharedPreferencesHelper.removeUserId()).called(1);
    });

    test('should return Left with a Failure when logoutUser fails', () async {
      when(() => mockSharedPreferencesHelper.removeUserId()).thenThrow(Exception('Failed to remove user'));

      final result = await repository.logoutUser();

      expect(result.isLeft(), true);
      result.fold(
        (left) => expect(left.message, 'Failed to logout user'),
        (right) => fail('Expected a failure, but got a successful result.'),
      );
      verify(() => mockSharedPreferencesHelper.removeUserId()).called(1);
    });
  });
}
