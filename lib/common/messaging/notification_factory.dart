import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obodo_module_starter/common/events/events.dart';
import 'package:obodo_module_starter/common/messaging/notification_dispatcher.dart';
import 'firebase_notification_service.dart';

part 'notification_factory.freezed.dart';

part 'notification_factory.g.dart';

typedef RemoteMessageParser = NotificationEvent Function(
    RemoteMessage message, NotificationType type);

enum NotificationServiceType { firebase }

abstract class NotificationService {
  void registerForegroundNotificationHandler(
      String messageType, NotificationHandler handler);

  void registerBackgroundNotificationHandler(
      Future<void> Function(RemoteMessage) handler);

  void setRemoteMessageParser(RemoteMessageParser parser);

  RemoteMessageParser getMessageParser();
}

///
/// NotificationServiceFactory, builds and configure a NotificationService
///
class NotificationServiceFactory {
  static NotificationService createNotificationService(
      NotificationServiceConfig config) {
    if (NotificationServiceType.firebase == config.type) {
      final dispatcher = NotificationDispatcher.createDispatcher(config);
      return FirebaseService()..configure(config, dispatcher);
    }
    throw Exception('UnSupported Notification Service Type');
  }
}

///
/// Data class to configure the notification settings
///
@freezed
class NotificationServiceConfig with _$NotificationServiceConfig {
  factory NotificationServiceConfig(
          {required NotificationServiceType type,
          // required String tokenUpdateBaseUrl,
          required String groupChannelId,
          required String groupChannelName,
          required String groupChannelDescription,
          FirebaseOptions? firebaseOptions,
          @Default('@mipmap/ic_launcher') String notificationIcon,
          @Default([]) List<NotificationChannelInfo> channelInfo}) =
      _NotificationServiceConfig;
}

///
///
@JsonSerializable()
class NotificationChannelInfo {
  NotificationChannelInfo(
      {required this.channelId,
      required this.channelName,
      required this.description,
      this.groupKey,
      this.importance = Importance.max});

  factory NotificationChannelInfo.fromJson(Map<String, dynamic> data) =>
      _$NotificationChannelInfoFromJson(data);

  final String channelId;
  final String channelName;
  final String description;
  final String? groupKey;
  final Importance importance;

  Map<String, dynamic> toJson() => _$NotificationChannelInfoToJson(this);
}

///
///
@freezed
class NotificationInfo with _$NotificationInfo {
  const factory NotificationInfo({
    String? title,
    String? body,
    AndroidNotificationInfo? android,
    AppleNotificationInfo? apple,
  }) = _NotificationInfo;

  factory NotificationInfo.fromJson(Map<String, dynamic> data) =>
      _$NotificationInfoFromJson(data);
}

@freezed
class AppleNotificationInfo with _$AppleNotificationInfo {
  const factory AppleNotificationInfo({
    String? badge,
    String? subtitle,
    String? imageUrl,
  }) = _AppleNotificationInfo;

  factory AppleNotificationInfo.fromJson(Map<String, dynamic> json) =>
      _$AppleNotificationInfoFromJson(json);
}

@freezed
class AndroidNotificationInfo with _$AndroidNotificationInfo {
  const factory AndroidNotificationInfo({
    int? count,
    String? imageUrl,
  }) = _AndroidNotificationInfo;

  factory AndroidNotificationInfo.fromJson(Map<String, dynamic> json) =>
      _$AndroidNotificationInfoFromJson(json);
}

abstract class NotificationHandler {
  NotificationHandler({required this.dispatcher});

  final NotificationDispatcher dispatcher;

  Future<bool> notify(NotificationEvent event);
}

///
/// A Default Handler that handles all type of messages
///
class DefaultNotificationHandler extends NotificationHandler {
  DefaultNotificationHandler(NotificationDispatcher dispatcher)
      : super(dispatcher: dispatcher);

  @override
  Future<bool> notify(NotificationEvent event) async {
    // if (event.type == NotificationType.foreground) {
    //   DataBus.getInstance().publish(event);
    //   return true;
    // }

    if (event.title == null &&
        event.description == null &&
        event.subTitle == null) {
      return false;
    }

    AndroidNotificationDetails? androidSpecifics;
    DarwinNotificationDetails? iosSpecifics;

    if (Platform.isAndroid) {
      final bigPicture = BigPictureStyleInformation(
        FilePathAndroidBitmap(event.imageUrl ?? ''),
        summaryText: event.subTitle ?? event.description ?? '',
        contentTitle: event.title,
        largeIcon: FilePathAndroidBitmap(event.imageUrl ?? ''),
      );
      androidSpecifics = AndroidNotificationDetails(
          event.channelInfo.channelId, event.channelInfo.channelName,
          groupKey: event.channelInfo.groupKey,
          importance: event.channelInfo.importance,
          priority: event.priority,
          number: event.notification?.android?.count ?? 0,
          styleInformation: bigPicture);
    } else if (Platform.isIOS) {
      final badgeCount =
          int.tryParse(event.notification?.apple?.badge ?? '') ?? 0;
      iosSpecifics = DarwinNotificationDetails(
          presentAlert: true,
          badgeNumber: badgeCount,
          subtitle: event.description,
          interruptionLevel: InterruptionLevel.critical);
    }

    final platformSpecifics =
        NotificationDetails(android: androidSpecifics, iOS: iosSpecifics);
    await dispatcher.displayNotification(
        id: event.notificationId,
        details: platformSpecifics,
        title: event.title,
        description: event.description,
        body: jsonEncode(event.toJson()));
    return true;
  }
}

///
/// A Default Message Parser, Parses firebase messages
///
NotificationEvent defaultMessageParser(RemoteMessage message,
    [NotificationType type = NotificationType.foreground]) {
  return NotificationEvent(
      type: type,
      channelInfo: NotificationChannelInfo(
          channelId: 'channelId',
          channelName: 'channelName',
          description: 'description'));
}
