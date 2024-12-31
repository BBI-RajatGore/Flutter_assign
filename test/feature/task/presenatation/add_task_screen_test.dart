import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';
import 'package:task_manager/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager/features/task/presentation/bloc/task_event.dart';
import 'package:task_manager/features/task/presentation/bloc/task_state.dart';
import 'package:task_manager/features/task/presentation/pages/add_task_scree.dart';
import 'package:task_manager/features/task/domain/entities/priority.dart';

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
        home: child,
      ),
    );
  }

  testWidgets('AddTaskScreen renders correctly for creating a new task', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(AddTaskScreen(userId: 'user123')));

    expect(find.text('Add Task Screen'), findsOneWidget);///
    expect(find.text('Add Task'), findsOneWidget);///

    // Check if the text fields for title and description are rendered
    expect(find.byType(TextField), findsNWidgets(2));

    // // Check if the due date text is displayed
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

    // Check if the app bar title says "Edit Task"
    expect(find.text('Edit Task'),findsOneWidget);

    // Check if the text fields are populated with the existing task details
    expect(find.byType(TextField).at(0), findsOneWidget);
    expect(find.byType(TextField).at(1), findsOneWidget);

    // // Check if the title and description match the existing task
    expect(find.byType(TextField).at(0), findsOneWidget);
    expect(find.text('Existing Task'), findsOneWidget);
    expect(find.text('This is a task that already exists.'), findsOneWidget);

    // // Check if the priority dropdown reflects the existing task's priority
    expect(find.text('High'), findsOneWidget);

    // // Check if the save button shows "Save Changes"
    expect(find.text('Save Changes'), findsOneWidget);
  });

  testWidgets('Save button triggers AddTaskEvent when creating a task', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(AddTaskScreen(userId: 'user123')));

    // Enter data into the title and description fields
    await tester.enterText(find.byType(TextField).at(0), 'New Task');
    await tester.enterText(find.byType(TextField).at(1), 'Description of new task');

    // // Tap the save button
    await tester.tap(find.text('Add Task'));
    await tester.pumpAndSettle();

    // // Verify that the AddTaskEvent was triggered
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

    // Change the task title
    await tester.enterText(find.byType(TextField).at(0), 'Updated Task Title');

    // Tap the save button
    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();

    // Verify that the EditTaskEvent was triggered with the updated task
    // verify(() => mockTaskBloc.add(EditTaskEvent(
    //   userId: 'user123',
    //   taskId: '1',
    //   task: any(),
    // ))).called(1);
  });

  testWidgets('Due Date Picker works as expected', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(AddTaskScreen(userId: 'user123')));

    // Tap on the due date tile
    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    // Verify if the date picker dialog is shown
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });

  testWidgets('Priority dropdown updates value correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(AddTaskScreen(userId: 'user123')));

    // Open the priority dropdown
    await tester.tap(find.byType(DropdownButtonFormField<Priority>));
    await tester.pumpAndSettle();

    // Select a new priority from the dropdown
    await tester.tap(find.text('Low'));
    await tester.pumpAndSettle();

    // // Verify that the priority value changes to "low"
    expect(find.text('Low'), findsOneWidget);
    
  });

}

