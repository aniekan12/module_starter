import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';

abstract class DeviceInfoProvider {
  const DeviceInfoProvider();

  factory DeviceInfoProvider.getInstance() {
    return GetIt.I<DeviceInfoProvider>();
  }

  static Future<void> inject() async {
    if (!GetIt.I.isRegistered<DeviceInfoProvider>()) {
      final provider = _DeviceInfoProviderImpl();
      await provider.initialize();
      GetIt.I.registerLazySingleton<DeviceInfoProvider>(() => provider);
    }
  }

  String? get deviceName;
  String? get deviceVersion;
  String? get deviceModel;
  String? get deviceId;
  String get platform;
  Map<String, dynamic> get deviceInfo;
}

class _DeviceInfoProviderImpl extends DeviceInfoProvider {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  bool _isInitialized = false;
  Map<String, dynamic> _deviceData = {};

  Future<void> initialize() async {
    if (!_isInitialized) {
      try {
        if (Platform.isAndroid) {
          final androidInfo = await _deviceInfo.androidInfo;
          _deviceData = {
            'platform': 'android',
            'device_name': androidInfo.model,
            'device_version': androidInfo.version.release,
            'device_model': androidInfo.manufacturer,
            'device_id': androidInfo.id,
            'sdk_version': androidInfo.version.sdkInt.toString(),
            'brand': androidInfo.brand,
            'hardware': androidInfo.hardware,
            'is_physical_device': androidInfo.isPhysicalDevice,
          };
        } else if (Platform.isIOS) {
          final iosInfo = await _deviceInfo.iosInfo;
          _deviceData = {
            'platform': 'ios',
            'device_name': iosInfo.name,
            'device_version': iosInfo.systemVersion,
            'device_model': iosInfo.model,
            'device_id': iosInfo.identifierForVendor,
            'is_physical_device': iosInfo.isPhysicalDevice,
            'system_name': iosInfo.systemName,
            'utsname': {
              'release': iosInfo.utsname.release,
              'version': iosInfo.utsname.version,
              'machine': iosInfo.utsname.machine,
            },
          };
        } else {
          _deviceData = {
            'platform': 'unknown',
            'device_name': 'unknown',
            'device_version': 'unknown',
            'device_model': 'unknown',
            'device_id': 'unknown',
          };
        }
        _isInitialized = true;
      } catch (e) {
        _deviceData = {
          'platform': 'error',
          'error': e.toString(),
        };
        rethrow;
      }
    }
  }

  @override
  String? get deviceName => _deviceData['device_name'];

  @override
  String? get deviceVersion => _deviceData['device_version'];

  @override
  String? get deviceModel => _deviceData['device_model'];

  @override
  String? get deviceId => _deviceData['device_id'];

  @override
  String get platform => _deviceData['platform'] ?? 'unknown';

  @override
  Map<String, dynamic> get deviceInfo => Map<String, dynamic>.from(_deviceData);
}
