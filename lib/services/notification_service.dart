import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wuct/main.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  Future<String?> initNotifications() async {
    print('hi');
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
}
