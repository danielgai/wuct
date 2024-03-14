import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  String label = "";
  final Function() action;
  final IconData icon;

  Button({required this.action, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return
      // ElevatedButton.icon(
      // onPressed: action,
      // icon: icon,
      // label: Text(label),

Expanded(
      child: ElevatedButton(
        onPressed: action,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0), // Remove elevation
          overlayColor: MaterialStateProperty.all(Colors.transparent), // Remove overlay color
          shadowColor: MaterialStateProperty.all(Colors.transparent), // Remove shadow color
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))), // Remove border
        ),
        child: Column(
          children:[
            Icon(
             icon,
              size: 100,
              color: Colors.green[900],
            ),
            SizedBox(height: 8),
            Text(
                label,
                style: TextStyle(
                  fontSize: 14,

                  fontWeight: FontWeight.bold,
                )
            )
          ],
        ),
      ),
  flex: 3,
);
      // size: 100,
      // color: Colors.green[900],


  }
}
