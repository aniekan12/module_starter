import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class PackageInfoProvider {
  const PackageInfoProvider();

  factory PackageInfoProvider.getInstance() {
    return GetIt.I<PackageInfoProvider>();
  }

  static void inject() async {
    if (!GetIt.I.isRegistered<PackageInfoProvider>()) {
      final provider = _PackageInfoProviderImpl();
      await provider.initialize();
      GetIt.I.registerLazySingleton<PackageInfoProvider>(() => provider);
    }
  }

  String? get appName;

  String? get version;

  String? get buildNumber;
}

class _PackageInfoProviderImpl extends PackageInfoProvider {
  late PackageInfo _packageInfo;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      _packageInfo = await PackageInfo.fromPlatform();
      _isInitialized = true;
    }
  }

  PackageInfo get packageInfo {
    if (!_isInitialized) {
      throw StateError(
          'PackageInfoProvider not initialized. Call initialize() first.');
    }
    return _packageInfo;
  }

  @override
  String? get appName => _isInitialized ? packageInfo.appName : null;

  @override
  String? get version => _isInitialized ? packageInfo.version : null;

  @override
  String? get buildNumber => _isInitialized ? packageInfo.buildNumber : null;
}
