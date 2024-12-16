import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wuct/pages/loading.dart';
import 'package:wuct/providers/auth_provider.dart';
import 'package:wuct/services/auth_service.dart';
import 'package:wuct/shared/custom_app_bar.dart';
import 'package:wuct/shared/notification_box.dart';

// class NotificationsPage extends ConsumerStatefulWidget {
//   const NotificationsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
//     return Scaffold(
//       appBar: CustomAppBar(label: "Notifications"),
//       body: Column(
//         children: [
//           // Text(message.notification!.title.toString()),
//           // Text(message.notification!.body.toString()),
//           // Text(message.data.toString())
//         ],
//       ),
//     );
//   }
// }

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    return Scaffold(
        appBar: const CustomAppBar(label: "Notifications"),
        body: authState.when(
          data: (user) {
            if (user?.notifications == null || user!.notifications.isEmpty) {
              return const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 300),
                child: Center(
                  child: Text(
                    'No notifications available',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: user.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = user.notifications[index];
                      return NotificationBox(
                        sender: notification.sender,
                        title: notification.title,
                        date: DateFormat('yyyy-MM-dd').format(notification.timestamp),
                        message: notification.text,
                        onDismissed: () async {
                          try {
                            await AuthService().deleteNotification(user.uid, index);
                          } catch (err) {
                            print(err);
                          }
                        },
                        onPressed: () async {
                          try {
                            await AuthService().readNotification(user.uid, index);
                          } catch (err) {
                            print(err);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: Loading()),
          error: (error, stackTrace) =>
              Center(child: Text('Error loading user data: $error')),
        ));
  }
}
