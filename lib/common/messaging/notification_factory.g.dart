// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'notification_factory.dart';

// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************

// NotificationChannelInfo _$NotificationChannelInfoFromJson(
//         Map<String, dynamic> json) =>
//     NotificationChannelInfo(
//       channelId: json['channelId'] as String,
//       channelName: json['channelName'] as String,
//       description: json['description'] as String,
//       groupKey: json['groupKey'] as String?,
//       importance:
//           $enumDecodeNullable(_$ImportanceEnumMap, json['importance']) ??
//               Importance.max,
//     );

// Map<String, dynamic> _$NotificationChannelInfoToJson(
//         NotificationChannelInfo instance) =>
//     <String, dynamic>{
//       'channelId': instance.channelId,
//       'channelName': instance.channelName,
//       'description': instance.description,
//       'groupKey': instance.groupKey,
//       'importance': _$ImportanceEnumMap[instance.importance]!,
//     };

// const _$ImportanceEnumMap = {
//   Importance.unspecified: 'unspecified',
//   Importance.none: 'none',
//   Importance.min: 'min',
//   Importance.low: 'low',
//   Importance.defaultImportance: 'defaultImportance',
//   Importance.high: 'high',
//   Importance.max: 'max',
// };

// _$NotificationInfoImpl _$$NotificationInfoImplFromJson(
//         Map<String, dynamic> json) =>
//     _$NotificationInfoImpl(
//       title: json['title'] as String?,
//       body: json['body'] as String?,
//       android: json['android'] == null
//           ? null
//           : AndroidNotificationInfo.fromJson(
//               json['android'] as Map<String, dynamic>),
//       apple: json['apple'] == null
//           ? null
//           : AppleNotificationInfo.fromJson(
//               json['apple'] as Map<String, dynamic>),
//     );

// Map<String, dynamic> _$$NotificationInfoImplToJson(
//         _$NotificationInfoImpl instance) =>
//     <String, dynamic>{
//       'title': instance.title,
//       'body': instance.body,
//       'android': instance.android,
//       'apple': instance.apple,
//     };

// _$AppleNotificationInfoImpl _$$AppleNotificationInfoImplFromJson(
//         Map<String, dynamic> json) =>
//     _$AppleNotificationInfoImpl(
//       badge: json['badge'] as String?,
//       subtitle: json['subtitle'] as String?,
//       imageUrl: json['imageUrl'] as String?,
//     );

// Map<String, dynamic> _$$AppleNotificationInfoImplToJson(
//         _$AppleNotificationInfoImpl instance) =>
//     <String, dynamic>{
//       'badge': instance.badge,
//       'subtitle': instance.subtitle,
//       'imageUrl': instance.imageUrl,
//     };

// _$AndroidNotificationInfoImpl _$$AndroidNotificationInfoImplFromJson(
//         Map<String, dynamic> json) =>
//     _$AndroidNotificationInfoImpl(
//       count: json['count'] as int?,
//       imageUrl: json['imageUrl'] as String?,
//     );

// Map<String, dynamic> _$$AndroidNotificationInfoImplToJson(
//         _$AndroidNotificationInfoImpl instance) =>
//     <String, dynamic>{
//       'count': instance.count,
//       'imageUrl': instance.imageUrl,
//     };
