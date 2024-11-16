import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'interceptors/loggin_interceptor.dart';

class ApiClient {
  ApiClient({required this.dio});

  factory ApiClient.getInstance() {
    return GetIt.I<ApiClient>();
  }

  static Future<void> inject(
      {List<Interceptor> interceptors = const []}) async {
    Map<String, dynamic> headers = {};
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

        for (final element in interceptors) {
          apiClient.addInterceptor(element);
        }

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
