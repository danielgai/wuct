import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wuct/models/wuct_notification.dart';
import 'package:wuct/shared/custom_app_bar.dart';

class NotificationFullscreen extends StatefulWidget {
  final WUCTNotification notification;
  final String userId;
  final int index;

  const NotificationFullscreen(
      {super.key,
      required this.notification,
      required this.userId,
      required this.index});

  @override
  _NotificationFullscreenState createState() =>
      _NotificationFullscreenState();
}

class _NotificationFullscreenState extends State<NotificationFullscreen> {
  bool hasSeen = true;
  bool hasDeleted = false;

  void setHasSeen(bool value) {
    setState(() {
      hasSeen = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        label: "Notification Details",
        onBackPressed: () {
          Navigator.pop(context, [hasSeen, hasDeleted]);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Row with Dropdown Menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with wrapping support
                Expanded(
                  child: Text(
                    widget.notification.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left, // Aligns text to the left
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) async {
                    // Handle menu item selection
                    switch (value) {
                      case 'Mark as Unread':
                        setHasSeen(false);
                        break;
                      case 'Mark as Read':
                        setHasSeen(true);
                        break;
                      case 'Delete':
                        setState(() {
                          hasDeleted = true;
                        });
                        Navigator.pop(context, [hasSeen, hasDeleted]);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: popupValue(hasSeen),
                      child: Text(popupValue(hasSeen)),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'From: ${widget.notification.sender}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Date: ${DateFormat('yyyy-MM-dd').format(widget.notification.timestamp)}',
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
                  widget.notification.text,
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

String popupValue(bool hasSeen) {
  return hasSeen ? "Mark as Unread" : "Mark as Read";
}
