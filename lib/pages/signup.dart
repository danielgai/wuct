import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wuct/services/auth_service.dart';
import 'package:wuct/shared/custom_app_bar.dart';
import 'package:wuct/shared/custom_snack_bar.dart';
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

  String? _errorFeedback;
  bool isLoading = false;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _errorFeedback = null;
      isLoading = true;
    });
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final washuID = _washuIDController.text.trim();

    try {
      final user = await AuthService.signUp(email, password, washuID);
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
              label:
                  'Signup Successful, Please Verify Your Email to Access Your Account'),
        );
        if (mounted) {
          Navigator.pop(context, '/home');
        }
      }
    } catch (e) {
      setState(() {
        _errorFeedback = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(label: 'Sign Up'),
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
                    child: StyledBodyText('Sign up for a new account',
                        fontSize: 16)),
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
                  textInputAction: TextInputAction.done, // Enable "done" button
                  onFieldSubmitted: (_) =>
                      _signUp(), // Trigger sign-up on Enter
                ),
                const SizedBox(height: 24),
                if (_errorFeedback != null)
                  Text(_errorFeedback!,
                      style: const TextStyle(color: Colors.red)),
                StyledButton(
                  onPressed: () {
                    if (!isLoading) _signUp();
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const StyledButtonText('Sign up'),
                ),
                const SizedBox(height: 16),
                const Center(
                    child: StyledBodyText('Already have an account?',
                        fontSize: 16)),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text('Sign in instead', style: GoogleFonts.poppins()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
