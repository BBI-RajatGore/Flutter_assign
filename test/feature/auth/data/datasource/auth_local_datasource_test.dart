import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/features/auth/data/datasource/auth_local_data_source.dart';


class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferencesHelper sharedPreferencesHelper;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    sharedPreferencesHelper = SharedPreferencesHelper(sharedPreferences: mockSharedPreferences);
  });

  group('SharedPreferencesHelper', () {
    
    test('should save userId', () async {

      when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) async => true);


      await sharedPreferencesHelper.saveUserId('user_1');

     
      verify(() => mockSharedPreferences.setString('userId', 'user_1')).called(1);
    });

    test('should get userId', () async {
      
      when(() => mockSharedPreferences.getString('userId')).thenReturn('user_1');

      final result = await sharedPreferencesHelper.getUserId();

      expect(result, 'user_1');
    });

    test('should return null when userId is not found', () async {

      when(() => mockSharedPreferences.getString('userId')).thenReturn(null);

      final result = await sharedPreferencesHelper.getUserId();

      expect(result, isNull);
    });


  });
}
