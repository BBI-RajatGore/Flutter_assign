// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:news_app_clean_archi/core/theme/theme_manager.dart';
// import 'package:news_app_clean_archi/presentation/bloc/news_bloc.dart';
// import 'package:news_app_clean_archi/presentation/cubit/theme_cubit.dart';
// import 'package:news_app_clean_archi/presentation/pages/news_screen.dart';
// import 'package:news_app_clean_archi/service_locator.dart';

// class MockThemeCubit extends MockCubit<bool> implements ThemeCubit {}
// class MockNewsBloc extends MockBloc<NewsEvent, NewsState> implements NewsBloc {}

// void main() {
//   late ThemeCubit mockThemeCubit;
//   late NewsBloc mockNewsBloc;

//   setUpAll(() {
//     // Setup necessary test environment
//     initServiceLocator();

//     mockThemeCubit = MockThemeCubit();
//     mockNewsBloc = MockNewsBloc();

//     // Register mock instances
//     getIt.registerLazySingleton<ThemeCubit>(() => mockThemeCubit);
//     getIt.registerLazySingleton<NewsBloc>(() => mockNewsBloc);
//   });

//   group('NewsScreen', () {
//     testWidgets('should toggle theme when theme button is pressed', (WidgetTester tester) async {
//       // Arrange: mock the initial theme state
//       when(() => mockThemeCubit.state).thenReturn(false); // Light mode
//       when(() => mockThemeCubit.toggleTheme()).thenAnswer((_) async {});

//       // Act: Build the widget and ensure the button is present
//       await tester.pumpWidget(
//         MultiBlocProvider(
//           providers: [
//             BlocProvider<ThemeCubit>(create: (_) => mockThemeCubit),
//             BlocProvider<NewsBloc>(create: (_) => mockNewsBloc),
//           ],
//           child: MaterialApp(
//             home: NewsScreen(),
//           ),
//         ),
//       );

//       // Check if the theme button exists
//       expect(find.byIcon(Icons.nightlight_round), findsOneWidget);

//       // Act: Tap the theme button
//       await tester.tap(find.byIcon(Icons.nightlight_round)); // Toggle theme button
//       await tester.pump(); // Rebuild widget after the tap

//       // Assert: Verify that the theme toggle was triggered
//       verify(() => mockThemeCubit.toggleTheme()).called(1);
//     });

//     testWidgets('should show filter dialog when filter button is pressed', (WidgetTester tester) async {
//       // Act: Build the widget
//       await tester.pumpWidget(
//         MultiBlocProvider(
//           providers: [
//             BlocProvider<ThemeCubit>(create: (_) => mockThemeCubit),
//             BlocProvider<NewsBloc>(create: (_) => mockNewsBloc),
//           ],
//           child: MaterialApp(
//             home: NewsScreen(),
//           ),
//         ),
//       );

//       // Act: Tap the filter button
//       await tester.tap(find.byIcon(Icons.filter_list));
//       await tester.pump(); // Wait for the dialog to show up

//       // Assert: Verify that the filter dialog appears
//       expect(find.byType(AlertDialog), findsOneWidget);
//     });

//     testWidgets('should call fetch news when NewsScreen is loaded', (WidgetTester tester) async {
//       // Arrange: Set up the mock state and event for the NewsBloc
//       when(() => mockNewsBloc.state).thenReturn(NewsInitialState());
//       when(() => mockNewsBloc.add(any())).thenAnswer((_) async {});

//       // Act: Build the widget
//       await tester.pumpWidget(
//         MultiBlocProvider(
//           providers: [
//             BlocProvider<ThemeCubit>(create: (_) => mockThemeCubit),
//             BlocProvider<NewsBloc>(create: (_) => mockNewsBloc),
//           ],
//           child: MaterialApp(
//             home: NewsScreen(),
//           ),
//         ),
//       );
//       await tester.pump(); // Allow the widget to settle

//       // Assert: Verify that the FetchNewsEvent was called when the screen is loaded
//       verify(() => mockNewsBloc.add(FetchNewsEvent(
//         query: 'latest',
//         sortBy: 'publishedAt',
//         language: 'en',
//       ))).called(1);
//     });

//     // Uncomment and fix the scrolling test if required
//     // testWidgets('should show floating action button when scrolling', (WidgetTester tester) async {
//     //   // Arrange: Set the initial state
//     //   when(() => mockThemeCubit.state).thenReturn(false);
      
//     //   // Build the widget
//     //   await tester.pumpWidget(
//     //     MultiBlocProvider(
//     //       providers: [
//     //         BlocProvider<ThemeCubit>(create: (_) => mockThemeCubit),
//     //         BlocProvider<NewsBloc>(create: (_) => mockNewsBloc),
//     //       ],
//     //       child: MaterialApp(
//     //         home: NewsScreen(),
//     //       ),
//     //     ),
//     //   );

//     //   // Scroll down to simulate a scroll position where the FAB should be visible
//     //   final scrollable = find.byType(NewsScreen);
//     //   await tester.scroll(scrollable, const Offset(0, 300)); 
//     //   await tester.pump(); // Allow for scroll position change

//     //   // Assert: Verify that the FAB is visible
//     //   expect(find.byType(FloatingActionButton), findsOneWidget);

//     //   // Scroll back up and assert the FAB is no longer visible
//     //   await tester.scroll(scrollable, const Offset(0, -300));
//     //   await tester.pump();
//     //   expect(find.byType(FloatingActionButton), findsNothing);
//     // });
//   });
// }


import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_archi/presentation/cubit/theme_cubit.dart';
import 'package:news_app_clean_archi/presentation/bloc/news_bloc.dart'; // Assuming you have a NewsBloc
import 'package:news_app_clean_archi/presentation/pages/news_screen.dart'; // Assuming NewsScreen has the button

// Mock the ThemeCubit
class MockThemeCubit extends MockCubit<bool> implements ThemeCubit {}

// Mock NewsBloc if necessary
class MockNewsBloc extends MockBloc<NewsEvent, NewsState> implements NewsBloc {}

void main() {
  late ThemeCubit mockThemeCubit;
  late NewsBloc mockNewsBloc;

  setUp(() {
    mockThemeCubit = MockThemeCubit();
    mockNewsBloc = MockNewsBloc();
  });

  testWidgets('should toggle theme when theme button is pressed', (WidgetTester tester) async {
    // Mock the initial state to be light mode (false)
    when(() => mockThemeCubit.state).thenReturn(false);

    // Build the widget tree with MultiBlocProvider to include both ThemeCubit and NewsBloc
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: mockThemeCubit), // Provide the ThemeCubit
            BlocProvider.value(value: mockNewsBloc),   // Provide the NewsBloc
          ],
          child: NewsScreen(), // Assuming NewsScreen has the toggle button
        ),
      ),
    );

    // Verify the initial state (should be light mode) and that the icon is nightlight_round (representing light mode)
    expect(find.byIcon(Icons.nightlight_round), findsOneWidget);

    // Simulate a button press to toggle the theme
    await tester.tap(find.byIcon(Icons.nightlight_round));
    await tester.pumpAndSettle();

    // Verify that the toggleTheme method was called (assuming it exists in your ThemeCubit)
    verify(() => mockThemeCubit.toggleTheme()).called(1);

    // After the button is pressed, the theme should be toggled (i.e., the icon should change)
    expect(find.byIcon(Icons.wb_sunny), findsOneWidget); // Now expect the wb_sunny icon (dark mode)
  });
}
