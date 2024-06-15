import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferenceProvider {
  const SharedPreferenceProvider();

  factory SharedPreferenceProvider.getInstance() {
    return GetIt.I<SharedPreferenceProvider>();
  }

  static void inject() {
    if (!GetIt.I.isRegistered<SharedPreferenceProvider>()) {
      GetIt.I.registerSingletonAsync<SharedPreferenceProvider>(() {
        return SharedPreferences.getInstance().then((value) {
          return SharePreferenceProviderImpl(value);
        });
      });
    }
  }

  Future<bool> saveValue<T>(String key, T value);

  T? getValue<T>(String key);

  Future<bool> deleteKey(String key);

  String? getDeviceThemeMode();

  Future<void> secureWrite(String key, String value);

  Future<String?> secureRead(String key);

  Future<void> secureDelete(String key);

  Future<void> secureDeleteAll();
}

///======================SharedProviderImplementation===========================
class SharePreferenceProviderImpl extends SharedPreferenceProvider {
  SharePreferenceProviderImpl(this.preferences,
      {FlutterSecureStorage? secureStorage})
      : secureStorage = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions:
                  IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  static const themeModeKey = 'obodo_theme_preference_mode';

  final SharedPreferences preferences;

  final FlutterSecureStorage secureStorage;

  @override
  T? getValue<T>(String key) {
    switch (T) {
      case String:
        return preferences.getString(key) as T?;
      case int:
        return preferences.getInt(key) as T?;
      case double:
        return preferences.getDouble(key) as T?;
      case bool:
        return preferences.getBool(key) as T?;
      // ignore: strict_raw_type
      case List:
        return preferences.getStringList(key) as T?;
      default:
        return preferences.get(key) as T?;
    }
  }

  @override
  Future<bool> saveValue<T>(String key, T value) {
    switch (T) {
      case String:
        return preferences.setString(key, value as String);
      case int:
        return preferences.setInt(key, value as int);
      case double:
        return preferences.setDouble(key, value as double);
      case bool:
        return preferences.setBool(key, value as bool);
      // ignore: strict_raw_type
      case List:
        return preferences.setStringList(key, value as List<String>);
      default:
        return preferences.setString(key, '$value');
    }
  }

  @override
  Future<bool> deleteKey(String key) {
    return preferences.remove(key);
  }

  @override
  String? getDeviceThemeMode() {
    return getValue(themeModeKey);
  }

  @override
  Future<void> secureDelete(String key) {
    return secureStorage.delete(key: key);
  }

  @override
  Future<void> secureDeleteAll() {
    return secureStorage.deleteAll();
  }

  @override
  Future<String?> secureRead(String key) {
    return secureStorage.read(key: key);
  }

  @override
  Future<void> secureWrite(String key, String value) {
    return secureStorage.write(key: key, value: value);
  }
}
