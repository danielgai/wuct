import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wuct/pages/notification_fullscreen.dart';
import 'package:wuct/providers/auth_provider.dart';
import 'package:wuct/services/auth_service.dart';
import 'package:wuct/shared/custom_app_bar.dart';
import 'package:wuct/shared/notification_box.dart';
import 'package:wuct/shared/styled_text.dart';

// A simple provider to manage the loading state
final isLoadingProvider = StateProvider<bool>((ref) => false);

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      appBar: const CustomAppBar(label: "Notifications"),
      body: Stack(
        children: [
          authState.when(
            data: (user) {
              if (user?.notifications == null || user!.notifications.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 300),
                  child: Center(
                    child: StyledBodyText('No notifications available',
                        fontSize: 18),
                  ),
                );
              }
              return ListView.builder(
                itemCount: user.notifications.length,
                itemBuilder: (context, index) {
                  final notification = user.notifications[index];
                  return NotificationBox(
                    sender: notification.sender,
                    title: notification.title,
                    date:
                        DateFormat('yyyy-MM-dd').format(notification.timestamp),
                    message: notification.text,
                    containerColor:
                        notification.hasSeen ? Colors.grey[200]! : Colors.white,
                    onDismissed: () async {
                      //delete the notification
                      try {
                        ref.read(isLoadingProvider.notifier).state = true;
                        await AuthService.deleteNotification(user.uid, index);
                      } catch (err) {
                        print(err);
                      } finally {
                        ref.read(isLoadingProvider.notifier).state = false;
                      }
                    },
                    onPressed: () async {
                      try {
                        ref.read(isLoadingProvider.notifier).state = true;
                        final result =
                            await Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  NotificationFullscreen(
                                      notification: notification,
                                      userId: user.uid,
                                      index: index),
                        ));
                        //result returns array of bool with information of whether notification will be makred and deleted
                        bool notificationMarkedAs = result[0];
                        bool hasDeleted = result[1];

                        if (hasDeleted) {
                          await AuthService.deleteNotification(user.uid, index);
                          return;
                        }

                        if (notification.hasSeen != notificationMarkedAs) {
                          await AuthService.readNotification(
                              user.uid, index, notificationMarkedAs);
                        }
                      } catch (err) {
                        print(err);
                      } finally {
                        ref.read(isLoadingProvider.notifier).state = false;
                      }
                    },
                  );
                },
              );
            },
            loading: () => const Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            )),
            error: (error, stackTrace) =>
                Center(child: Text('Error loading user data: $error')),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                  color: Colors.blue), // Show loading indicator
            ),
        ],
      ),
    );
  }
}
