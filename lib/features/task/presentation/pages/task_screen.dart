import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';
import 'package:task_manager/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager/features/task/presentation/bloc/task_event.dart';
import 'package:task_manager/features/task/presentation/bloc/task_state.dart';
import 'package:task_manager/features/task/presentation/pages/add_task_scree.dart';

class TaskScreen extends StatefulWidget {
  final String userId;

  TaskScreen({required this.userId});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    super.initState();
    print("called init");
    context.read<TaskBloc>().add(FetchTasksEvent(userId: widget.userId));
  }

  void _showTaskDetailsDialog(UserTask task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(task.title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('id: ${task.id}'),
                Text('Description: ${task.description}'),
                Text('Due Date: ${task.dueDate}'),
                Text('Priority: ${task.priority}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${widget.userId}"),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddTaskScreen(
                              userId: widget.userId,
                              task: task,
                            ),
                          )).then((_) {
                        context
                            .read<TaskBloc>()
                            .add(FetchTasksEvent(userId: widget.userId));
                      });
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => AddTaskScreen(
                    //       userId: widget.userId,
                    //       task: task,
                    //     ),
                    //   ),
                    // );
                    _showTaskDetailsDialog(task);
                  },
                );
              },
            );
          } else if (state is TaskError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("No tasks available"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTaskScreen(userId: widget.userId),
            ),
          ).then((_) {
            context
                .read<TaskBloc>()
                .add(FetchTasksEvent(userId: widget.userId));
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
