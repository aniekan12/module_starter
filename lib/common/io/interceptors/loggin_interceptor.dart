import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:obodo_module_starter/common/io/logger/logger_factory.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    LoggerFactory.getLogger().info('REQUEST URI: ${options.uri}', {
      'METHOD': options.method,
      '\nHEADERS': options.headers == {} ? '' : _filterValues(options.headers),
      '\nBODY': options.data == null
          ? ''
          : options.data != Map
              ? options.data
              : _filterValues(options.data),
    });
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    LoggerFactory.getLogger()
        .info('RESPONSE URI: ${response.requestOptions.uri}', {
      'METHOD': response.requestOptions.method,
      '\nHEADERS': _filterValues(response.headers.map),
      '\nSTATUS CODE': response.statusCode,
      '\nSTATUS MESSAGE': response.statusMessage,
      '\nBODY': response.data,
    });
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    LoggerFactory.getLogger().error('URI: ${err.requestOptions.uri}', {
      'METHOD': err.requestOptions.method,
      '\nHEADERS': _filterValues(err.requestOptions.headers),
      '\nSTATUS CODE': err.response?.statusCode,
      '\nSTATUS MESSAGE': err.response?.statusMessage,
      '\nREDIRECT': err.response?.realUri ?? '',
      '\nBODY': err.response?.data,
    });
    return super.onError(err, handler);
  }

  dynamic _filterValues(Map<String, dynamic> headers) {
    final stringBuffer = StringBuffer();

    headers.forEach((key, value) {
      if (key != '') {
        if (value is List) {
          for (final e in value) {
            stringBuffer.writeln('$key: $e');
          }
        } else {
          if (key.toLowerCase().startsWith('password')) {
            stringBuffer.writeln('$key: ********');
          } else if (key.toLowerCase().startsWith('passcode')) {
            stringBuffer.writeln('$key: ********');
          } else {
            stringBuffer.writeln('$key: $value');
          }
        }
      } else if (kDebugMode &&
          null != value &&
          value is String &&
          value.isNotEmpty) {
        stringBuffer.writeln('$key: ${value.substring(0, 50)}...');
      }
    });
    return stringBuffer.toString();
  }
}
