import 'dart:convert';

import 'package:cabosat/models/notification_model.dart';
import 'package:cabosat/services/local_storage_service.dart';
import 'package:cabosat/services/notification_service.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  bool _isLoading = true;
  List<NotificationModel> _notifications = [];

  bool get isLoading => _isLoading;
  List<NotificationModel> get notifications => _notifications;

  Future<void> markAsRead(NotificationModel notification) async {
    try {
      notification.isRead = true;

      List<dynamic> notifications =
          _notifications.map((notification) => notification.toJson()).toList();

      await LocalStorageService()
          .add('notifications', json.encode(notifications));

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

  Future<void> loadNotifications() async {
    try {
      _isLoading = true;
      notifyListeners();

      String? getNotifications =
          await LocalStorageService().get('notifications');

      if (getNotifications == null) {
        _isLoading = false;
        notifyListeners();

        return;
      }

      List<dynamic> decodedNotifications = json.decode(getNotifications);

      _notifications = List<NotificationModel>.from(decodedNotifications.map(
          (json) => NotificationModel.fromJson(json as Map<String, dynamic>)))
        ..sort((a, b) => b.recievedAt.compareTo(a.recievedAt));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeNotification(String id) async {
    try {
      await NotificationService.instance.removeNotification(id);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }
}
