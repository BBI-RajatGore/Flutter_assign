import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce_app/features/auth/domain/entities/auth_model.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            Container(
              child: Image.asset(
                'assets/images/img1.png',
                height: 80,
                width: 100,
              ),
            ),
            const SizedBox(height: 40),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    icon: Icons.lock,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.teal,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final authModel = AuthModel(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        BlocProvider.of<AuthBloc>(context)
                            .add(SignInEvent(authModel));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: 2,
                        color: Colors.teal,
                      ),
                      const Text("   OR   "),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: 2,
                        color: Colors.teal,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SignInButton(
                    elevation: 2.0,
                    Buttons.google,
                    text: "Login With Google",
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(
                        SignInWithGoogleEvent(),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    IconData? icon,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: Colors.teal) : null,
        suffixIcon: suffixIcon,
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.teal,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
