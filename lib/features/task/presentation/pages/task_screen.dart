import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_state.dart';
import 'package:task_manager/features/task/domain/entities/priority.dart';
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
  String? _selectedPriority;
  String? _selectedDueDate;
  int? _expandedTaskIndex;

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(FetchTasksEvent(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    print("task screen called");
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
                print('User has logged out');
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
                  print("cliecjedddd");
                  context.read<AuthBloc>().add(LogoutUserEvent());
                },
                icon: const Icon(Icons.logout, color: Colors.white),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<String>(
                  value: _selectedPriority,
                  hint: const Text("Priority"),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPriority = newValue;
                    });
                    context.read<TaskBloc>().add(FilterTasksEvent(
                          userId: widget.userId,
                          priority: _selectedPriority,
                        ));
                  },
                  items: ['high', 'medium', 'low', 'all']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 20),
                DropdownButton<String>(
                  value: _selectedDueDate,
                  hint: const Text("Due Date"),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedDueDate = newValue;
                    });

                    bool? isDesc;
                    if (newValue == 'Desc') {
                      isDesc = true;
                    } else if (newValue == 'Asc') {
                      isDesc = false;
                    }

                    context.read<TaskBloc>().add(FilterTasksEvent(
                          userId: widget.userId,
                          priority: _selectedPriority,
                          isDesc: isDesc,
                        ));
                  },
                  items: ['Desc', 'Asc']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TaskLoaded) {
                  if (state.tasks.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Task Added",
                        style:
                            TextStyle(color: Colors.deepPurple, fontSize: 20),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: state.tasks.length,
                      itemBuilder: (context, index) {
                        final task = state.tasks[index];
                        return TaskCard(
                          task: task,
                          isExpanded: _expandedTaskIndex == index,
                          onTap: () {
                            setState(() {
                              // Toggle the task's expanded state
                              _expandedTaskIndex =
                                  _expandedTaskIndex == index ? null : index;
                            });
                          },
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddTaskScreen(
                                    userId: widget.userId, task: task),
                              ),
                            ).then((_) {
                              context
                                  .read<TaskBloc>()
                                  .add(FetchTasksEvent(userId: widget.userId));
                            });
                          },
                          onDelete: () {
                            context.read<TaskBloc>().add(DeleteTaskEvent(
                                userId: widget.userId, taskId: task.id));
                          },
                        );
                      },
                    ),
                  );
                } else if (state is TaskError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(
                          color: Colors.deepPurple, fontSize: 20),
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
          ),
        ],
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

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.redAccent;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class TaskCard extends StatelessWidget {
  final UserTask task;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    required this.task,
    required this.isExpanded,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            ListTile(
              leading: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _getPriorityColor(task.priority),
                  shape: BoxShape.circle,
                ),
              ),
              title: Text(
                task.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Due: ${task.dueDate}',
                  style: const TextStyle(color: Colors.grey)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, color: Colors.deepPurple),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                  ),
                ],
              ),
            ),
            if (isExpanded) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title: ${task.title}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Description: ${task.description}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Due Date: ${task.dueDate}',
                        style: const TextStyle(
                          fontSize: 15,
                        )),
                    const SizedBox(height: 8),
                    Text(
                      'Priority: ${task.priority.name}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.redAccent;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
