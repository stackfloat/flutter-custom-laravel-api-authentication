import 'package:dio/dio.dart';
import 'package:flutter_custom_laravel_api_authentication/core/network/interceptors/crashlytics_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'interceptors/auth_interceptor.dart';

class DioClient {
  final FlutterSecureStorage secureStorage;
  
  DioClient(this.secureStorage);

  Dio get dio {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://api-authentication.test/api', // Replace with your API URL
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.add(AuthInterceptor(secureStorage));
    dio.interceptors.add(CrashlyticsInterceptor());

    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      error: true,
      compact: true,
    ));
    
    // Add logging interceptor (optional, for debugging)
    // dio.interceptors.add(LogInterceptor(
    //   requestBody: true,
    //   responseBody: true,
    // ));

    return dio;
  }
}
