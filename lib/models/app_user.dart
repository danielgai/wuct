class AppUser {
  AppUser(
      {required this.uid,
      required this.email,
      required this.washuID,
      required this.isAdmin,
      required this.fcmTokens});

  final String uid;
  final String email;
  final String washuID;
  final bool isAdmin;
  final List<String> fcmTokens;
}
