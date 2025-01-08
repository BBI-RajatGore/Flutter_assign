import 'package:flutter/material.dart';
import 'package:task_manager/core/utils/constant.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutConfirmationDialog({required this.onConfirm, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        TaskScreenConstants.logoutConfirmationTitleText,
        style: TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        TaskScreenConstants.logoutConfirmationText,
        style: TextStyle(color: AppColors.grey),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            TaskScreenConstants.cancelText,
            style: TextStyle(color: AppColors.grey),
          ),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: const Text(
            TaskScreenConstants.confirmText,
            style: TextStyle(color: AppColors.errorColor),
          ),
        ),
      ],
    );
  }
}
