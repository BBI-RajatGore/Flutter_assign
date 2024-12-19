import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_app_clean_archi/core/theme/theme_manager.dart';

class MockThemeManager extends Mock implements ThemeManager {}

void main() {

  late MockThemeManager mockThemeManager;

  setUp(() {
    mockThemeManager = MockThemeManager();
  });

  test('should return the correct theme from loadTheme', () async {

    // Mocking loadTheme to return true (dark mode)
    when(mockThemeManager.loadTheme()).thenAnswer((_) async => true);

    // Simulate calling loadTheme
    final isDarkMode = await mockThemeManager.loadTheme();

    // Check if it returns true (dark mode)
    expect(isDarkMode, equals(true));

  });

  test('should save theme when saveTheme is called', () async {

    // Mocking saveTheme to return a completed Future
    when(mockThemeManager.saveTheme(false)).thenAnswer((_) async => Future.value());

    // Call the saveTheme method
    await mockThemeManager.saveTheme(true);  // Save dark mode

    // Verify if the saveTheme method was called with the correct parameter
    verify(mockThemeManager.saveTheme(true)).called(1);

  });

}

void setUp(Null Function() param0) {
  
}





