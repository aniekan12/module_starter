import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:obodo_module_starter/common/events/data_bus.dart';
import 'package:obodo_module_starter/common/events/events.dart';
import 'package:obodo_module_starter/common/io/interceptors/loggin_interceptor.dart';

import 'notification_factory.dart';

class NotificationDispatcher {
  NotificationDispatcher(
      {required FlutterLocalNotificationsPlugin plugin,
      this.parser = defaultMessageParser})
      : _plugin = plugin;

  factory NotificationDispatcher.createDispatcher(
      NotificationServiceConfig config) {
    final pl = FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings? androidInitSettings;
    DarwinInitializationSettings? iosInitSettings;
    final InitializationSettings notificationInitSettings;

    if (Platform.isAndroid) {
      final androidImplementation = pl.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final group = AndroidNotificationChannelGroup(
        config.groupChannelId,
        config.groupChannelName,
        description: config.groupChannelDescription,
      );

      androidImplementation?.deleteNotificationChannel(group.name);
      androidImplementation?.createNotificationChannelGroup(group);

      for (final info in config.channelInfo) {
        final notificationChannel = AndroidNotificationChannel(
          info.channelId,
          info.channelName,
          description: config.groupChannelDescription,
          importance: Importance.max,
          groupId: group.id,
        );
        androidImplementation?.createNotificationChannel(notificationChannel);
      }

      androidImplementation?.requestNotificationsPermission();

      androidInitSettings =
          AndroidInitializationSettings(config.notificationIcon);
    } else if (Platform.isIOS) {
      iosInitSettings = const DarwinInitializationSettings();
    }

    notificationInitSettings = InitializationSettings(
        android: androidInitSettings, iOS: iosInitSettings);

    final dispatcher = NotificationDispatcher(plugin: pl);

    pl.initialize(notificationInitSettings,
        onDidReceiveNotificationResponse:
            dispatcher.onReceiveForegroundNotification);

    return dispatcher;
  }

  final FlutterLocalNotificationsPlugin _plugin;
  RemoteMessageParser parser;

  void onReceiveForegroundNotification(NotificationResponse details) {
    final payload = details.payload;

    if (null == payload) return;

    try {
      final value = jsonDecode(payload) as Map<String, dynamic>;
      final event = NotificationEvent.fromJson(value);
      DataBus.getInstance().publish(event, strategy: PublishStrategy.last);
    } catch (e) {
      log.e(
        'Failed to convert $e',
      );
    }
    log.i('Received Notification Details => ${details.payload}');
  }

  Future<void> displayNotification(
      {required int id,
      required NotificationDetails details,
      String? title,
      String? description,
      String? body}) async {
    await _plugin.show(id, title, description, details, payload: body);
  }
}
