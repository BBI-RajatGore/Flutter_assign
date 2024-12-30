import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/features/auth/data/datasource/auth_local_data_source.dart';

// Mock class for SharedPreferences
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
      // Arrange: Mock the setString method to return true
      when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) async => true);

      // Act: Call the method to save the userId
      await sharedPreferencesHelper.saveUserId('user_1');

      // Assert: Verify that the setString method was called with the correct parameters
      verify(() => mockSharedPreferences.setString('userId', 'user_1')).called(1);
    });

    test('should get userId', () async {
      // Arrange: Mock the getString method to return 'user_1'
      when(() => mockSharedPreferences.getString('userId')).thenReturn('user_1');

      // Act: Call the method to get the userId
      final result = await sharedPreferencesHelper.getUserId();

      // Assert: Verify that the correct userId is returned
      expect(result, 'user_1');
    });

    test('should return null when userId is not found', () async {
      // Arrange: Mock the getString method to return null
      when(() => mockSharedPreferences.getString('userId')).thenReturn(null);

      // Act: Call the method to get the userId
      final result = await sharedPreferencesHelper.getUserId();

      // Assert: Verify that the result is null
      expect(result, isNull);
    });

    test('should remove userId', () async {
      // Arrange: Mock the remove method to return true
      when(() => mockSharedPreferences.remove('userId')).thenAnswer((_) async => true);

      // Act: Call the method to remove the userId
      await sharedPreferencesHelper.removeUserId();

      // Assert: Verify that the remove method was called with the correct key
      verify(() => mockSharedPreferences.remove('userId')).called(1);
    });
  });
}
