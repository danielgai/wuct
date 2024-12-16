import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? url;
  final Function(BuildContext)? onPressed;
  final int? numUnseenNotifications;

  const HomeButton({
    super.key,
    required this.label,
    required this.icon,
    this.url,
    this.onPressed,
    this.numUnseenNotifications,
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
          Stack(
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.green[900],
              ),
              if (numUnseenNotifications != null && numUnseenNotifications! > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      numUnseenNotifications! > 99
                          ? '99+' // Display "99+" for large numbers
                          : numUnseenNotifications.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
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
  final int? numUnseenNotifications;

  ButtonData({
    required this.label,
    required this.icon,
    this.url,
    this.onPressed,
    this.numUnseenNotifications,
  });
}
