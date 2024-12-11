class NotificationModel {
  final String title;
  final String body;
  final DateTime recievedAt;
  final String id;
  bool isRead;

  NotificationModel({
    required this.title,
    required this.body,
    required this.recievedAt,
    required this.id,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      body: json['body'],
      recievedAt: json['recievedAt'] != null
          ? DateTime.parse(json['recievedAt'])
          : DateTime.now(),
      id: json['id'],
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'recievedAt': recievedAt.toIso8601String(),
      'id': id,
      'isRead': isRead,
    };
  }
}
