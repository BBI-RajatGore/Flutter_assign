import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_state.dart';
import 'package:task_manager/features/auth/presentation/pages/create_user_screen.dart';
import 'package:task_manager/features/task/presentation/pages/task_screen.dart';
import 'package:task_manager/main.dart';

// Mocking the AuthBloc and its dependencies
class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  group('AuthStateWrapper Widget Tests', () {
    testWidgets('should show loading spinner when state is Loading', (tester) async {
      // Arrange
      when(() => mockAuthBloc.state).thenReturn(Loading());

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (context) => mockAuthBloc,
            child: AuthStateWrapper(),
          ),
        ),
      );

      // Assert: Check if the loading spinner is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
testWidgets('should navigate to TaskScreen when UserPresent state is emitted', (tester) async {
 

  // Act: Trigger the CheckUserStatusEvent to emit UserPresent
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<AuthBloc>(
        create: (context) => mockAuthBloc,
        child: CreateUserScreen(),
      ),
    ),
  );

  // Wait for state changes to complete
  // await tester.pumpAndSettle();  // Ensures all pending animations and navigation events are processed

  // Assert: Verify TaskScreen is displayed
  expect(find.text('Create User'), findsOneWidget); 
});






    testWidgets('should display error message when AuthError state is emitted', (tester) async {
      // Arrange
      when(() => mockAuthBloc.state).thenReturn(AuthError(message: 'Something went wrong'));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (context) => mockAuthBloc,
            child: AuthStateWrapper(),
          ),
        ),
      );

      // Assert: Check if the error message is displayed
      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('should show CreateUserScreen when AuthInitial state is emitted', (tester) async {
      // Arrange
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (context) => mockAuthBloc,
            child: AuthStateWrapper(),
          ),
        ),
      );

      // Assert: Check that CreateUserScreen is displayed
      expect(find.byType(CreateUserScreen), findsOneWidget);
    });
  });
}
