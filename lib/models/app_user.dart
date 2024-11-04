import 'package:flutter/material.dart';

class AppUser {
  AppUser(
      {required this.uid,
      required this.email,
      required this.washuID,
      required this.isAdmin,
      required this.fcmTokens,
      this.individualID = "",
      this.teamID = "",
      this.topicsID = "",
      this.notifications = const [],
      });

  final String teamID;
  final String topicsID;
  final String individualID;
  final String uid;
  final String email;
  final String washuID;
  final bool isAdmin;
  final List<String> fcmTokens;
  final List<Notification> notifications;
}
