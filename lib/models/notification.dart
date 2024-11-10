class Notification {
  Notification({required this.title, required this.text, required this.timestamp, required this.sender});

  final DateTime timestamp;
  final String sender;
  final String title;
  final String text;
}