import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/core/utils/routes.dart';
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


class MockTaskBloc extends MockBloc<TaskEvent, TaskState> implements TaskBloc {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockTaskBloc mockTaskBloc;
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockTaskBloc = MockTaskBloc();
    mockAuthBloc = MockAuthBloc();


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
          routes: {
            Routes.createUserScreen: (context) => CreateUserScreen(),
            Routes.addTaskScreen: (context) {
            final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
            final userId = arguments['userId'] as String;
            final task = arguments['task'] as UserTask?;
            return AddTaskScreen(userId: userId, task: task);
          },
          },
          home: child,
        ),
      ),
    );
  }

testWidgets('TaskScreen displays app bar and buttons correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(TaskScreen(userId: 'user123')));

    expect(find.text('Welcome user123'), findsOneWidget);

    expect(find.byIcon(Icons.logout), findsOneWidget);

    expect(find.text('Priority'), findsOneWidget);
    expect(find.text('Due Date'), findsOneWidget);
});

testWidgets('TaskScreen displays tasks correctly when loaded', (WidgetTester tester) async {
  
  when(() => mockTaskBloc.state).thenReturn(
    TaskLoaded(
      tasks: [
        UserTask(id: '1', title: 'Test Task 1', description: 'Description 1', dueDate: DateTime.now(), priority: Priority.high),    
        UserTask(id: '2', title: 'Test Task 2', description: 'Description 2', dueDate: DateTime.now(), priority: Priority.low),
      ],
    ),
  );

  await tester.pumpWidget(createTestableWidget(TaskScreen(userId: 'user123')));


  
  expect(find.text('Test Task 1'), findsOneWidget);
  expect(find.text('Test Task 2'), findsOneWidget);
});



  testWidgets('TaskScreen displays "No Task Added" when no tasks are available', (WidgetTester tester) async {

    when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks: []));

    await tester.pumpWidget(createTestableWidget(TaskScreen(userId: 'user123')));


    expect(find.text('No Task Added'), findsOneWidget);
  });

  testWidgets('Create New Task button triggers navigation to AddTaskScreen', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(TaskScreen(userId: 'user123')));


    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.byType(AddTaskScreen), findsOneWidget);
  });

  testWidgets('Check floating action button is present ', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(TaskScreen(userId: 'user123')));

    expect(find.byType(FloatingActionButton), findsOneWidget);
  });


testWidgets('TaskScreen filters tasks based on priority', (WidgetTester tester) async {

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

  
  await tester.pumpWidget(createTestableWidget(TaskScreen(userId: 'user123')));


  await tester.pumpAndSettle();

  expect(find.text('Test Task 1'), findsOneWidget); 
  expect(find.text('Test Task 2'), findsOneWidget); 


  await tester.tap(find.text('Priority')); 
  await tester.pumpAndSettle(); 

  await tester.tap(find.text('high').last); 
  await tester.pumpAndSettle(); 


  expect(find.text('Test Task 1'), findsOneWidget);
  expect(find.text('Test Task 2'), findsNothing); 

});


testWidgets('Logout button logs out the user', (WidgetTester tester) async {
 
  when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks: []));
  
  when(() => mockAuthBloc.stream).thenAnswer(
    (_) => Stream.fromIterable([AuthInitial(), UserLoggedOut()]), 
  );

  await tester.pumpWidget(createTestableWidget(TaskScreen(userId: 'user123')));

  await tester.tap(find.byIcon(Icons.logout));
  await tester.pump(); 

  await tester.pumpAndSettle();  
  
  expect(find.byType(CreateUserScreen), findsOneWidget);  
  
});

}
