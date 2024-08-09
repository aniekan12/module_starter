import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:obodo_module_starter/common/io/interceptors/loggin_interceptor.dart';

class NotificationDispatcher {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log.d(message.toString());
      _handleNotificationClick(message);
    });
    _initializeLocalNotifications();
  }

  void _showNotification(RemoteMessage message) {
    // Customize this method according to your needs
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'obodo_notification_channel_id',
        'obodo_channel',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );
      var platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platformChannelSpecifics,
      );
    }
  }

  // Method to handle background messages
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    log.d("Handling a background message: ${message.messageId}");
    // You can also show notifications here if necessary
  }

  // Method to handle notification clicks
  void _handleNotificationClick(RemoteMessage message) {
    log.d("Notification clicked!");
    final notificationData = message.data;
    debugPrint(notificationData.toString());
  }

  // Method to initialize local notifications
  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Method to get the device token
  Future<String?> getDeviceToken() async {
    return await _firebaseMessaging.getToken();
  }
}
