class AppUser {
  AppUser(
      {required this.uid,
      required this.email,
      required this.washuID,
      required this.isAdmin});

  final String uid;
  final String email;
  final String washuID;
  final bool isAdmin;
}
