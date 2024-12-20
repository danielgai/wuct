import 'package:wuct/models/wuct_notification.dart';

class AppUser {
  AppUser({
    required this.uid,
    required this.email,
    required this.washuID,
    required this.isAdmin,
    required this.fcmTokens,
    this.individualID = "",
    this.teamID = "",
    this.topicsID = "",
    this.notifications = const [],
    this.scheduleImageURL = "",
  });

  final String teamID;
  final String topicsID;
  final String individualID;
  final String uid;
  final String email;
  final String washuID;
  final bool isAdmin;
  final List<String> fcmTokens;
  final List<WUCTNotification> notifications;
  final String scheduleImageURL;

  @override
  String toString() {
    return 'AppUser(teamID: $teamID, topicsID: $topicsID, individualID: $individualID, uid: $uid, email: $email, washuID: $washuID, isAdmin: $isAdmin, fcmTokens: $fcmTokens, notifications: $notifications, scheduleImageURL: $scheduleImageURL)';
  }
}
