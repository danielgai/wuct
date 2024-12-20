import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wuct/services/auth_service.dart';
import 'package:wuct/shared/custom_app_bar.dart';
import 'package:wuct/shared/custom_snack_bar.dart';
import 'package:wuct/shared/styled_button.dart';
import 'package:wuct/shared/styled_text.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  String? _errorFeedback;

  Future<void> _resetPassword() async {
    setState(() {
      _errorFeedback = null;
    });
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    try {
      await AuthService.resetPassword(email);
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(label: 'Password reset email sent'),
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _errorFeedback = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(label: 'Reset Password'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                    child:
                        StyledHeading('Forgot Your Password?', fontSize: 25)),
                const SizedBox(height: 16),
                const Center(
                    child: StyledBodyText(
                        'Enter your email to reset your password',
                        fontSize: 14)),
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
                const SizedBox(height: 24),
                if (_errorFeedback != null)
                  Text(_errorFeedback!,
                      style: const TextStyle(color: Colors.red)),
                StyledButton(
                  onPressed: _resetPassword,
                  child: const StyledButtonText('Send Reset Email'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, '/login');
                  },
                  child: Text('Back to login page', style: GoogleFonts.poppins()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
