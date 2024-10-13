import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wuct/services/auth_service.dart';
import 'package:wuct/shared/styled_button.dart';
import 'package:wuct/shared/styled_text.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _washuIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledAppBarText('Sign Up'),
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
                const Center(child: StyledHeading('Welcome.')),
                const SizedBox(height: 16),
                const Center(
                    child: StyledBodyText('Sign up for a new account')),
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
                    if (value.length < 8) {
                      return "Password must be 8 chars long";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _washuIDController,
                  decoration: const InputDecoration(labelText: 'WashU ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your WashU ID";
                    }
                    if (value.length != 6) {
                      return "WashU ID must be 6 digits long";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                StyledButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    final washuID = _washuIDController.text.trim();

                    final user =
                        await AuthService.signup(email, password, washuID);
                    //error feedback
                    
                  },
                  child: const StyledButtonText('Sign up'),
                ),
                const SizedBox(height: 16),
                const Center(child: StyledBodyText('Already have an account?')),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child:
                        Text('Sign in instead', style: GoogleFonts.poppins()))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
