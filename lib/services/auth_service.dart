import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wuct/models/app_user.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _ref = FirebaseFirestore.instance;

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
        await _ref.collection('users').doc(user.uid).set({
          'email': user.email,
          'washuID': washuID,
          'admin': isAdmin,
        });
        return AppUser(
            uid: user.uid,
            email: user.email!,
            washuID: washuID,
            isAdmin: isAdmin);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message ?? 'An unknown error occurred.');
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      return;
    }
  }

//sign users in
  static Future<AppUser?> signIn(String email, String password) async {
    try {
      //signin on firebase auth
      final UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      final User? user = credential.user;

      if (user != null) {
        final DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _ref.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          final data = userDoc.data();
          if (data != null) {
            // Return AppUser with the retrieved data
            return AppUser(
              uid: user.uid,
              email: data['email'] ?? '', // Email from Firestore data
              washuID: data['washuID'] ?? '', // WashU ID from Firestore data
              isAdmin:
                  data['admin'] ?? false, // Admin status from Firestore data
            );
          }
        }
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message ?? 'An unknown error occurred.');
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
