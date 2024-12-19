// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:news_app_clean_archi/presentation/cubit/theme_cubit.dart';
// import 'package:news_app_clean_archi/core/theme/theme_manager.dart';

// // Mock class for ThemeManager
// class MockThemeManager extends Mock implements ThemeManager {}

// void main() {
//   late ThemeCubit themeCubit;
//   late MockThemeManager mockThemeManager;

//   setUp(() {
//     // Initialize the mock theme manager
//     mockThemeManager = MockThemeManager();

//     // Create the themeCubit instance with the mocked themeManager
//     themeCubit = ThemeCubit(themeManager: mockThemeManager);
//   });

//   test('initial state is false (light mode)', () {
//     // Verify that the initial state is light mode (false)
//     expect(themeCubit.state, equals(false));
//   });

//   blocTest<ThemeCubit, bool>(
//     'emits [true] when toggleTheme is called and current state is false',
//     build: () {
//       // Return light mode (false) initially
//       when(mockThemeManager.loadTheme()).thenAnswer((_) async => false); // Mock Future<bool> correctly
//       return themeCubit;
//     },
//     act: (cubit) async {
//       // Toggle theme (light mode -> dark mode)
//       await cubit.toggleTheme();
//     },
//     expect: () => [true],  // Expected state: dark mode (true)
//   );

//   blocTest<ThemeCubit, bool>(
//     'emits [false] when toggleTheme is called and current state is true',
//     build: () {
//       // Return dark mode (true) initially
//       when(mockThemeManager.loadTheme()).thenAnswer((_) async => true); // Mock Future<bool> correctly
//       return themeCubit;
//     },
//     act: (cubit) async {
//       // Toggle theme (dark mode -> light mode)
//       await cubit.toggleTheme();
//     },
//     expect: () => [false],  // Expected state: light mode (false)
//   );

//   blocTest<ThemeCubit, bool>(
//     'emits [true] when loadTheme is called and returns dark mode',
//     build: () {
//       // Mocking the loadTheme method to return dark mode (true)
//       when(mockThemeManager.loadTheme()).thenAnswer((_) async => true); // Mock Future<bool> correctly
//       return themeCubit;
//     },
//     act: (cubit) async {
//       await cubit.loadTheme();
//     },
//     expect: () => [true],  // Expects the state to be dark mode (true)
//   );

//   blocTest<ThemeCubit, bool>(
//     'emits [false] when loadTheme is called and returns light mode',
//     build: () {
//       // Mocking the loadTheme method to return light mode (false)
//       when(mockThemeManager.loadTheme()).thenAnswer((_) async => false); // Mock Future<bool> correctly
//       return themeCubit;
//     },
//     act: (cubit) async {
//       await cubit.loadTheme();
//     },
//     expect: () => [false],  // Expects the state to be light mode (false)
//   );
// }

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:news_app_clean_archi/presentation/cubit/theme_cubit.dart';
// import 'package:news_app_clean_archi/core/theme/theme_manager.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'mock_shared_preference.dart';

// void main() {
//   late ThemeCubit themeCubit;
//   late MockThemeManager mockThemeManager;

//   setUp(() {
//     mockThemeManager = MockThemeManager();
//     themeCubit = ThemeCubit(themeManager: mockThemeManager);
//   });

//   test('should load the theme on startup', () async {
//     // Mock the loadTheme to return true (dark mode)
//     when(mockThemeManager.loadTheme()).thenAnswer((_) async => true);

//     // Load the theme and assert the state
//     await themeCubit.loadTheme();
//     expect(themeCubit.state, equals(true));  // Should be dark mode
//   });

//   blocTest<ThemeCubit, bool>(
//     'emits [true] when toggleTheme is called and the current state is false',
//     build: () {
//       when(mockThemeManager.loadTheme()).thenAnswer((_) async => false);
//       return themeCubit;
//     },
//     act: (cubit) async {
//       await cubit.toggleTheme();  // This will toggle the theme to dark mode
//     },
//     expect: () => [true],  // Expects the state to be updated to true (dark mode)
//   );
// }
