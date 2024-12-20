import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_archi/presentation/bloc/news_bloc.dart';
import 'package:news_app_clean_archi/presentation/cubit/theme_cubit.dart';
import 'package:news_app_clean_archi/presentation/pages/news_screen.dart';
import 'package:news_app_clean_archi/service_locator.dart';

void main() {

  setUpAll(() async {
    await dotenv.load(fileName: ".env");
    initServiceLocator();
  });

  testWidgets("testing icon button ", (WidgetTester tester) async {
    
    // when(() => getIt.state).thenReturn(false); // Light mode
    // when(() => mockThemeCubit.toggleTheme()).thenAnswer((_) async {});

    await tester.pumpWidget(MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(
            create: (_) => getIt<ThemeCubit>(),
          ),
          BlocProvider<NewsBloc>(
            create: (_) => getIt<NewsBloc>(),
          ),
        ],
        child: NewsScreen(),
      ),
    ));

    

    final text = find.text('News App');

    expect(text, findsOneWidget);

    final icon = find.byIcon( Icons.nightlight_round);

    expect(icon, findsOneWidget);

    await tester.tap(icon);

    await tester.pumpAndSettle();


    final icon2 = find.byIcon(Icons.wb_sunny);

    expect(icon2, findsNothing );

  });
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:news_app_clean_archi/presentation/bloc/news_bloc.dart';
// import 'package:news_app_clean_archi/presentation/cubit/theme_cubit.dart';
// import 'package:news_app_clean_archi/presentation/pages/news_screen.dart';
// import 'package:news_app_clean_archi/service_locator.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// // Mock the ThemeCubit to simulate theme switching
// class MockThemeCubit extends Mock implements ThemeCubit {}

// class MockNewsBloc extends Mock implements NewsBloc {}

// void main() {

//   TestWidgetsFlutterBinding.ensureInitialized();

//   late MockThemeCubit mockThemeCubit;
//   late MockNewsBloc mockNewsBloc;

//   setUpAll(() async {

//     await dotenv.load(fileName: ".env");

//     // Initialize GetIt and register only if NewsBloc is not already registered
//     initServiceLocator();

//     mockThemeCubit = MockThemeCubit();
//     mockNewsBloc = MockNewsBloc();

//     // Register them only if they are not already registered
//     if (!getIt.isRegistered<NewsBloc>()) {
//       getIt.registerSingleton<NewsBloc>(mockNewsBloc);
//     }

//     if (!getIt.isRegistered<ThemeCubit>()) {
//       getIt.registerSingleton<ThemeCubit>(mockThemeCubit);
//     }

//   });

//   setUp(() {
//     // Reset mocks before each test
//     reset(mockThemeCubit);
//     reset(mockNewsBloc);
//   });

//   // Helper function to create the widget under test
//   Widget createWidgetUnderTest() {
//     return MaterialApp(
//       home: MultiBlocProvider(
//         providers: [
//           BlocProvider<ThemeCubit>(
//             create: (_) => mockThemeCubit,
//           ),
//           BlocProvider<NewsBloc>(
//             create: (_) => getIt<NewsBloc>(),
//           ),
//         ],
//         child: NewsScreen(),
//       ),
//     );
//   }

//   group('NewsScreen Tests', () {
//     testWidgets("theme icon button toggles the theme", (WidgetTester tester) async {

//       // Initially set the theme state to light mode (false)
//       when(() => mockThemeCubit.state).thenReturn(false);

//       // when(() => mockThemeCubit.stream).thenAnswer((_) => Stream.value(false));

//       // Build the widget under test
//       await tester.pumpWidget(createWidgetUnderTest());

//       // Find the theme toggle icon (nightlight_round for light mode)
//       final initialIcon = find.byIcon(Icons.nightlight_round);
//       expect(initialIcon, findsOneWidget);

//       // Simulate tapping the icon to toggle the theme
//       await tester.tap(initialIcon);
//       await tester.pumpAndSettle();  // Wait for UI to settle

//       // After the toggle, verify that the icon changes to wb_sunny (dark mode)
//       when(() => mockThemeCubit.state).thenReturn(true);
//       when(() => mockThemeCubit.stream).thenAnswer((_) => Stream.value(true));
      
//       await tester.pumpAndSettle(); // Wait for the widget tree to rebuild
//       final toggledIcon = find.byIcon(Icons.wb_sunny);
//       expect(toggledIcon, findsOneWidget);

//       // Now simulate toggling back to light mode
//       await tester.tap(toggledIcon);
//       await tester.pumpAndSettle();

//       // Verify the icon changes back to nightlight_round (light mode)
//       when(() => mockThemeCubit.state).thenReturn(false);
//       when(() => mockThemeCubit.stream).thenAnswer((_) => Stream.value(false));
//       await tester.pumpAndSettle();
//       final backToLightIcon = find.byIcon(Icons.nightlight_round);
//       expect(backToLightIcon, findsOneWidget);
//     });
    
//   });
// }




