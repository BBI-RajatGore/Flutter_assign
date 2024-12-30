import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_state.dart';
import 'package:task_manager/features/task/domain/entities/usertask.dart';
import 'package:task_manager/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager/features/task/presentation/bloc/task_event.dart';
import 'package:task_manager/features/task/presentation/bloc/task_state.dart';
import 'package:task_manager/features/task/presentation/pages/add_task_scree.dart';
import 'package:task_manager/features/auth/presentation/pages/create_user_screen.dart';

class TaskScreen extends StatefulWidget {
  final String userId;
  final Function? funtion;

  TaskScreen({required this.userId, this.funtion});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(FetchTasksEvent(userId: widget.userId));
  }

  void _showTaskDetailsDialog(UserTask task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(task.title,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Title: ${task.title}', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 8),
                Text('Description: ${task.description}',
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 8),
                Text('Due Date: ${task.dueDate}',
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 8),
                Text('Priority: ${task.priority.name}',
                    style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        title: Text("Welcome ${widget.userId}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is UserLoggedOut) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateUserScreen(),
                  ),
                );
              }
            },
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutUserEvent());
                },
                icon: const Icon(Icons.logout, color: Colors.white),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            if (state.tasks.isEmpty) {
              return const Center(
                child: Text(
                  "No Task Added",
                  style: TextStyle(color: Colors.deepPurple, fontSize: 20),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      title: Text(task.title,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Due: ${task.dueDate}',
                          style: const TextStyle(color: Colors.grey)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddTaskScreen(
                                      userId: widget.userId, task: task),
                                ),
                              ).then((_) {
                                context.read<TaskBloc>().add(
                                    FetchTasksEvent(userId: widget.userId));
                              });
                            },
                            icon: const Icon(Icons.edit,
                                color: Colors.deepPurple),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<TaskBloc>().add(DeleteTaskEvent(
                                  userId: widget.userId, taskId: task.id));
                            },
                            icon: const Icon(Icons.delete,
                                color: Colors.redAccent),
                          ),
                        ],
                      ),
                      onTap: () {
                        _showTaskDetailsDialog(task);
                      },
                    ),
                  );
                },
              ),
            );
          } else if (state is TaskError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.deepPurple,fontSize: 20),
              ),
            );
          }
          return const Center(
            child: Text(
              "No Task Added",
              style: TextStyle(color: Colors.deepPurple, fontSize: 20),
            ),
          );
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
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}
