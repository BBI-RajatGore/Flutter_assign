import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_archi/core/theme/theme_manager.dart';
import 'package:news_app_clean_archi/presentation/cubit/theme_cubit.dart';

// Mock the ThemeManager class
class MockThemeManager extends Mock implements ThemeManager {}

void main() {
  late ThemeManager mockThemeManager;
  late ThemeCubit themeCubit;

  setUp(() {
    mockThemeManager = MockThemeManager();
    themeCubit = ThemeCubit(themeManager: mockThemeManager);

    // Register fallback values for methods of the mock
    when(() => mockThemeManager.getTheme()).thenAnswer((_) async => false); // Default to light mode
  });

  test('should emit false when theme is initially loaded and no saved theme exists', () async {
    // Arrange: Simulate that the theme is not saved and defaults to light mode (false)
    when(() => mockThemeManager.getTheme()).thenAnswer((_) async => false);

    // Act: Call loadTheme and verify the emitted state
    await themeCubit.loadTheme();

    // Assert: Ensure that the state is false (light mode)
    expect(themeCubit.state, false);

    // Verify that getTheme() was called once
    verify(() => mockThemeManager.getTheme()).called(1);

  });

  test('should emit true when theme is loaded and dark theme exists', () async {
    // Arrange: Simulate that the saved theme is dark mode (true)
    when(() => mockThemeManager.getTheme()).thenAnswer((_) async => true);

    // Act: Call loadTheme and verify the emitted state
    await themeCubit.loadTheme();

    // Assert: Ensure that the state is true (dark mode)
    expect(themeCubit.state, true);

    // Verify that getTheme() was called once
    verify(() => mockThemeManager.getTheme()).called(1);
  });

  test('should emit true when toggleTheme is called and current state is false', () async {
    // Arrange: Simulate that the initial theme is light mode (false)
    when(() => mockThemeManager.getTheme()).thenAnswer((_) async => false);
    await themeCubit.loadTheme(); // Load the initial theme

    // Mock saveTheme to return Future<void> (since saveTheme is a Future<void> method)
    when(() => mockThemeManager.saveTheme(true)).thenAnswer((_) async => Future.value(null));

    // Act: Call toggleTheme and verify the emitted state
    await themeCubit.toggleTheme();

    // Assert: Ensure that the state is now true (dark mode)
    expect(themeCubit.state, true);

    // Verify that saveTheme() was called with the new theme value
    verify(() => mockThemeManager.saveTheme(true)).called(1);
  });

  test('should emit false when toggleTheme is called and current state is true', () async {
    // Arrange: Simulate that the initial theme is dark mode (true)
    when(() => mockThemeManager.getTheme()).thenAnswer((_) async => true);

    await themeCubit.loadTheme(); // Load the initial theme

    // Mock saveTheme to return Future<void> (since saveTheme is a Future<void> method)
    when(() => mockThemeManager.saveTheme(false)).thenAnswer((_) async => Future.value(null));

    // Act: Call toggleTheme and verify the emitted state
    await themeCubit.toggleTheme();

    // Assert: Ensure that the state is now false (light mode)
    expect(themeCubit.state, false);

    // Verify that saveTheme() was called with the new theme value
    verify(() => mockThemeManager.saveTheme(false)).called(1);
  });

}