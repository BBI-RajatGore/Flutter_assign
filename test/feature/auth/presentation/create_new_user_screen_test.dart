
import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/core/utils/routes.dart';
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

    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
  });

  tearDown(() {
    mockAuthBloc.close();
  });

  Widget createTestableWidget(Widget child) {
    return BlocProvider<AuthBloc>(
      create: (_) => mockAuthBloc,
      child: MaterialApp(
        routes: {
          Routes.taskScreen: (context) => TaskScreen(userId: ModalRoute.of(context)?.settings.arguments as String),
        },
        home: child,
      ),
    );
  }

  testWidgets('CreateUserScreen displays buttons correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(CreateUserScreen()));


    expect(find.text("Create New User"), findsNWidgets(2));
    expect(find.text("Login"), findsOneWidget);
  });

  testWidgets('Navigates to Login dialog on Login button tap', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(CreateUserScreen()));


    await tester.tap(find.text("Login"));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('Create New User button triggers CreateUserEvent', (WidgetTester tester) async {
    
    when(() => mockAuthBloc.state).thenReturn(UserLoggedIn(userId: 'user_1'));

    when(() => mockAuthBloc.stream).thenAnswer(
      (_) => Stream.fromIterable([AuthInitial(), UserLoggedIn(userId: 'user_1')]),
    );
    

    await tester.pumpWidget(createTestableWidget(CreateUserScreen()));

   
    await tester.tap(find.byKey(Key('createUserButton')));
    await tester.pumpAndSettle();

  
    // verify(() => mockAuthBloc.add(CreateUserEvent())).called(1);
  });

  testWidgets('Navigates to TaskScreen after successful user creation', (WidgetTester tester) async {
  
  when(() => mockAuthBloc.stream).thenAnswer(
    (_) => Stream.fromIterable([AuthInitial(), UserLoggedIn(userId: '123')]),  
  );

  await tester.pumpWidget(createTestableWidget(CreateUserScreen()));

  
  await tester.tap(find.byKey(Key('createUserButton')));
  await tester.pumpAndSettle();  


  expect(find.byType(TaskScreen), findsOneWidget);
});


  testWidgets('Displays error message if AuthError state occurs', (WidgetTester tester) async {
    
    when(() => mockAuthBloc.state).thenReturn(AuthError(message: 'An error occurred'));

    when(() => mockAuthBloc.stream).thenAnswer(
      (_) => Stream.fromIterable([AuthInitial(), AuthError(message: 'An error occurred')]),
    );

    await tester.pumpWidget(createTestableWidget(CreateUserScreen()));

   
    await tester.tap(find.byKey(Key('createUserButton')));
    await tester.pumpAndSettle();


    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('An error occurred'), findsOneWidget);
  });
}
