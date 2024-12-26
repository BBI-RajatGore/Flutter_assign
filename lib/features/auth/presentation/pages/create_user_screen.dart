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
      appBar: AppBar(title: const Text("Create User")),
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is UserCreated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskScreen(
                    userId: state.userId,
                  ),
                ),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message.toString(),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          CreateUserEvent(),
                        );
                  },
                  child: const Text("Create New User"),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _showLoginDialog(context);
                  },
                  child: const Text("Login"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    final TextEditingController _userIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter User ID"),
          content: TextField(
            controller: _userIdController,
            decoration: InputDecoration(hintText: "User ID"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (_userIdController.text.isNotEmpty) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskScreen(userId: _userIdController.text.trim(),),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a user ID")),
                  );
                }
              },
              child: Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
