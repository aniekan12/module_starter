import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:obodo_module_starter/common/io/ip_info.dart';
import 'interceptors/loggin_interceptor.dart';

class ApiClient {
  ApiClient({required this.dio}) {
    //do some configuration here
  }

  factory ApiClient.getInstance() {
    return GetIt.I<ApiClient>();
  }

  static void inject({List<Interceptor> interceptors = const []}) async {
    Map<String, dynamic> headers = {};
    IpInfo().getPublicIP().then((ip) {
      headers['x-forwarded-for'] = ip;
    });
    // if (ipAddress != null) {}
    headers['Content-Type'] = 'application/json';

    if (!GetIt.I.isRegistered<ApiClient>()) {
      GetIt.I.registerLazySingleton(() {
        final apiClient = ApiClient(
            dio: Dio()
              ..options.headers = headers
              ..options.connectTimeout = const Duration(seconds: 120)
              ..options.receiveTimeout = const Duration(seconds: 120)
              ..options.connectTimeout = const Duration(seconds: 120))
          ..addInterceptor(LoggingInterceptor());
        // .._initISRGCertificate();

        for (final element in interceptors) {
          apiClient.addInterceptor(element);
        }

        // apiClient
        //   ..addInterceptor(LoggingInterceptor())
        return apiClient;
      });
    }
  }

  final Dio dio;

  Dio get httpClient => dio;

  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
  }
}
