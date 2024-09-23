import 'package:flutter/material.dart';

void main() {
  // This is where runApp would typically be called
  // However, in this code snippet, runApp is omitted
}

class Registration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Center(
        child: Text(
          'Registration info,pdfs, form',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
