import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wuct/models/app_user.dart';
import 'package:wuct/providers/auth_provider.dart';
import 'package:wuct/services/notification_service.dart';
import 'package:wuct/shared/custom_app_bar.dart';
import 'package:wuct/shared/custom_snack_bar.dart';

class AnnouncementsPage extends ConsumerStatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  ConsumerState<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends ConsumerState<AnnouncementsPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  bool isLoading = false;

  Future<void> _sendAnnouncement(AppUser user) async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(label: "Please fill out both fields."),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      // Send the notification
      final notificationService = NotificationService();
      await notificationService.sendNotificationToPhone(
        user, // Pass the current user
        _titleController.text,
        _bodyController.text,
      );

      // Clear the fields
      _titleController.clear();
      _bodyController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(label: "Announcement Sent"),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(label: "Error sending announcement: $error"),
      );
      Navigator.pop(context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: const CustomAppBar(label: 'Send Announcement'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: authState.when(
          data: (user) {
            if (user == null) {
              return const Center(
                child: Text("User data not available."),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus
                                ?.unfocus(); // Dismiss keyboard
                          },
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
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus
                                ?.unfocus(); // Dismiss keyboard
                          },
                          controller: _bodyController,
                          decoration: const InputDecoration(
                            hintText: 'Enter the announcement details here.',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 6,
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () => _sendAnnouncement(user),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(
                                  46, 125, 50, 1), // Match app green
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Send Announcement',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "*Sending an announcements alerts all users' phones with a notification",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: Colors.blue)),
          error: (error, stackTrace) =>
              Center(child: Text('Error loading user data: $error')),
        ),
      ),
    );
  }
}
