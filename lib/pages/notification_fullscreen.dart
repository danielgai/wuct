import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wuct/models/wuct_notification.dart';
import 'package:wuct/shared/custom_app_bar.dart';

class NotificationFullscreen extends StatelessWidget {
  final WUCTNotification notification;

  const NotificationFullscreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        label: "Notification Details",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Row with Dropdown Menu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    // Handle menu item selection
                    switch (value) {
                      case 'Mark as Unread':
                        print('Marking as unread');
                        break;
                      case 'Delete':
                        print('Deleting notification');
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'Mark as Unread',
                      child: Text('Mark as Unread'),
                    ),
                    const PopupMenuItem(
                      value: 'Delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Sender and Timestamp
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'From: ${notification.sender}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Date: ${DateFormat('yyyy-MM-dd').format(notification.timestamp)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 24,
              thickness: 1,
              color: Colors.grey,
            ),

            // Body of the message
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  notification.text,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
