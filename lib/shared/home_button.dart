import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? url;
  final Function(BuildContext)? onPressed;

  const HomeButton({
    super.key,
    required this.label,
    required this.icon,
    this.url,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (url != null) {
          // Navigate to WebView or launch URL
          Navigator.of(context).pushNamed('/webViewContainer', arguments: url);
        } else if (onPressed != null) {
          onPressed!(context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Button background color
        foregroundColor: Colors.green[900], // Splash color
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.green[900],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// Data model for buttons
class ButtonData {
  final String label;
  final IconData icon;
  final String? url;
  final Function(BuildContext)? onPressed;

  ButtonData({
    required this.label,
    required this.icon,
    this.url,
    this.onPressed,
  });
}
