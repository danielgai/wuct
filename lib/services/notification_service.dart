import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:wuct/main.dart';
import 'package:wuct/models/app_user.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  Future<String?> initNotifications() async {
    await _firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true);
    final fcmToken = await _firebaseMessaging.getToken();
    return fcmToken;
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState?.pushNamed('/notifications', arguments: message);
  }

  Future<void> initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  Future<void> sendNotificationToPhone(
      AppUser sender, String title, String text) async {
    try {
      final String? idToken =
          await FirebaseAuth.instance.currentUser?.getIdToken();
      if (idToken == null) {
        throw Exception("User is not authenticated.");
      }

      if (!sender.isAdmin) {
        throw Exception("User does not have permission to send notifications.");
      }

      String formattedTimestamp =
          DateFormat('yyyy-MM-dd').format(DateTime.now());

      final Map<String, dynamic> payload = {
        'title': title,
        'message': text,
        'timestamp': formattedTimestamp,
      };

      const String cloudFunctionUrl =
          "https://us-central1-wuct-f27b5.cloudfunctions.net/sendAnnouncementNotification";

      final response = await http.post(
        Uri.parse(cloudFunctionUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception(
            "Failed to send notification: ${response.statusCode} - ${response.body}");
      }

      print('Notification sent successfully: ${response.body}');
    } catch (error) {
      print('Error sending notification: $error');
      throw Exception(error
          .toString()
          .replaceAll("Exception: ", "")); // ✅ Removes 'Exception: ' prefix
    }
  }
}
