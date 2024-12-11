import 'dart:convert';
import 'package:cabosat/firebase_options.dart';
import 'package:cabosat/provider/notification_provider.dart';
import 'package:cabosat/services/local_storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.instance.setupFlutterNotifications(message);
  await NotificationService.instance.showNotification(message);
  await NotificationService.instance.insertNotification(message);
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  NotificationProvider? _notificationProvider;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _requestPermission();
    await _setupMessageHandler();
  }

  void setNotificationProvider(NotificationProvider provider) {
    _notificationProvider = provider;
  }

  Future<bool> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<void> setupFlutterNotifications(RemoteMessage message) async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher_round');

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {});

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: "@mipmap/ic_launcher",
          ),
        ),
      );
    }
  }

  Future<void> _setupMessageHandler() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      insertNotification(message);
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      insertNotification(message);
      if (message.data["type"] == "chat") {
        showNotification(message);
      }
    });

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      insertNotification(initialMessage);
      if (initialMessage.data["type"] == "chat") {
        showNotification(initialMessage);
      }
    }
  }

  Future<void> insertNotification(RemoteMessage message) async {
    String? getNotifications = await LocalStorageService().get('notifications');

    if (getNotifications == null) {
      await LocalStorageService().add(
          'notifications',
          json.encode([
            {
              'title': message.notification?.title,
              'body': message.notification?.body,
              'recievedAt': DateTime.now().toIso8601String(),
              'id': message.messageId
            }
          ]));
      _notificationProvider?.loadNotifications();
      return;
    }

    List<dynamic> decodedNotifications = json.decode(getNotifications);

    if (decodedNotifications
        .any((notification) => notification['id'] == message.messageId)) {
      return;
    }

    decodedNotifications.add({
      'title': message.notification?.title,
      'body': message.notification?.body,
      'recievedAt': DateTime.now().toIso8601String(),
      'id': message.messageId
    });

    await LocalStorageService()
        .add('notifications', json.encode(decodedNotifications));

    _notificationProvider?.loadNotifications();
  }

  Future<void> removeNotification(String id) async {
    String? getNotifications = await LocalStorageService().get('notifications');

    if (getNotifications == null) {
      return;
    }

    List<dynamic> decodedNotifications = json.decode(getNotifications);

    decodedNotifications
        .removeWhere((notification) => notification['id'] == id);

    await LocalStorageService()
        .add('notifications', json.encode(decodedNotifications));

    _notificationProvider?.loadNotifications();
  }
}
