import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wuct/models/app_user.dart';
import 'package:wuct/providers/auth_provider.dart';
import 'package:wuct/services/notification_service.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _ref = FirebaseFirestore.instance;
  // static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static Future<AppUser?> signUp(String email, String password, String washuID,
      {bool isAdmin = false}) async {
    try {
      //signup on firebase auth
      final UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      //singup on firebase cloud database
      final User? user = credential.user;
      if (user != null) {
        final washuIDExists = await _ref
            .collection('users')
            .where('washuID', isEqualTo: washuID)
            .get();

        if (washuIDExists.docs.isNotEmpty) {
          return Future.error('WashU ID already exists.');
        }
        final String? fcmToken =
            await NotificationService().initNotifications();
        await _ref.collection('users').doc(user.uid).set({
          'email': user.email,
          'washuID': washuID,
          'admin': isAdmin,
          'fcmTokens': [fcmToken]
        });
        return AppUser(
            uid: user.uid,
            email: user.email!,
            washuID: washuID,
            isAdmin: isAdmin,
            fcmTokens: [fcmToken!]);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message ?? 'An unknown error occurred.');
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // static Future<void> signOut() async {
  //   try {
  //     await _firebaseAuth.signOut();
  //   } catch (e) {
  //     return;
  //   }
  // }

  static Future<void> signOut(WidgetRef ref) async {
    try {
      await _firebaseAuth.signOut();
      // Invalidate the authProvider to refresh the UI
      ref.invalidate(authProvider);
    } catch (e) {
      return;
    }
  }

//sign users in
  static Future<AppUser?> signIn(String email, String password) async {
    try {
      // Sign in on Firebase Auth
      final UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      final User? user = credential.user;

      if (user != null) {
        // Fetch the user document from Firestore
        final DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _ref.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          final data = userDoc.data();
          if (data != null) {
            // Retrieve the FCM token for this device
            final String? fcmToken =
                await NotificationService().initNotifications();

            // Retrieve the existing FCM tokens from Firestore
            List<String> fcmTokens = List<String>.from(data['fcmTokens'] ?? []);

            // If the new FCM token is not in the list, add it to Firestore
            if (fcmToken != null && !fcmTokens.contains(fcmToken)) {
              // Add the new token to Firestore
              await _ref.collection('users').doc(user.uid).update({
                'fcmTokens': FieldValue.arrayUnion([fcmToken])
              });
              // Add the new token locally to return the correct AppUser object
              fcmTokens.add(fcmToken);
            }

            // Return AppUser with the updated FCM tokens
            return AppUser(
                uid: user.uid,
                email: data['email'] ?? '', // Email from Firestore data
                washuID: data['washuID'] ?? '', // WashU ID from Firestore data
                isAdmin:
                    data['admin'] ?? false, // Admin status from Firestore data
                fcmTokens:
                    fcmTokens); // Updated FCM tokens list including the new token
          }
        }
      }
      return null;
    } on FirebaseAuthException catch (e) {
      // Overriding this message since it's confusing for users
      if (e.message ==
          "The supplied auth credential is malformed or has expired.") {
        return Future.error('Invalid login credentials');
      }
      return Future.error(e.message ?? 'An unknown error occurred.');
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
