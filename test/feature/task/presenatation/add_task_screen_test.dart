import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/core/utils/routes.dart';
import 'package:task_manager/features/auth/presentation/pages/create_user_screen.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';
import 'package:task_manager/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager/features/task/presentation/bloc/task_event.dart';
import 'package:task_manager/features/task/presentation/bloc/task_state.dart';
import 'package:task_manager/features/task/presentation/pages/add_task_scree.dart';
import 'package:task_manager/features/task/domain/entities/priority.dart';
import 'package:task_manager/features/task/presentation/pages/task_screen.dart';

class MockTaskBloc extends MockBloc<TaskEvent, TaskState> implements TaskBloc {}

void main() {
  late MockTaskBloc mockTaskBloc;

  setUp(() {
    mockTaskBloc = MockTaskBloc();
  });

  tearDown(() {
    mockTaskBloc.close();
  });

  Widget createTestableWidget(Widget child) {
    return BlocProvider<TaskBloc>(
      create: (_) => mockTaskBloc,
      child: MaterialApp(
        routes: {
          Routes.taskScreen: (context) {
            final userId = ModalRoute.of(context)?.settings.arguments as String;
            return TaskScreen(userId: userId);
          },
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
    );
  }

  testWidgets('AddTaskScreen renders correctly for creating a new task', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(AddTaskScreen(userId: 'user123')));

    expect(find.text('Add Task'), findsNWidgets(2));
 
    expect(find.byType(TextField), findsNWidgets(2));

    expect(find.textContaining('Due Date'), findsOneWidget);

  });

  testWidgets('AddTaskScreen renders correctly for editing an existing task', (WidgetTester tester) async {
    final existingTask = UserTask(
      id: '1',
      title: 'Existing Task',
      description: 'This is a task that already exists.',
      dueDate: DateTime(2023, 12, 25),
      priority: Priority.high,
    );

    await tester.pumpWidget(createTestableWidget(AddTaskScreen(userId: 'user123', task: existingTask)));


    expect(find.text('Edit Task'),findsOneWidget);


    expect(find.byType(TextField).at(0), findsOneWidget);
    expect(find.byType(TextField).at(1), findsOneWidget);


    expect(find.byType(TextField).at(0), findsOneWidget);
    expect(find.text('Existing Task'), findsOneWidget);
    expect(find.text('This is a task that already exists.'), findsOneWidget);

    expect(find.text('High'), findsOneWidget);

    expect(find.text('Save Changes'), findsOneWidget);
  });

  testWidgets('Save button triggers AddTaskEvent when creating a task', (WidgetTester tester) async {

    await tester.pumpWidget(createTestableWidget(AddTaskScreen(userId: 'user123')));


    await tester.enterText(find.byType(TextField).at(0), 'New Task');
    await tester.enterText(find.byType(TextField).at(1), 'Description of new task');

    await tester.tap(find.text('Add Task').last);
    await tester.pumpAndSettle();

    // verify(() => mockTaskBloc.add(AddTaskEvent(userId: 'user123', task: any()))).called(1);
  });

  testWidgets('Save button triggers EditTaskEvent when editing a task', (WidgetTester tester) async {
    final existingTask = UserTask(
      id: '1',
      title: 'Existing Task',
      description: 'This is a task that already exists.',
      dueDate: DateTime(2023, 12, 25),
      priority: Priority.low,
    );

    await tester.pumpWidget(createTestableWidget(AddTaskScreen(userId: 'user123', task: existingTask)));


    await tester.enterText(find.byType(TextField).at(0), 'Updated Task Title');


    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();


    // verify(() => mockTaskBloc.add(EditTaskEvent(
    //   userId: 'user123',
    //   taskId: '1',
    //   task: any(),
    // ))).called(1);
  });

  testWidgets('Due Date Picker works as expected', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(AddTaskScreen(userId: 'user123')));

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    expect(find.byType(DatePickerDialog), findsOneWidget);
  });

  testWidgets('Priority dropdown updates value correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(AddTaskScreen(userId: 'user123')));

    await tester.tap(find.byType(DropdownButtonFormField<Priority>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Low'));
    await tester.pumpAndSettle();

    expect(find.text('Low'), findsOneWidget);
    
  });

testWidgets('Should navigate to taskscreen after task updated', (WidgetTester tester) async {
  final existingTask = [
    UserTask(
    id: '1',
    title: 'Existing Task1',
    description: 'This is a task that already exists1.',
    dueDate: DateTime(2023, 12, 25),
    priority: Priority.low,
  ),
  UserTask(
    id: '2',
    title: 'Existing Task2',
    description: 'This is a task that already exists2.',
    dueDate: DateTime(2023, 12, 25),
    priority: Priority.low,
  )
  ];


  when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks: existingTask));

   when(() => mockTaskBloc.stream).thenAnswer(
    (_) => Stream.fromIterable([TaskInitial(), TaskLoading(), TaskLoaded(tasks: existingTask)]), 
  );

  await tester.pumpWidget(createTestableWidget(AddTaskScreen(userId: 'user123')));


  final saveButton = find.byType(ElevatedButton);
  expect(saveButton, findsOneWidget);


  await tester.tap(saveButton);

  verify(() => mockTaskBloc.add(AddTaskEvent(userId: 'user_1', task:existingTask[0])),).called(1);
  await tester.pump(); 

  await tester.pumpAndSettle();  

  // expect(find.byType(TaskScreen), findsOneWidget);
});


}

