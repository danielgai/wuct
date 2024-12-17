import 'package:flutter/material.dart';

class NotificationBox extends StatelessWidget {
  final String sender;
  final String title;
  final String date;
  final String message;
  final VoidCallback onDismissed; // Callback for dismissal
  final VoidCallback onPressed;
  final Color containerColor;

  const NotificationBox({
    super.key,
    required this.sender,
    required this.title,
    required this.date,
    required this.message,
    required this.onDismissed,
    required this.onPressed,
    required this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: UniqueKey(), // Unique identifier for the Dismissible
        direction: DismissDirection.endToStart, // Swipe from left to right
        background: Container(
          alignment: Alignment.centerLeft,
          color: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (direction) {
          onDismissed(); // Trigger callback when dismissed
        },
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: containerColor, // Flat background color
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Date on the same row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      sender,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                // Sender below the Date
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Truncated message
                Text(
                  message.length > 35
                      ? '${message.substring(0, 35)}...' // Truncate message
                      : message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ));
  }
}
