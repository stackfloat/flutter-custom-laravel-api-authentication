import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'interceptors/auth_interceptor.dart';

class DioClient {
  final FlutterSecureStorage secureStorage;
  
  DioClient(this.secureStorage);

  Dio get dio {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://your-api-url.com/api', // Replace with your API URL
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
    
    // Add logging interceptor (optional, for debugging)
    // dio.interceptors.add(LogInterceptor(
    //   requestBody: true,
    //   responseBody: true,
    // ));

    return dio;
  }
}
