// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart';
// import 'package:ecommerce_app/features/auth/domain/entities/auth_model.dart';
// import 'package:sign_in_button/sign_in_button.dart';

// class SignUpPage extends StatefulWidget {
//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
//         child: Column(
//           children: [
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: 80),
//               child: Text(
//                 'Create an Account',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.teal,
//                 ),
//               ),
//             ),
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   _buildTextField(
//                     controller: emailController,
//                     labelText: 'Email',
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) {
//                       if (value == null ||
//                           value.isEmpty ||
//                           !RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
//                         return 'Please enter a valid email';
//                       }
//                       return null;
//                     },
//                     icon: Icons.email,
//                   ),
//                   const SizedBox(height: 16),
//                   _buildTextField(
//                     controller: passwordController,
//                     labelText: 'Password',
//                     obscureText: _obscurePassword,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       } else if (value.length < 6) {
//                         return 'Password must be at least 6 characters';
//                       }
//                       return null;
//                     },
//                     icon: Icons.lock,
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscurePassword
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                         color: Colors.teal,
//                       ),
//                       onPressed: _togglePasswordVisibility,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   _buildTextField(
//                     controller: confirmPasswordController,
//                     labelText: 'Confirm Password',
//                     obscureText: _obscureConfirmPassword,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please confirm your password';
//                       } else if (value != passwordController.text) {
//                         return 'Passwords do not match';
//                       }
//                       return null;
//                     },
//                     icon: Icons.lock,
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscureConfirmPassword
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                         color: Colors.teal,
//                       ),
//                       onPressed: _toggleConfirmPasswordVisibility,
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         final authModel = AuthModel(
//                           email: emailController.text,
//                           password: passwordController.text,
//                         );

//                         Navigator.pop(context);
//                         BlocProvider.of<AuthBloc>(context)
//                             .add(SignUpEvent(authModel),);
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.teal,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       minimumSize: const Size(double.infinity, 50),
//                     ),
//                     child: const Text(
//                       'Create Account',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: MediaQuery.of(context).size.width * 0.35,
//                         height: 2,
//                         color: Colors.teal,
//                       ),
//                       const Text("   OR   "),
//                       Container(
//                         width: MediaQuery.of(context).size.width * 0.35,
//                         height: 2,
//                         color: Colors.teal,
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 40),
//                   SignInButton(
//                     elevation: 2.0,
//                     Buttons.google,
//                     text: "Sign Up With Google",
//                     onPressed: () {

//                       Navigator.pop(context);

//                       BlocProvider.of<AuthBloc>(context).add(
//                         SignInWithGoogleEvent(),
//                       );

//                     },
//                   ),
//                   const SizedBox(height: 40),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: RichText(
//                       text: const TextSpan(
//                         text: "Already have an account? ",
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         children: [
//                           TextSpan(
//                             text: 'Login',
//                             style: TextStyle(
//                               color: Colors.teal,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String labelText,
//     bool obscureText = false,
//     TextInputType keyboardType = TextInputType.text,
//     String? Function(String?)? validator,
//     IconData? icon,
//     Widget? suffixIcon,
//   }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         prefixIcon: icon != null ? Icon(icon, color: Colors.teal) : null,
//         suffixIcon: suffixIcon,
//         labelText: labelText,
//         labelStyle: const TextStyle(
//           color: Colors.teal,
//           fontWeight: FontWeight.w500,
//         ),
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding:
//             const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.teal, width: 1),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.teal, width: 2),
//         ),
//       ),
//       validator: validator,
//     );
//   }

//   void _togglePasswordVisibility() {
//     setState(() {
//       _obscurePassword = !_obscurePassword;
//     });
//   }

//   void _toggleConfirmPasswordVisibility() {
//     setState(() {
//       _obscureConfirmPassword = !_obscureConfirmPassword;
//     });
//   }

// }



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
