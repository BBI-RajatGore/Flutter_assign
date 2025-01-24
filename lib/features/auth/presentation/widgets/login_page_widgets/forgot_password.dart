import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce_app/core/utils/constants.dart';

class ForgotPassword extends StatelessWidget {
  
  final TextEditingController emailController; 

  const ForgotPassword({Key? key, required this.emailController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            final email = emailController.text.trim(); 

            if (email.isEmpty) {
              Constants.showErrorSnackBar(context, "Please enter email");
            } else {
              BlocProvider.of<AuthBloc>(context).add(ForgotPasswordEvent(email: email));
              Constants.showSuccessSnackBar(context, "Reset link sent to your email");
            }
          },
          child: const Text(
            "Forgot Password",
            style: TextStyle(color: Colors.teal),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

