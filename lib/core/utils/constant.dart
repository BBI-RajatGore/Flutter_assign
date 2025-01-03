import 'package:flutter/material.dart';
import 'package:task_manager/features/task/domain/entities/priority.dart';

class AppColors {
  static const deepPurple = Color(0xFF6200EE);
  static const white = Colors.white;
  static const primaryBackground = Color(0xFFF5F5F5);
  static const errorColor = Color(0xFFB00020);
  static const orange = Color.fromARGB(255, 255, 166, 1);
  static const grey = Color.fromARGB(255, 131, 131, 131);
  static const dropdownColor = Color.fromARGB(255, 163, 161, 161);

  static  Color getPriorityColor(Priority priority) {
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

class AppTextStyles {
  static const titleStyle = TextStyle(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.grey,
  );

  static const inputTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.deepPurple,
  );
}

class AppStrings {
  static const createUser = "Create New User";
  static const login = "Login";
  static const enterUserId = "Enter User ID";
  static const userIdHint = "Enter your user ID";
  static const userErrorMessage = "Please enter a user ID";
  static const cancel = "Cancel";
}


class TaskScreenConstants {
  static const String appBarTitle = "Welcome ";
  static const String noTaskMessage = "No Task Added";
  static const String filterPriority = "Priority";
  static const String filterDueDate = "Due Date";
  static const String taskLoadingMessage = "Loading tasks...";
  static const String logoutButtonTooltip = "Logout";
  static const String addTaskButtonTooltip = "Add New Task";
}
