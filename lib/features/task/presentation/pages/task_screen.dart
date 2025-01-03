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
      if (isDesc) {
        _selectedDueDate = "Desc";
      } else {
        _selectedDueDate = "Asc";
      }
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
            fontSize: 15,
          ),
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
          _buildStyledDropdown(
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
                        style: TextStyle(color: AppColors.grey, fontSize: 20),
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
                            );
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
                  return const Center(
                    child: Text(
                      TaskScreenConstants.noTaskMessage,
                      style: TextStyle(color: AppColors.grey, fontSize: 20),
                    ),
                  );
                }
                return const Center(
                  child: Text(
                    TaskScreenConstants.noTaskMessage,
                    style: TextStyle(color: AppColors.grey, fontSize: 20),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            Routes.addTaskScreen,
            arguments: {'userId': widget.userId, 'task': null},
          );
        },
        backgroundColor: AppColors.grey,
        child: Icon(Icons.add, size: 30, color: AppColors.white),
        tooltip: TaskScreenConstants.addTaskButtonTooltip,
      ),
    );
  }

  Widget _buildStyledDropdown({
    required String? value,
    required String hintText,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey, width: 1),
      ),
      child: DropdownButton<String>(
        value: value,
        hint: Text(
          hintText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        dropdownColor: AppColors.dropdownColor,
        icon:
            const Icon(Icons.arrow_drop_down, color: AppColors.white, size: 24),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList(),
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 16,
        ),
        underline: const SizedBox(),
      ),
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Logout',
            style:
                TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to log out ?',
            style: TextStyle(color: AppColors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<TaskBloc>().add(UserLoggedOutEvent());
                context.read<AuthBloc>().add(LogoutUserEvent());
                Navigator.pop(context);
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: AppColors.errorColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
