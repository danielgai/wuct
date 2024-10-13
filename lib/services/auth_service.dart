import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wuct/models/app_user.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _ref = FirebaseFirestore.instance;
  static Future<AppUser?> signup(String email, String password, String washuID,
      {bool isAdmin = false}) async {
    try {
      //signup on firebase auth
      final UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      //singup on firebase cloud database
      final User? user = credential.user;
      if (user != null) {
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
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
