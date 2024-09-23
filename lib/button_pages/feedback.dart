import 'package:flutter/material.dart';

void main() {
  // This is where runApp would typically be called
  // However, in this code snippet, runApp is omitted
}

class FeedB extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Center(
        child: Text(
          'TextField widget submit',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
