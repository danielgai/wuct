import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  String label = "";
  final Function() action;
  final IconData icon;

  Button({super.key, required this.action, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return
      // ElevatedButton.icon(
      // onPressed: action,
      // icon: icon,
      // label: Text(label),

Expanded(
      flex: 3,
      child: ElevatedButton(
        onPressed: action,
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0), // Remove elevation
          overlayColor: WidgetStateProperty.all(Colors.transparent), // Remove overlay color
          shadowColor: WidgetStateProperty.all(Colors.transparent), // Remove shadow color
          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))), // Remove border
        ),
        child: Column(
          children:[
            Icon(
             icon,
              size: 100,
              color: Colors.green[900],
            ),
            const SizedBox(height: 8),
            Text(
                label,
                style: const TextStyle(
                  fontSize: 14,

                  fontWeight: FontWeight.bold,
                )
            )
          ],
        ),
      ),
);
      // size: 100,
      // color: Colors.green[900],


  }
}
