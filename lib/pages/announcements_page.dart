import 'package:flutter/material.dart';
import 'package:wuct/shared/custom_app_bar.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  bool isLoading = false;

  void _sendAnnouncement() {
    // Print statements to simulate sending the announcement
    print("Title: ${_titleController.text}");
    print("Body: ${_bodyController.text}");
    // Clear the fields after "sending"
    _titleController.clear();
    _bodyController.clear();
    // Show a snackbar to confirm
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Announcement sent!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(label: 'Send Announcement'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Use a short, descriptive title.',
                border: OutlineInputBorder(),
              ),
              maxLength: 50,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(
                hintText: 'Enter the announcement details here.',
                border: OutlineInputBorder(),
              ),
              maxLines: 6,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendAnnouncement,
              child: const Text('Send Announcement'),
            ),
          ],
        ),
      ),
    );
  }
}
