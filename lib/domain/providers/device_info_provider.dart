import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:obodo_module_starter/common/models/device_information.dart';
import 'package:uuid/uuid.dart';

import 'shared_preference_provider.dart';

abstract class DeviceInfoProvider {
  const DeviceInfoProvider();

  factory DeviceInfoProvider.getInstance() {
    return GetIt.I<DeviceInfoProvider>();
  }

  static void inject() {
    if (!GetIt.I.isRegistered<DeviceInfoProvider>()) {
      GetIt.I.registerSingletonWithDependencies<DeviceInfoProvider>(() {
        return _DeviceInformationProviderImpl(
          const MethodChannel('irecharge.flutter.dev/device_manager'),
          SharedPreferenceProvider.getInstance(),
        );
      }, dependsOn: [SharedPreferenceProvider]);
    }
  }

  Future<DeviceInformation> getDeviceInfo();

  String? get deviceId;

  String? get deviceVersion;

  String? get deviceBrandName;

  String? get deviceName;

  int get androidSdkInt;

  DevicePlatform get platform;
}

///====================DeviceProviderInformationImplementation==================
class _DeviceInformationProviderImpl extends DeviceInfoProvider {
  _DeviceInformationProviderImpl(
    this.iosChannel,
    this.provider,
  );
  static const _deviceIdKey = 'irecharge_android_device_id';

  final DeviceInfoPlugin _deviceManager = DeviceInfoPlugin();
  final _platform = _$DevicePlatformImpl();

  final MethodChannel iosChannel;
  final SharedPreferenceProvider provider;

  String? _deviceName;
  String? _deviceVersion;
  String? _deviceBrandName;
  String? _deviceId;
  int _androidSdkInt = 0;

  @override
  String? get deviceId => _deviceId;

  @override
  String? get deviceVersion => _deviceVersion;

  @override
  String? get deviceBrandName => _deviceBrandName;

  @override
  String? get deviceName => _deviceName;

  @override
  DevicePlatform get platform => _platform;

  @override
  int get androidSdkInt => _androidSdkInt;

  @override
  Future<DeviceInformation> getDeviceInfo() async {
    if (platform.isAndroid) {
      final value = await _deviceManager.androidInfo;
      _deviceName = value.device;
      _deviceVersion = value.version.codename;
      _deviceBrandName = value.brand;
      _androidSdkInt = value.version.sdkInt;
      _deviceId = await _provideAndroidDeviceId();
    } else if (platform.isIOS) {
      final value = await _deviceManager.iosInfo;
      unawaited(_resetIosDeviceId(value));
      _deviceName = value.name;
      _deviceVersion = value.systemVersion;
      _deviceBrandName = value.localizedModel;
    }

    return DeviceInformation(
        deviceId: _deviceId ?? '',
        deviceName: _deviceName ?? '',
        deviceVersion: _deviceVersion ?? '',
        deviceBrandName: _deviceBrandName ?? '',
        deviceOS: platform.isAndroid ? 'ANDROID' : 'IOS');
  }

  int _getAppFlavor() {
    const flavor =
        String.fromEnvironment('APP_FLAVOR', defaultValue: 'business');
    if (flavor == 'business') {
      return 1;
    } else {
      return 2;
    }
  }

  String _getAppEnv() {
    const appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'local');
    return switch (appEnv) {
      'dev' => '1',
      'staging' => '2',
      'beta' => '3',
      'prod' => '4',
      _ => '5'
    };
  }

  Future<void> _resetIosDeviceId(IosDeviceInfo deviceInfo) async {
    //So we need to check if we have the deviceId saved in the keychin
    //Because the identifierForVendor isn't retained during uninstalls and
    //re-install on a particular device, however the value on the keychain
    //remains forever on the device except for a hard factory reset though.
    final flavor = _getAppFlavor();
    final appEnv = _getAppEnv();

    final persistedDeviceId = await _getPersistedDeviceId();
    if (persistedDeviceId == null) {
      //We are appending the flavor and appEnv to differentiate the vendorId for

      _deviceId = '${deviceInfo.identifierForVendor}-$flavor-$appEnv';
      if (_deviceId != null) {
        final isPersisted = await _persistDeviceId(_deviceId!);
        if (isPersisted == false) {
          //There's really nothing we can do here
          //because the reason why it wouldn't save in the first place
          //must have been dealt with
        }
      } else {
        //A very unlikely situation but there's a possibility that
        //the ios identifierForVendor returns nil. we simply have to wait and
        // retry
        Future.delayed(const Duration(seconds: 120), () {
          _resetIosDeviceId(deviceInfo);
        });
      }
    } else {
      _deviceId = persistedDeviceId;
    }
  }

  Future<String> _provideAndroidDeviceId() async {
    final persistedDeviceId = provider.getValue<String>(_deviceIdKey);

    if (null != persistedDeviceId && persistedDeviceId.isNotEmpty) {
      return persistedDeviceId;
    }

    final keys = [
      const Symbol('deviceVersion'),
      const Symbol('deviceBrand'),
      const Symbol('deviceName'),
    ];

    final values = [_deviceName, _deviceVersion, _deviceBrandName];

    final deviceId = const Uuid()
        .v4(options: {'namedArgs': Map.fromIterables(keys, values)});

    await provider.saveValue(_deviceIdKey, deviceId);

    return deviceId;
  }

  Future<String?> _getPersistedDeviceId() {
    return iosChannel.invokeMethod('get_device_id');
  }

  Future<bool?> _persistDeviceId(String deviceId) {
    return iosChannel.invokeMethod('set_device_id', {'deviceId': deviceId});
  }
}

abstract class DevicePlatform {
  bool get isIOS;
  bool get isAndroid;
  String get deviceType;
}

class _$DevicePlatformImpl extends DevicePlatform {
  @override
  bool get isAndroid => Platform.isAndroid;

  @override
  bool get isIOS => Platform.isIOS;

  @override
  String get deviceType => isAndroid ? 'ANROID' : 'IOS';
}
