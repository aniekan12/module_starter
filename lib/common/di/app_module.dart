import 'package:obodo_module_starter/common/events/data_bus.dart';
import 'package:obodo_module_starter/common/io/api_client.dart';
import 'package:obodo_module_starter/domain/providers/device_info_provider.dart';
import 'package:obodo_module_starter/domain/providers/shared_preference_provider.dart';

class AppModule {
  AppModule._();

  static Future<void> register() async {
    SharedPreferenceProvider.inject();
    ApiClient.inject();
    DeviceInfoProvider.inject();
    DataBus.inject();
  }
}
