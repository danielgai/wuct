import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wuct/models/app_user.dart';
import 'package:wuct/models/wuct_notification.dart';

final authProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  return FirebaseAuth.instance.authStateChanges().asyncExpand((user) {
    if (user != null) {
      if (!user.emailVerified) {
        // Skip unverified users
        return Stream.value(null);
      }

      // Listen to changes in the Firestore user document
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .map((doc) {
        if (doc.exists) {
          final data = doc.data()!;
          final washuID = data['washuID'] ?? '';
          final isAdmin = data['admin'] ?? false;

          // Safely cast the fcmTokens to List<String>
          final List<String> fcmTokens =
              List<String>.from(data['fcmTokens'] ?? []);
          List<WUCTNotification> notifications = (data['notifications']
                      as List?)
                  ?.map((item) =>
                      WUCTNotification.fromMap(item as Map<String, dynamic>))
                  .toList() ??
              [];
          // Return an AppUser instance with additional data
          return AppUser(
            uid: user.uid,
            email: user.email!,
            washuID: washuID,
            isAdmin: isAdmin,
            fcmTokens: fcmTokens,
            individualID: data['individualID'] ?? '',
            teamID: data['teamID'] ?? '',
            topicsID: data['topicsID'] ?? '',
            notifications: notifications,
            scheduleImageURL: data['scheduleImageURL'] ?? '',
          );
        } else {
          // Document doesn't exist yet
          return null;
        }
      });
    } else {
      // User is not authenticated
      return Stream.value(null);
    }
  });
});
