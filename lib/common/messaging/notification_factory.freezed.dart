// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_factory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NotificationServiceConfig {
  NotificationServiceType get type =>
      throw _privateConstructorUsedError; // required String tokenUpdateBaseUrl,
  String get groupChannelId => throw _privateConstructorUsedError;
  String get groupChannelName => throw _privateConstructorUsedError;
  String get groupChannelDescription => throw _privateConstructorUsedError;
  FirebaseOptions? get firebaseOptions => throw _privateConstructorUsedError;
  String get notificationIcon => throw _privateConstructorUsedError;
  List<NotificationChannelInfo> get channelInfo =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotificationServiceConfigCopyWith<NotificationServiceConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationServiceConfigCopyWith<$Res> {
  factory $NotificationServiceConfigCopyWith(NotificationServiceConfig value,
          $Res Function(NotificationServiceConfig) then) =
      _$NotificationServiceConfigCopyWithImpl<$Res, NotificationServiceConfig>;
  @useResult
  $Res call(
      {NotificationServiceType type,
      String groupChannelId,
      String groupChannelName,
      String groupChannelDescription,
      FirebaseOptions? firebaseOptions,
      String notificationIcon,
      List<NotificationChannelInfo> channelInfo});
}

/// @nodoc
class _$NotificationServiceConfigCopyWithImpl<$Res,
        $Val extends NotificationServiceConfig>
    implements $NotificationServiceConfigCopyWith<$Res> {
  _$NotificationServiceConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? groupChannelId = null,
    Object? groupChannelName = null,
    Object? groupChannelDescription = null,
    Object? firebaseOptions = freezed,
    Object? notificationIcon = null,
    Object? channelInfo = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationServiceType,
      groupChannelId: null == groupChannelId
          ? _value.groupChannelId
          : groupChannelId // ignore: cast_nullable_to_non_nullable
              as String,
      groupChannelName: null == groupChannelName
          ? _value.groupChannelName
          : groupChannelName // ignore: cast_nullable_to_non_nullable
              as String,
      groupChannelDescription: null == groupChannelDescription
          ? _value.groupChannelDescription
          : groupChannelDescription // ignore: cast_nullable_to_non_nullable
              as String,
      firebaseOptions: freezed == firebaseOptions
          ? _value.firebaseOptions
          : firebaseOptions // ignore: cast_nullable_to_non_nullable
              as FirebaseOptions?,
      notificationIcon: null == notificationIcon
          ? _value.notificationIcon
          : notificationIcon // ignore: cast_nullable_to_non_nullable
              as String,
      channelInfo: null == channelInfo
          ? _value.channelInfo
          : channelInfo // ignore: cast_nullable_to_non_nullable
              as List<NotificationChannelInfo>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationServiceConfigImplCopyWith<$Res>
    implements $NotificationServiceConfigCopyWith<$Res> {
  factory _$$NotificationServiceConfigImplCopyWith(
          _$NotificationServiceConfigImpl value,
          $Res Function(_$NotificationServiceConfigImpl) then) =
      __$$NotificationServiceConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {NotificationServiceType type,
      String groupChannelId,
      String groupChannelName,
      String groupChannelDescription,
      FirebaseOptions? firebaseOptions,
      String notificationIcon,
      List<NotificationChannelInfo> channelInfo});
}

/// @nodoc
class __$$NotificationServiceConfigImplCopyWithImpl<$Res>
    extends _$NotificationServiceConfigCopyWithImpl<$Res,
        _$NotificationServiceConfigImpl>
    implements _$$NotificationServiceConfigImplCopyWith<$Res> {
  __$$NotificationServiceConfigImplCopyWithImpl(
      _$NotificationServiceConfigImpl _value,
      $Res Function(_$NotificationServiceConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? groupChannelId = null,
    Object? groupChannelName = null,
    Object? groupChannelDescription = null,
    Object? firebaseOptions = freezed,
    Object? notificationIcon = null,
    Object? channelInfo = null,
  }) {
    return _then(_$NotificationServiceConfigImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationServiceType,
      groupChannelId: null == groupChannelId
          ? _value.groupChannelId
          : groupChannelId // ignore: cast_nullable_to_non_nullable
              as String,
      groupChannelName: null == groupChannelName
          ? _value.groupChannelName
          : groupChannelName // ignore: cast_nullable_to_non_nullable
              as String,
      groupChannelDescription: null == groupChannelDescription
          ? _value.groupChannelDescription
          : groupChannelDescription // ignore: cast_nullable_to_non_nullable
              as String,
      firebaseOptions: freezed == firebaseOptions
          ? _value.firebaseOptions
          : firebaseOptions // ignore: cast_nullable_to_non_nullable
              as FirebaseOptions?,
      notificationIcon: null == notificationIcon
          ? _value.notificationIcon
          : notificationIcon // ignore: cast_nullable_to_non_nullable
              as String,
      channelInfo: null == channelInfo
          ? _value._channelInfo
          : channelInfo // ignore: cast_nullable_to_non_nullable
              as List<NotificationChannelInfo>,
    ));
  }
}

/// @nodoc

class _$NotificationServiceConfigImpl implements _NotificationServiceConfig {
  _$NotificationServiceConfigImpl(
      {required this.type,
      required this.groupChannelId,
      required this.groupChannelName,
      required this.groupChannelDescription,
      this.firebaseOptions,
      this.notificationIcon = '@mipmap/ic_launcher',
      final List<NotificationChannelInfo> channelInfo = const []})
      : _channelInfo = channelInfo;

  @override
  final NotificationServiceType type;
// required String tokenUpdateBaseUrl,
  @override
  final String groupChannelId;
  @override
  final String groupChannelName;
  @override
  final String groupChannelDescription;
  @override
  final FirebaseOptions? firebaseOptions;
  @override
  @JsonKey()
  final String notificationIcon;
  final List<NotificationChannelInfo> _channelInfo;
  @override
  @JsonKey()
  List<NotificationChannelInfo> get channelInfo {
    if (_channelInfo is EqualUnmodifiableListView) return _channelInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_channelInfo);
  }

  @override
  String toString() {
    return 'NotificationServiceConfig(type: $type, groupChannelId: $groupChannelId, groupChannelName: $groupChannelName, groupChannelDescription: $groupChannelDescription, firebaseOptions: $firebaseOptions, notificationIcon: $notificationIcon, channelInfo: $channelInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationServiceConfigImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.groupChannelId, groupChannelId) ||
                other.groupChannelId == groupChannelId) &&
            (identical(other.groupChannelName, groupChannelName) ||
                other.groupChannelName == groupChannelName) &&
            (identical(
                    other.groupChannelDescription, groupChannelDescription) ||
                other.groupChannelDescription == groupChannelDescription) &&
            (identical(other.firebaseOptions, firebaseOptions) ||
                other.firebaseOptions == firebaseOptions) &&
            (identical(other.notificationIcon, notificationIcon) ||
                other.notificationIcon == notificationIcon) &&
            const DeepCollectionEquality()
                .equals(other._channelInfo, _channelInfo));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      groupChannelId,
      groupChannelName,
      groupChannelDescription,
      firebaseOptions,
      notificationIcon,
      const DeepCollectionEquality().hash(_channelInfo));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationServiceConfigImplCopyWith<_$NotificationServiceConfigImpl>
      get copyWith => __$$NotificationServiceConfigImplCopyWithImpl<
          _$NotificationServiceConfigImpl>(this, _$identity);
}

abstract class _NotificationServiceConfig implements NotificationServiceConfig {
  factory _NotificationServiceConfig(
          {required final NotificationServiceType type,
          required final String groupChannelId,
          required final String groupChannelName,
          required final String groupChannelDescription,
          final FirebaseOptions? firebaseOptions,
          final String notificationIcon,
          final List<NotificationChannelInfo> channelInfo}) =
      _$NotificationServiceConfigImpl;

  @override
  NotificationServiceType get type;
  @override // required String tokenUpdateBaseUrl,
  String get groupChannelId;
  @override
  String get groupChannelName;
  @override
  String get groupChannelDescription;
  @override
  FirebaseOptions? get firebaseOptions;
  @override
  String get notificationIcon;
  @override
  List<NotificationChannelInfo> get channelInfo;
  @override
  @JsonKey(ignore: true)
  _$$NotificationServiceConfigImplCopyWith<_$NotificationServiceConfigImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NotificationInfo _$NotificationInfoFromJson(Map<String, dynamic> json) {
  return _NotificationInfo.fromJson(json);
}

/// @nodoc
mixin _$NotificationInfo {
  String? get title => throw _privateConstructorUsedError;
  String? get body => throw _privateConstructorUsedError;
  AndroidNotificationInfo? get android => throw _privateConstructorUsedError;
  AppleNotificationInfo? get apple => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationInfoCopyWith<NotificationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationInfoCopyWith<$Res> {
  factory $NotificationInfoCopyWith(
          NotificationInfo value, $Res Function(NotificationInfo) then) =
      _$NotificationInfoCopyWithImpl<$Res, NotificationInfo>;
  @useResult
  $Res call(
      {String? title,
      String? body,
      AndroidNotificationInfo? android,
      AppleNotificationInfo? apple});

  $AndroidNotificationInfoCopyWith<$Res>? get android;
  $AppleNotificationInfoCopyWith<$Res>? get apple;
}

/// @nodoc
class _$NotificationInfoCopyWithImpl<$Res, $Val extends NotificationInfo>
    implements $NotificationInfoCopyWith<$Res> {
  _$NotificationInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? body = freezed,
    Object? android = freezed,
    Object? apple = freezed,
  }) {
    return _then(_value.copyWith(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      android: freezed == android
          ? _value.android
          : android // ignore: cast_nullable_to_non_nullable
              as AndroidNotificationInfo?,
      apple: freezed == apple
          ? _value.apple
          : apple // ignore: cast_nullable_to_non_nullable
              as AppleNotificationInfo?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AndroidNotificationInfoCopyWith<$Res>? get android {
    if (_value.android == null) {
      return null;
    }

    return $AndroidNotificationInfoCopyWith<$Res>(_value.android!, (value) {
      return _then(_value.copyWith(android: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AppleNotificationInfoCopyWith<$Res>? get apple {
    if (_value.apple == null) {
      return null;
    }

    return $AppleNotificationInfoCopyWith<$Res>(_value.apple!, (value) {
      return _then(_value.copyWith(apple: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NotificationInfoImplCopyWith<$Res>
    implements $NotificationInfoCopyWith<$Res> {
  factory _$$NotificationInfoImplCopyWith(_$NotificationInfoImpl value,
          $Res Function(_$NotificationInfoImpl) then) =
      __$$NotificationInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? title,
      String? body,
      AndroidNotificationInfo? android,
      AppleNotificationInfo? apple});

  @override
  $AndroidNotificationInfoCopyWith<$Res>? get android;
  @override
  $AppleNotificationInfoCopyWith<$Res>? get apple;
}

/// @nodoc
class __$$NotificationInfoImplCopyWithImpl<$Res>
    extends _$NotificationInfoCopyWithImpl<$Res, _$NotificationInfoImpl>
    implements _$$NotificationInfoImplCopyWith<$Res> {
  __$$NotificationInfoImplCopyWithImpl(_$NotificationInfoImpl _value,
      $Res Function(_$NotificationInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? body = freezed,
    Object? android = freezed,
    Object? apple = freezed,
  }) {
    return _then(_$NotificationInfoImpl(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      android: freezed == android
          ? _value.android
          : android // ignore: cast_nullable_to_non_nullable
              as AndroidNotificationInfo?,
      apple: freezed == apple
          ? _value.apple
          : apple // ignore: cast_nullable_to_non_nullable
              as AppleNotificationInfo?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationInfoImpl implements _NotificationInfo {
  const _$NotificationInfoImpl(
      {this.title, this.body, this.android, this.apple});

  factory _$NotificationInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationInfoImplFromJson(json);

  @override
  final String? title;
  @override
  final String? body;
  @override
  final AndroidNotificationInfo? android;
  @override
  final AppleNotificationInfo? apple;

  @override
  String toString() {
    return 'NotificationInfo(title: $title, body: $body, android: $android, apple: $apple)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationInfoImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.android, android) || other.android == android) &&
            (identical(other.apple, apple) || other.apple == apple));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, title, body, android, apple);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationInfoImplCopyWith<_$NotificationInfoImpl> get copyWith =>
      __$$NotificationInfoImplCopyWithImpl<_$NotificationInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationInfoImplToJson(
      this,
    );
  }
}

abstract class _NotificationInfo implements NotificationInfo {
  const factory _NotificationInfo(
      {final String? title,
      final String? body,
      final AndroidNotificationInfo? android,
      final AppleNotificationInfo? apple}) = _$NotificationInfoImpl;

  factory _NotificationInfo.fromJson(Map<String, dynamic> json) =
      _$NotificationInfoImpl.fromJson;

  @override
  String? get title;
  @override
  String? get body;
  @override
  AndroidNotificationInfo? get android;
  @override
  AppleNotificationInfo? get apple;
  @override
  @JsonKey(ignore: true)
  _$$NotificationInfoImplCopyWith<_$NotificationInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppleNotificationInfo _$AppleNotificationInfoFromJson(
    Map<String, dynamic> json) {
  return _AppleNotificationInfo.fromJson(json);
}

/// @nodoc
mixin _$AppleNotificationInfo {
  String? get badge => throw _privateConstructorUsedError;
  String? get subtitle => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppleNotificationInfoCopyWith<AppleNotificationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppleNotificationInfoCopyWith<$Res> {
  factory $AppleNotificationInfoCopyWith(AppleNotificationInfo value,
          $Res Function(AppleNotificationInfo) then) =
      _$AppleNotificationInfoCopyWithImpl<$Res, AppleNotificationInfo>;
  @useResult
  $Res call({String? badge, String? subtitle, String? imageUrl});
}

/// @nodoc
class _$AppleNotificationInfoCopyWithImpl<$Res,
        $Val extends AppleNotificationInfo>
    implements $AppleNotificationInfoCopyWith<$Res> {
  _$AppleNotificationInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? badge = freezed,
    Object? subtitle = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      badge: freezed == badge
          ? _value.badge
          : badge // ignore: cast_nullable_to_non_nullable
              as String?,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppleNotificationInfoImplCopyWith<$Res>
    implements $AppleNotificationInfoCopyWith<$Res> {
  factory _$$AppleNotificationInfoImplCopyWith(
          _$AppleNotificationInfoImpl value,
          $Res Function(_$AppleNotificationInfoImpl) then) =
      __$$AppleNotificationInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? badge, String? subtitle, String? imageUrl});
}

/// @nodoc
class __$$AppleNotificationInfoImplCopyWithImpl<$Res>
    extends _$AppleNotificationInfoCopyWithImpl<$Res,
        _$AppleNotificationInfoImpl>
    implements _$$AppleNotificationInfoImplCopyWith<$Res> {
  __$$AppleNotificationInfoImplCopyWithImpl(_$AppleNotificationInfoImpl _value,
      $Res Function(_$AppleNotificationInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? badge = freezed,
    Object? subtitle = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(_$AppleNotificationInfoImpl(
      badge: freezed == badge
          ? _value.badge
          : badge // ignore: cast_nullable_to_non_nullable
              as String?,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppleNotificationInfoImpl implements _AppleNotificationInfo {
  const _$AppleNotificationInfoImpl({this.badge, this.subtitle, this.imageUrl});

  factory _$AppleNotificationInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppleNotificationInfoImplFromJson(json);

  @override
  final String? badge;
  @override
  final String? subtitle;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'AppleNotificationInfo(badge: $badge, subtitle: $subtitle, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppleNotificationInfoImpl &&
            (identical(other.badge, badge) || other.badge == badge) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, badge, subtitle, imageUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppleNotificationInfoImplCopyWith<_$AppleNotificationInfoImpl>
      get copyWith => __$$AppleNotificationInfoImplCopyWithImpl<
          _$AppleNotificationInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppleNotificationInfoImplToJson(
      this,
    );
  }
}

abstract class _AppleNotificationInfo implements AppleNotificationInfo {
  const factory _AppleNotificationInfo(
      {final String? badge,
      final String? subtitle,
      final String? imageUrl}) = _$AppleNotificationInfoImpl;

  factory _AppleNotificationInfo.fromJson(Map<String, dynamic> json) =
      _$AppleNotificationInfoImpl.fromJson;

  @override
  String? get badge;
  @override
  String? get subtitle;
  @override
  String? get imageUrl;
  @override
  @JsonKey(ignore: true)
  _$$AppleNotificationInfoImplCopyWith<_$AppleNotificationInfoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AndroidNotificationInfo _$AndroidNotificationInfoFromJson(
    Map<String, dynamic> json) {
  return _AndroidNotificationInfo.fromJson(json);
}

/// @nodoc
mixin _$AndroidNotificationInfo {
  int? get count => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AndroidNotificationInfoCopyWith<AndroidNotificationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AndroidNotificationInfoCopyWith<$Res> {
  factory $AndroidNotificationInfoCopyWith(AndroidNotificationInfo value,
          $Res Function(AndroidNotificationInfo) then) =
      _$AndroidNotificationInfoCopyWithImpl<$Res, AndroidNotificationInfo>;
  @useResult
  $Res call({int? count, String? imageUrl});
}

/// @nodoc
class _$AndroidNotificationInfoCopyWithImpl<$Res,
        $Val extends AndroidNotificationInfo>
    implements $AndroidNotificationInfoCopyWith<$Res> {
  _$AndroidNotificationInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AndroidNotificationInfoImplCopyWith<$Res>
    implements $AndroidNotificationInfoCopyWith<$Res> {
  factory _$$AndroidNotificationInfoImplCopyWith(
          _$AndroidNotificationInfoImpl value,
          $Res Function(_$AndroidNotificationInfoImpl) then) =
      __$$AndroidNotificationInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? count, String? imageUrl});
}

/// @nodoc
class __$$AndroidNotificationInfoImplCopyWithImpl<$Res>
    extends _$AndroidNotificationInfoCopyWithImpl<$Res,
        _$AndroidNotificationInfoImpl>
    implements _$$AndroidNotificationInfoImplCopyWith<$Res> {
  __$$AndroidNotificationInfoImplCopyWithImpl(
      _$AndroidNotificationInfoImpl _value,
      $Res Function(_$AndroidNotificationInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(_$AndroidNotificationInfoImpl(
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AndroidNotificationInfoImpl implements _AndroidNotificationInfo {
  const _$AndroidNotificationInfoImpl({this.count, this.imageUrl});

  factory _$AndroidNotificationInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AndroidNotificationInfoImplFromJson(json);

  @override
  final int? count;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'AndroidNotificationInfo(count: $count, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AndroidNotificationInfoImpl &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, count, imageUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AndroidNotificationInfoImplCopyWith<_$AndroidNotificationInfoImpl>
      get copyWith => __$$AndroidNotificationInfoImplCopyWithImpl<
          _$AndroidNotificationInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AndroidNotificationInfoImplToJson(
      this,
    );
  }
}

abstract class _AndroidNotificationInfo implements AndroidNotificationInfo {
  const factory _AndroidNotificationInfo(
      {final int? count,
      final String? imageUrl}) = _$AndroidNotificationInfoImpl;

  factory _AndroidNotificationInfo.fromJson(Map<String, dynamic> json) =
      _$AndroidNotificationInfoImpl.fromJson;

  @override
  int? get count;
  @override
  String? get imageUrl;
  @override
  @JsonKey(ignore: true)
  _$$AndroidNotificationInfoImplCopyWith<_$AndroidNotificationInfoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
