import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wuct/models/app_user.dart';

final authProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  return FirebaseAuth.instance.authStateChanges().asyncExpand((user) {
    if (user != null) {
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
          final List<String> fcmTokens = List<String>.from(data['fcmTokens'] ?? []);

          // Return an AppUser instance with additional data
          return AppUser(
            uid: user.uid,
            email: user.email!,
            washuID: washuID,
            isAdmin: isAdmin,
            fcmTokens: fcmTokens,  
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


/**
 * final authProvider = StreamProvider.autoDispose<AppUser?>((ref) async* {
  //subscribe to firebase auth changes
  final Stream<AppUser?> userStream =
      FirebaseAuth.instance.authStateChanges().asyncMap((user) async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        final washuID = data['washuID'];
        final isAdmin = data['admin'] ?? false;

        // Return an AppUser instance with additional data
        return AppUser(
            uid: user.uid,
            email: user.email!,
            washuID: washuID,
            isAdmin: isAdmin);
      } else {
        return null;
      }
    }
    return null;
  });
  //yield that value whenever it changes
  await for (final user in userStream) {
    yield user;
  }
});

 */