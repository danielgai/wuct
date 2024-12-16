class WUCTNotification {
  WUCTNotification({
    required this.title,
    required this.text,
    required this.timestamp,
    required this.sender,
    this.hasSeen = false,
  });

  final DateTime timestamp;
  final String sender;
  final String title;
  final String text;
  bool hasSeen;

  factory WUCTNotification.fromMap(Map<String, dynamic> map) {
    return WUCTNotification(
      title: map['title'] ?? '',
      text: map['text'] ?? '',
      timestamp:
          DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      sender: map['sender'] ?? '',
      hasSeen: map['hasSeen'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'sender': sender,
      'hasSeen': hasSeen,
    };
  }

  @override
  String toString() {
    return 'WUCTNotification(title: $title, text: $text, timestamp: $timestamp, sender: $sender, hasSeen: $hasSeen)';
  }
}
