// import 'package:flutter/material.dart';

// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const TextField(
//               decoration: InputDecoration(
//                 labelText: 'Email',
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             const TextField(
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle login logic here
//               },
//               child: const Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wuct/services/auth_service.dart';
import 'package:wuct/shared/custom_snack_bar.dart';
import 'package:wuct/shared/styled_button.dart';
import 'package:wuct/shared/styled_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorFeedback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledAppBarText('Login'),
        backgroundColor: Colors.green[800],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: StyledHeading('Welcome Back.')),
                const SizedBox(height: 16),
                const Center(child: StyledBodyText('Sign into your account')),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    final emailRegex = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if (!emailRegex.hasMatch(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a password";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                if (_errorFeedback != null)
                  Text(_errorFeedback!,
                      style: const TextStyle(color: Colors.red)),
                StyledButton(
                  onPressed: () async {
                    setState(() {
                      _errorFeedback = null;
                    });
                    if (!_formKey.currentState!.validate()) return;
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    try {
                      final user = await AuthService.signIn(email, password);

                      // Error feedback
                      // if (user == null) {
                      //   setState(() {
                      //     _errorFeedback = 'Invalid login credentials';
                      //   });
                      if (user != null) {
                        // Show the Snackbar for success
                        ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(label: 'Login Successful'));
                        // After Snackbar, redirect to home page
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      }
                    } catch (e) {
                      setState(() {
                        _errorFeedback = e.toString();
                      });
                    }
                    // Attempt login
                  },
                  child: const StyledButtonText('Sign in'),
                ),
                const SizedBox(height: 16),
                const Center(child: StyledBodyText('Need an account?')),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child:
                        Text('Sign up instead', style: GoogleFonts.poppins())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
