import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_state.dart';
import 'package:task_manager/features/task/presentation/pages/task_screen.dart';

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

  // Custom AppBar
  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false, 
      title: const Text("Create User",style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.deepPurple,  // App bar color
      centerTitle: true,  // Center title
    );
  }

  // Main content builder
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
        if (state is Loading) 
          const CircularProgressIndicator(),
      ],
    );
  }


  ElevatedButton _buildCreateUserButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<AuthBloc>().add(CreateUserEvent());
      },
      child: const Text(
        "Create New User",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
      ),
    );
  }

  ElevatedButton _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showLoginDialog(context);
      },
      child: const Text(
        "Login",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
      ),
    );
  }


  void _authStateListener(BuildContext context, AuthState state) {
    if (state is UserLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TaskScreen(
            userId: state.userId,
          ),
        ),
      );
    } else if (state is AuthError) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  }

  
  void _showLoginDialog(BuildContext context) {
    final TextEditingController _userIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _LoginDialog(
          controller: _userIdController,
          onLogin: () {
            if (_userIdController.text.isNotEmpty) {
              context.read<AuthBloc>().add(
                    LoginUserEvent(userId: _userIdController.text.trim()),
                  );
            } else {
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


class _LoginDialog extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onLogin;
  final VoidCallback onCancel;

  const _LoginDialog({
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
      title: const Text("Enter User ID"),
      content: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Enter your user ID",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.deepPurple),
          ),
          prefixIcon: const Icon(Icons.person, color: Colors.deepPurple),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: onLogin,
          child: const Text("Login", style: TextStyle(color: Colors.deepPurple)),
        ),
        TextButton(
          onPressed: onCancel,
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
