import 'package:flutter/material.dart';
import 'package:task_manager/core/utils/constant.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({required this.onConfirm, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        TaskScreenConstants.deleteConfirmationTitleText,
        style: TextStyle(color: AppColors.grey, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        TaskScreenConstants.deleteConfirmationText,
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
