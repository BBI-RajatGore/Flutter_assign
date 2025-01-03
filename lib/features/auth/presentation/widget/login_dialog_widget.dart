
import 'package:flutter/material.dart';
import 'package:task_manager/core/utils/constant.dart';

class LoginDialog extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onLogin;
  final VoidCallback onCancel;

  const LoginDialog({
    required this.controller,
    required this.onLogin,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text(AppStrings.enterUserId),
      content: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: AppStrings.userIdHint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.grey),
          ),
          prefixIcon: const Icon(Icons.person, color: AppColors.grey),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: onLogin,
          child: const Text(AppStrings.login, style: TextStyle(color: AppColors.grey)),
        ),
        TextButton(
          onPressed: onCancel,
          child: const Text(AppStrings.cancel,style: TextStyle(color: AppColors.grey)),
        ),
      ],
    );
  }
}
