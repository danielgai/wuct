import 'package:flutter/material.dart';

void main() {
  // This is where runApp would typically be called
  // However, in this code snippet, runApp is omitted
}

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Center(
        child: Text(
          'ListView of notis; Firebase cloud messaging',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
