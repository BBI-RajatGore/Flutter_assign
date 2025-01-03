import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/utils/constant.dart';
import 'package:task_manager/core/utils/routes.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_state.dart';
import 'package:task_manager/features/auth/presentation/widget/login_dialog_widget.dart';

class CreateUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            _authStateListener(context, state);
          },
          builder: (context, state) {
            return _buildMainContent(context, state);
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        AppStrings.createUser,
        style: AppTextStyles.titleStyle,
      ),
      backgroundColor: AppColors.grey,
      centerTitle: true,
    );
  }

  Column _buildMainContent(BuildContext context, AuthState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        _buildCreateUserButton(context),
        const SizedBox(height: 16),
        _buildLoginButton(context),
        const SizedBox(height: 30),
        if (state is Loading) const CircularProgressIndicator(color: AppColors.grey,),
      ],
    );
  }

  ElevatedButton _buildCreateUserButton(BuildContext context) {
    return ElevatedButton(
      key: const Key('createUserButton'),
      onPressed: () {
        context.read<AuthBloc>().add(CreateUserEvent());
      },
      child: const Text(
        AppStrings.createUser,
        style: AppTextStyles.buttonTextStyle,
      ),
    );
  }

  ElevatedButton _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showLoginDialog(context);
      },
      child: const Text(
        AppStrings.login,
        style: AppTextStyles.buttonTextStyle,
      ),
    );
  }

  void _authStateListener(BuildContext context, AuthState state) {
    if (state is UserLoggedIn) {
      Navigator.pushReplacementNamed(
        context,
        Routes.taskScreen,
        arguments: state.userId,
      );
    } else if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  }

  void _showLoginDialog(BuildContext context) {
    final TextEditingController userIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoginDialog(
          controller: userIdController,
          onLogin: () {
            if (userIdController.text.isNotEmpty) {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(
                    LoginUserEvent(userId: userIdController.text.trim()),
                  );
                 
            } else {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please enter a user ID")),
              );
            }
          },
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }
}
