import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyledButton extends StatelessWidget {
  const StyledButton(
      {super.key,
      required this.onPressed,
      required this.child,
      this.verticalEdgeInset = 16,
      this.horizontalEdgeInset = 32});

  final void Function() onPressed;
  final Widget child;
  final double verticalEdgeInset;
  final double horizontalEdgeInset;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color.fromRGBO(46, 125, 50, 1), // Match app green
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: verticalEdgeInset, horizontal: horizontalEdgeInset),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        onPressed: onPressed,
        child: child);
  }
}

class StyledButtonText extends StatelessWidget {
  const StyledButtonText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ));
  }
}
