import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  String label = "";
  final Function() action;
  final Icon icon;

  Button({required this.action, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: action,
      icon: icon,
      label: Text(label),
    );
  }
}
