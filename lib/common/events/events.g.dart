// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationEvent _$NotificationEventFromJson(Map<String, dynamic> json) =>
    NotificationEvent(
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      channelInfo: NotificationChannelInfo.fromJson(
          json['channelInfo'] as Map<String, dynamic>),
      notificationId: json['notificationId'] as int? ?? 0,
      messageType: json['messageType'] as String?,
      deepLink: json['deeplink'] as String?,
      imageUrl: json['imageUrl'] as String?,
      requiresAuthentication: json['requiresAuthentication'] as bool? ?? false,
      entityId: json['entityId'] as int?,
      timestamp: json['timestamp'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      notification: json['notification'] == null
          ? null
          : NotificationInfo.fromJson(
              json['notification'] as Map<String, dynamic>),
      subTitle: json['subTitle'] as String?,
      priority: $enumDecodeNullable(_$PriorityEnumMap, json['priority']) ??
          Priority.high,
    );

Map<String, dynamic> _$NotificationEventToJson(NotificationEvent instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'messageType': instance.messageType,
      'channelInfo': instance.channelInfo,
      'deeplink': instance.deepLink,
      'imageUrl': instance.imageUrl,
      'requiresAuthentication': instance.requiresAuthentication,
      'entityId': instance.entityId,
      'timestamp': instance.timestamp,
      'title': instance.title,
      'description': instance.description,
      'subTitle': instance.subTitle,
      'priority': _$PriorityEnumMap[instance.priority]!,
      'data': instance.data,
      'notification': instance.notification,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.foreground: 'foreground',
  NotificationType.background: 'background',
};

const _$PriorityEnumMap = {
  Priority.min: 'min',
  Priority.low: 'low',
  Priority.defaultPriority: 'defaultPriority',
  Priority.high: 'high',
  Priority.max: 'max',
};
