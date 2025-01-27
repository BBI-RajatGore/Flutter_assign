import 'package:ecommerce_app/features/auth/presentation/widgets/auth_options_widget.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/signup_page_widgets/signup_form.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 80),
              child: Text(
                'Create an Account',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
            ),
            SignUpForm(),
            SizedBox(height: 40),
            AuthOptionsWidget(isSignin: false,),
          ],
        ),
      ),
    );
  }
}
