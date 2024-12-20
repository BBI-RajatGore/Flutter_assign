import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app_clean_archi/core/theme/theme_manager.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {

  late ThemeManager themeManager;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    themeManager = ThemeManager(sharedPreferences: mockSharedPreferences);
  });

  group('ThemeManager Tests', () {
    test('should save the theme to SharedPreferences when saveTheme is called', () async {
      // Arrange: Mock the SharedPreferences behavior
      when(() => mockSharedPreferences.setBool(any(), any())).thenAnswer((_) async => true);

      // Act: Call saveTheme to save a theme
      await themeManager.saveTheme(true);

      // Assert: Verify that setBool was called with the correct key and value
      verify(() => mockSharedPreferences.setBool('theme', true)).called(1);
      
    });

    test('should return false when getTheme is called and SharedPreferences has no theme', () async {
      // Arrange: Mock the SharedPreferences behavior
      when(() => mockSharedPreferences.getBool('theme')).thenReturn(null);

      // Act: Call getTheme to retrieve the theme
      final result = await themeManager.getTheme();

      // Assert: Ensure that the default theme value (false) is returned
      expect(result, false);
    });

    test('should return true when getTheme is called and SharedPreferences has a true value for theme', () async {
      // Arrange: Mock the SharedPreferences behavior
      when(() => mockSharedPreferences.getBool('theme')).thenReturn(true);

      // Act: Call getTheme to retrieve the theme
      final result = await themeManager.getTheme();

      // Assert: Ensure that the theme value is true
      expect(result, true);
    });

    test('should return false when getTheme is called and SharedPreferences has a false value for theme', () async {
      // Arrange: Mock the SharedPreferences behavior
      when(() => mockSharedPreferences.getBool('theme')).thenReturn(false);

      // Act: Call getTheme to retrieve the theme
      final result = await themeManager.getTheme();

      // Assert: Ensure that the theme value is false
      expect(result, false);
    });
  });
}
