import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:obodo_module_starter/common/messaging/notification_factory.dart';

part 'events.g.dart';

const _eventsEmailKey = 'email';
const _eventsDeviceIdKey = 'device_id';
const _eventsExternalDeviceIdKey = 'external_device_id';
const _eventsDeviceTypeKey = 'device_type';
const _eventsPhoneNumber = 'phone_number';
const _eventsAppDomain = 'app_domain';
const _eventsUsername = 'user_name';
const _eventsAppVersion = 'app_version';
const _eventsPlatform = 'platform';
const _eventsEnvironment = 'app_env';
const _eventsUserType = 'user_type';
const _eventsFirstName = 'first_name';
const _eventsLastName = 'last_name';

abstract class DataEvent {
  const DataEvent({this.eventName = ''});
  final String eventName;

  Future<Map<String, dynamic>> getEventData() async {
    return {};
  }
}

/// Application Specific Events
sealed class ApplicationEvent extends DataEvent {
  const ApplicationEvent();
}

class UpdateBalanceEvent extends ApplicationEvent {
  UpdateBalanceEvent({this.entityId});

  final int? entityId;
}

class BalanceUpdatedEvent extends ApplicationEvent {}

class DashboardRefreshedEvent extends ApplicationEvent {}

class UpdateBusinessListEvent extends ApplicationEvent {}

class UpdateHiddenBusinessListEvent extends ApplicationEvent {}

class HideBalanceUpdatedEvent extends ApplicationEvent {
  HideBalanceUpdatedEvent({required this.newState});

  final bool newState;
}

class ChangeBusinessEvent extends ApplicationEvent {}

class CheckDeviceRegistrationEvent extends ApplicationEvent {}

/// Notification type
enum NotificationType { foreground, background }

@JsonSerializable()
class NotificationEvent extends ApplicationEvent {
  NotificationEvent(
      {required this.type,
      required this.channelInfo,
      this.notificationId = 0,
      this.messageType,
      this.deepLink,
      this.imageUrl,
      this.requiresAuthentication = false,
      this.entityId,
      this.timestamp,
      this.title,
      this.description,
      this.data,
      this.notification,
      this.subTitle,
      this.priority = Priority.high});

  factory NotificationEvent.fromJson(Map<String, dynamic> data) =>
      _$NotificationEventFromJson(data);

  final int notificationId;
  final NotificationType type;
  final String? messageType;
  final NotificationChannelInfo channelInfo;
  @JsonKey(name: 'deeplink')
  final String? deepLink;
  final String? imageUrl;
  final bool requiresAuthentication;
  final int? entityId; //could be the customer or merchant
  final int? timestamp;
  final String? title;
  final String? description;
  final String? subTitle;
  final Priority priority;
  final Map<String, dynamic>? data;
  final NotificationInfo? notification;

  Map<String, dynamic> toJson() => _$NotificationEventToJson(this);
}
