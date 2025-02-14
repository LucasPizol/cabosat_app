import 'package:cabosat/models/notification_model.dart';
import 'package:cabosat/services/notifications/firestore_service.dart';
import 'package:cabosat/services/storage/sqflite_service.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  bool _isLoading = true;
  List<NotificationModel> _notifications = [];

  bool get isLoading => _isLoading;
  List<NotificationModel> get notifications => _notifications;

  Future<void> markAsRead(NotificationModel notification) async {
    try {
      notification.isRead = true;

      SqfliteService database = SqfliteService();

      await database.updateData("notification", notification.toJson());

      notifyListeners();
    } catch (e) {
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int getUnreadNotifications() {
    try {
      int unreadNotifications = _notifications
          .where((notification) => !notification.isRead)
          .toList()
          .length;

      return unreadNotifications;
    } catch (e) {
      return 0;
    }
  }

  void setNotifications(List<Map<String, dynamic>> notifications) {
    _notifications = List<NotificationModel>.from(notifications
        .where((notification) => (notification['isDeleted'] ?? 0) == 0)
        .map((json) => NotificationModel.fromJson({
              'id': json['id'],
              'title': json['title'],
              'body': json['body'],
              'recievedAt': DateTime.now().toIso8601String(),
              'isRead': json['isRead'] ?? 0,
              'isDeleted': json['isDeleted'] ?? 0
            })))
      ..sort((a, b) => b.recievedAt.compareTo(a.recievedAt));

    notifyListeners();
  }

  Future<void> loadNotifications(String topic) async {
    try {
      _isLoading = true;
      notifyListeners();

      SqfliteService sqfliteService = SqfliteService();

      List<Map<String, dynamic>> localNotifications =
          await sqfliteService.getData("notification");

      setNotifications(localNotifications);
      notifyListeners();

      FirestoreService database = FirestoreService();

      List<Map<String, dynamic>> notifications =
          await database.getNotifications(topic);

      List<dynamic> localIds = localNotifications.map((e) => e['id']).toList();

      List<Map<String, dynamic>> newNotifications = localNotifications.toList();

      for (Map<String, dynamic> notification in notifications) {
        if (localIds.contains(notification['id'])) {
          continue;
        }

        Map<String, dynamic> json = {
          'id': notification['id'],
          'title': notification['title'],
          'body': notification['body'],
          'recievedAt': DateTime.now().toIso8601String(),
          'isRead': 0,
          'isDeleted': 0
        };

        await sqfliteService.insertData("notification", json);

        newNotifications.add(json);
      }

      setNotifications(localNotifications);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadLocalNotifications() async {
    try {
      _isLoading = true;
      notifyListeners();

      SqfliteService database = SqfliteService();

      List<Map<String, dynamic>> notifications =
          await database.getData("notification");

      setNotifications(notifications);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeNotification(String id) async {
    try {
      SqfliteService database = SqfliteService();

      Map<String, dynamic> notification =
          (await database.getData("notification"))
              .firstWhere((notification) => notification['id'] == id);

      if (notification.isEmpty) {
        return;
      }

      await database.updateData("notification", {
        'id': notification['id'],
        'title': notification['title'],
        'body': notification['body'],
        'recievedAt': notification['recievedAt'],
        'isRead': 0,
        'isDeleted': 1
      });

      loadLocalNotifications();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }
}
