import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_state.dart';
import 'package:task_manager/features/auth/presentation/pages/create_user_screen.dart';
import 'package:task_manager/features/task/domain/entities/priority.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';
import 'package:task_manager/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager/features/task/presentation/bloc/task_event.dart';
import 'package:task_manager/features/task/presentation/bloc/task_state.dart';
import 'package:task_manager/features/task/presentation/pages/task_screen.dart';
import 'package:task_manager/features/task/presentation/pages/add_task_scree.dart';

// Mock classes
class MockTaskBloc extends MockBloc<TaskEvent, TaskState> implements TaskBloc {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockTaskBloc mockTaskBloc;
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockTaskBloc = MockTaskBloc();
    mockAuthBloc = MockAuthBloc();

    // Mock the initial state of the task bloc
    when(() => mockTaskBloc.state).thenReturn(TaskLoading());
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    when(() => mockTaskBloc.stream).thenAnswer((_) => Stream.value(TaskLoading()));
  });

  tearDown(() {
    mockTaskBloc.close();
    mockAuthBloc.close();
  });

  Widget createTestableWidget(Widget child) {
    return BlocProvider<AuthBloc>(
      create: (_) => mockAuthBloc,
      child: BlocProvider<TaskBloc>(
        create: (_) => mockTaskBloc,
        child: MaterialApp(
          home: child,
        ),
      ),
    );
  }

testWidgets('TaskScreen displays app bar and buttons correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(TaskScreen(userId: 'user123')));

    // Verify app bar title
    expect(find.text('Welcome user123'), findsOneWidget);

    // Verify logout button in app bar
    expect(find.byIcon(Icons.logout), findsOneWidget);

    // Verify dropdown buttons for priority and due date
    expect(find.text('Priority'), findsOneWidget);
    expect(find.text('Due Date'), findsOneWidget);
});

testWidgets('TaskScreen displays tasks correctly when loaded', (WidgetTester tester) async {
  // Mock TaskState as TaskLoaded with sample data
  when(() => mockTaskBloc.state).thenReturn(
    TaskLoaded(
      tasks: [
        UserTask(id: '1', title: 'Test Task 1', description: 'Description 1', dueDate: DateTime.now(), priority: Priority.high),    
        UserTask(id: '2', title: 'Test Task 2', description: 'Description 2', dueDate: DateTime.now(), priority: Priority.low),
      ],
    ),
  );

  await tester.pumpWidget(createTestableWidget(TaskScreen(userId: 'user123')));

  // Add debug logging to check the state changes in the test
  
  expect(find.text('Test Task 1'), findsOneWidget);
  expect(find.text('Test Task 2'), findsOneWidget);
});



  testWidgets('TaskScreen displays "No Task Added" when no tasks are available', (WidgetTester tester) async {
    // Mock TaskState as TaskLoaded with no tasks
    when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks: []));

    await tester.pumpWidget(createTestableWidget(TaskScreen(userId: 'user123')));

    // Verify "No Task Added" text
    expect(find.text('No Task Added'), findsOneWidget);
  });

  testWidgets('Create New Task button triggers navigation to AddTaskScreen', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(TaskScreen(userId: 'user123')));

    // Tap on the "Create New Task" button (FloatingActionButton)
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify navigation to AddTaskScreen
    expect(find.byType(AddTaskScreen), findsOneWidget);
  });

  testWidgets('Check floating action button is present ', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(TaskScreen(userId: 'user123')));

    expect(find.byType(FloatingActionButton), findsOneWidget);
  });


testWidgets('TaskScreen filters tasks based on priority', (WidgetTester tester) async {
  // Mock TaskState as TaskLoaded with sample tasks
  when(() => mockTaskBloc.state).thenReturn(
    TaskLoaded(
      tasks: [
        UserTask(
          id: '1',
          title: 'Test Task 1',
          description: 'Description 1',
          dueDate: DateTime.now(),
          priority: Priority.high,
        ),
        UserTask(
          id: '2',
          title: 'Test Task 2',
          description: 'Description 2',
          dueDate: DateTime.now(),
          priority: Priority.low,
        ),
      ],
    ),
  );

  // Ensure widget is built with mock data
  await tester.pumpWidget(createTestableWidget(TaskScreen(userId: 'user123')));

  // Wait for the widget tree to settle
  await tester.pumpAndSettle();

  // Verify that the tasks are displayed in the UI
  expect(find.text('Test Task 1'), findsOneWidget); // Make sure Test Task 1 is rendered
  expect(find.text('Test Task 2'), findsOneWidget); // Make sure Test Task 2 is rendered

  // Tap on the Priority dropdown and select "high"
  await tester.tap(find.text('Priority')); // Tap the priority dropdown
  await tester.pumpAndSettle(); // Wait for the dropdown to settle

  // Select "high" priority
  await tester.tap(find.text('high').last); // Selecting "high" from the dropdown
  await tester.pumpAndSettle(); // Wait for the state to update

  // Verify that only tasks with high priority are displayed
  expect(find.text('Test Task 1'), findsOneWidget);
  expect(find.text('Test Task 2'), findsNothing); // The low priority task should not be displayed

});


testWidgets('Logout button logs out the user', (WidgetTester tester) async {
  // Mock TaskState as TaskLoaded
  when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks: []));
  
  // Mock the AuthBloc's state changes on logout
  when(() => mockAuthBloc.stream).thenAnswer(
    (_) => Stream.fromIterable([AuthInitial(), UserLoggedOut()]), 
  );

  // Create the widget tree with the mocked bloc
  await tester.pumpWidget(createTestableWidget(TaskScreen(userId: 'user123')));

  // Tap the logout button
  await tester.tap(find.byIcon(Icons.logout));
  await tester.pump();  // Pump the widget to process the tap

  // Allow widget tree to settle after the logout action
  await tester.pumpAndSettle();  // Make sure everything settles
  
  // Check if print statements are triggered and output to console
  expect(find.byType(CreateUserScreen), findsOneWidget);  // Expect CreateUserScreen to appear after logout
  
});

}
