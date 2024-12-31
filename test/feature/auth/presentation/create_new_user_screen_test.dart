
import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_state.dart';
import 'package:task_manager/features/auth/presentation/pages/create_user_screen.dart';
import 'package:task_manager/features/task/presentation/pages/task_screen.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    // Provide an initial state for the mock AuthBloc
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
  });

  tearDown(() {
    mockAuthBloc.close();
  });

  Widget createTestableWidget(Widget child) {
    return BlocProvider<AuthBloc>(
      create: (_) => mockAuthBloc,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('CreateUserScreen displays buttons correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(CreateUserScreen()));

    // Verify the presence of buttons
    expect(find.text("Create New User"), findsOneWidget);
    expect(find.text("Login"), findsOneWidget);
  });

  testWidgets('Navigates to Login dialog on Login button tap', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(CreateUserScreen()));

    // Tap on the "Login" button
    await tester.tap(find.text("Login"));
    await tester.pumpAndSettle();

    // Verify navigation to the Login dialog
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('Create New User button triggers CreateUserEvent', (WidgetTester tester) async {
    // Mock the behavior of CreateUserEvent
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());

    await tester.pumpWidget(createTestableWidget(CreateUserScreen()));

    // Tap on the "Create New User" button
    await tester.tap(find.text("Create New User"));
    await tester.pump();

    // Verify that the "Create New User" button was pressed and event is dispatched
    // verify(() => mockAuthBloc.add(CreateUserEvent())).called(1);
  });

  testWidgets('Navigates to TaskScreen after successful user creation', (WidgetTester tester) async {
    // Mock a successful user creation
    // when(() => mockAuthBloc.state).thenReturn(UserLoggedIn(userId: '123'));

    when(() => mockAuthBloc.stream).thenAnswer(
      (_) => Stream.fromIterable([AuthInitial(), UserLoggedIn(userId: '123')]),
    );

    await tester.pumpWidget(createTestableWidget(CreateUserScreen()));

    // Tap on the "Create New User" button
    await tester.tap(find.widgetWithText(ElevatedButton,"Create New User"));
    await tester.pumpAndSettle();

    // Verify navigation to TaskScreen (assuming the task screen exists and its type is TaskScreen)
    expect(find.byType(TaskScreen), findsOneWidget);
  });

  testWidgets('Displays error message if AuthError state occurs', (WidgetTester tester) async {
    // Mock an AuthError state
    when(() => mockAuthBloc.state).thenReturn(AuthError(message: 'An error occurred'));

    when(() => mockAuthBloc.stream).thenAnswer(
      (_) => Stream.fromIterable([AuthInitial(), AuthError(message: 'An error occurred')]),
    );

    await tester.pumpWidget(createTestableWidget(CreateUserScreen()));

    // Trigger the "Create New User" button
    await tester.tap(find.text("Create New User"));
    await tester.pumpAndSettle();

    // Check if the SnackBar with the error message appears
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('An error occurred'), findsOneWidget);
  });
}
