
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart';

class AuthOptionsWidget extends StatelessWidget {

  final isSignin;
  
  const AuthOptionsWidget({Key? key,required this.isSignin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: MediaQuery.of(context).size.width * 0.35, height: 2, color: Colors.teal),
            const Text("   OR   "),
            Container(width: MediaQuery.of(context).size.width * 0.35, height: 2, color: Colors.teal),
          ],
        ),
        const SizedBox(height: 40),
        SignInButton(
          elevation: 2.0,
          Buttons.google,
          text: (isSignin) ? "SignIn With Google" : "SignUp With Google",
          onPressed: () {
            BlocProvider.of<AuthBloc>(context).add(SignInWithGoogleEvent());
            (!isSignin) ? Navigator.pop(context) : null ; 
          },
        ),
        const SizedBox(height: 40),
        GestureDetector(
          onTap: () {
            (isSignin) ? Navigator.pushNamed(context, '/signup') : Navigator.pop(context); 
          },
          child: RichText(
            text: TextSpan(
              text: (isSignin) ? "Don't have an account? " :  "Already have an account? ",
              style: const  TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: (isSignin) ? "Sign Up" : 'Sign In',
                  style: const  TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}