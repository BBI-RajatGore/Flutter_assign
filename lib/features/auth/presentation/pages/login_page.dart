import 'package:ecommerce_app/features/auth/presentation/widgets/auth_options_widget.dart';
import 'package:ecommerce_app/features/auth/presentation/widgets/login_page_widgets/email_password_form.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 80),
              child: Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
            ),
            Image.asset('assets/images/img1.png', height: 80, width: 100),
            const SizedBox(height: 40),
            EmailPasswordForm(),
            const SizedBox(height: 40),
            const AuthOptionsWidget(isSignin: true,),
          ],
        ),
      ),
    );
  }
}
