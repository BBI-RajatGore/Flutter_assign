import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/utils/routes.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_state.dart';
import 'package:task_manager/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager/features/task/presentation/bloc/task_event.dart';
import 'package:task_manager/features/task/presentation/bloc/task_state.dart';
import 'package:task_manager/features/task/presentation/widgets/task_screen_widgets/delete_confirmation_dialog_widget.dart';
import 'package:task_manager/features/task/presentation/widgets/task_screen_widgets/duedate_dropdown_widget.dart';
import 'package:task_manager/features/task/presentation/widgets/task_screen_widgets/logout_confirmation_dialog_widget.dart';
import 'package:task_manager/features/task/presentation/widgets/task_screen_widgets/priority_dropdown_widget.dart';
import 'package:task_manager/features/task/presentation/widgets/task_screen_widgets/task_card_widget.dart';
import 'package:task_manager/core/utils/constant.dart';

class TaskScreen extends StatefulWidget {
  final String userId;
  final Function? function;

  TaskScreen({required this.userId, this.function});

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
    _loadFilters();
    context.read<TaskBloc>().add(FetchTasksEvent(userId: widget.userId));
  }

  Future<void> _loadFilters() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedPriority = prefs.getString('filter_priority') ?? 'all';
      bool isDesc = prefs.getBool('filter_is_desc') ?? false;
      _selectedDueDate = isDesc ? "Desc" : "Asc";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.grey,
        title: Text(
          "${TaskScreenConstants.appBarTitle}${widget.userId}",
          style: AppTextStyles.appBarStyle,
        ),
        actions: [
          PriorityDropdown(
            value: _selectedPriority,
            onChanged: (newValue) {
              setState(() {
                _selectedPriority = newValue;
              });
              context.read<TaskBloc>().add(FilterTasksEvent(
                    userId: widget.userId,
                    priority: _selectedPriority,
                    isDesc: _selectedDueDate == 'Desc',
                  ));
            },
          ),
          DuedateDropdownWidget(
            value: _selectedDueDate,
            hintText: TaskScreenConstants.filterDueDate,
            items: ['Desc', 'Asc'],
            onChanged: (newValue) {
              setState(() {
                _selectedDueDate = newValue;
              });
              context.read<TaskBloc>().add(FilterTasksEvent(
                    userId: widget.userId,
                    priority: _selectedPriority,
                    isDesc: _selectedDueDate == 'Desc',
                  ));
            },
          ),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is UserLoggedOut) {
                Navigator.pushReplacementNamed(
                  context,
                  Routes.createUserScreen,
                );
              }
            },
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  _showLogoutConfirmationDialog();
                },
                icon: const Icon(Icons.logout, color: AppColors.white),
                tooltip: TaskScreenConstants.logoutButtonTooltip,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.grey,
                    ),
                  );
                } else if (state is TaskLoaded) {
                  if (state.tasks.isEmpty) {
                    return const Center(
                      child: Text(
                        TaskScreenConstants.noTaskMessage,
                        style: AppTextStyles.noTaskMsgStyle,
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
                              _expandedTaskIndex =
                                  _expandedTaskIndex == index ? null : index;
                            });
                          },
                          onEdit: () {
                            Navigator.pushNamed(
                              context,
                              Routes.addTaskScreen,
                              arguments: {
                                'userId': widget.userId,
                                'task': task
                              },
                            ).then((_) {
                              context.read<TaskBloc>().add(FetchTasksEvent(userId: widget.userId));
                            });
                          },
                          onDelete: () => _showDeleteConfirmation(task.id),
                        );
                      },
                    ),
                  );
                } else if (state is TaskError) {
                  return const Center(
                    child: Text(
                      TaskScreenConstants.noTaskMessage,
                      style: AppTextStyles.noTaskMsgStyle,
                    ),
                  );
                }
                return const Center(
                  child: Text(
                    TaskScreenConstants.noTaskMessage,
                    style: AppTextStyles.noTaskMsgStyle,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        onPressed: () {
          Navigator.pushNamed(
            context,
            Routes.addTaskScreen,
            arguments: {'userId': widget.userId, 'task': null},
          ).then((_) {
            context.read<TaskBloc>().add(FetchTasksEvent(userId: widget.userId));
          });
        },
        backgroundColor: AppColors.grey,
        child: const Icon(Icons.add, size: 30, color: AppColors.white),
        tooltip: TaskScreenConstants.addTaskButtonTooltip,
      ),
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LogoutConfirmationDialog(onConfirm: () {
          context.read<TaskBloc>().add(UserLoggedOutEvent());
          context.read<AuthBloc>().add(LogoutUserEvent());
        });
      },
    );
  }

  void _showDeleteConfirmation(final id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          onConfirm: () {
            context.read<TaskBloc>().add(DeleteTaskEvent(userId: widget.userId, taskId: id));
          },
        );
      },
    );
  }
}
