import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:wuct/main.dart';
import 'package:wuct/models/app_user.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  Future<String?> initNotifications() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final fcmToken = await _firebaseMessaging.getToken();
    print(fcmToken); // Log the FCM token for debugging
    return fcmToken;
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState?.pushNamed('/notifications', arguments: message);
  }

  Future initPushNotifications() async {
    //handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    //attach event listeers for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  Future<void> sendNotificationToPhone(
      AppUser sender, String title, String text) async {
    try {
      String formattedTimestamp = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final Map<String, dynamic> payload = {
        'title': title,
        'message': text,
        'timestamp': formattedTimestamp,
        'sender': sender.email, // Ensure sender has an email property
      };

      const String cloudFunctionUrl =
          "https://us-central1-wuct-f27b5.cloudfunctions.net/sendAnnouncementNotification";

      final response = await http.post(
        Uri.parse(cloudFunctionUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      // Handle the response
      if (response.statusCode == 200) {
        print('Notification sent successfully: ${response.body}');
      } else {
        print(
            'Failed to send notification: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      print(error);
    } finally {}
  }
}
