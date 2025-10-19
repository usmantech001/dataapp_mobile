class AppNotification {
  final String title;
  final String message;
  bool read;
  final String date;
  final String time;
  final String id;

  AppNotification({
    required this.title,
    required this.message,
    required this.read,
    required this.date,
    required this.time,
    required this.id,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      title: map["title"],
      message: map["message"],
      read: map["read"],
      date: map["date"],
      time: map["time"],
      id: map["id"],
    );
  }
}
