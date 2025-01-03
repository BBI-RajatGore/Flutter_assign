import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/core/error/failure.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_manager/features/auth/domain/usecase/logout_user.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LogoutUser usecase;
  late MockAuthRepository repository;


  setUp(() {
    repository = MockAuthRepository();
    usecase = LogoutUser(authRepository: repository);
  });

  test('should return Right with no value when logoutUser is successful', () async {
   
    when(() => repository.logoutUser()).thenAnswer((_) async => Right(null));

    
    final result = await usecase.call();


    expect(result.isRight(), true);

    result.fold(
      (left) => fail('Expected a successful result, but got a failure.'),
      (_) => expect(null, null),
    );

    
    verify(() => repository.logoutUser()).called(1);
  });

  
  test('should return Left with a Failure when logoutUser fails', () async {
 
    when(() => repository.logoutUser()).thenAnswer((_) async => Left(Failure('Logout failed')));

    final result = await usecase.call();

    expect(result.isLeft(), true);

    result.fold(
      (left) => expect(left.message, 'Logout failed'), 
      (right) => fail('Expected a failure, but got a successful result.'),
    );


    verify(() => repository.logoutUser()).called(1);
  });
}
