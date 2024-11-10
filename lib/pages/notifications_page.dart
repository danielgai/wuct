import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wuct/pages/loading.dart';
import 'package:wuct/providers/auth_provider.dart';
import 'package:wuct/shared/custom_app_bar.dart';

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
        appBar: CustomAppBar(label: "Notifications"),
        body: authState.when(
          data: (user) {
            const Column(
              children: [
                // Text(message.notification!.title.toString()),
                // Text(message.notification!.body.toString()),
                // Text(message.data.toString())
              ],
            );
            return null;
          },
          loading: () => const Center(child: Loading()),
          error: (error, stackTrace) =>
              Center(child: Text('Error loading user data: $error')),
        ));
  }
}
