class NotificationModel {
  final String title;
  final String body;
  final DateTime recievedAt;
  final String id;
  bool isRead;
  bool isDeleted;

  NotificationModel({
    required this.title,
    required this.body,
    required this.recievedAt,
    required this.id,
    required this.isRead,
    required this.isDeleted,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      body: json['body'],
      recievedAt: json['recievedAt'] != null
          ? DateTime.parse(json['recievedAt'])
          : DateTime.now(),
      id: json['id'],
      isRead: json['isRead'] == 1,
      isDeleted: json['isDeleted'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'recievedAt': recievedAt.toIso8601String(),
      'id': id,
      'isRead': isRead ? 1 : 0,
      'isDeleted': isDeleted ? 1 : 0,
    };
  }
}
