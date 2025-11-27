import 'package:dio/dio.dart';
import 'package:flutter_custom_laravel_api_authentication/core/services/secure_storage_service.dart' show SecureStorageService, ISecureStorageService;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {

  print('Initializing dependencies...');

  // Secure Storage
  final secureStorage = SecureStorageService.create();
  await secureStorage.init();

  getIt.registerSingleton<ISecureStorageService>(secureStorage);

  // Dio Client
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(getIt<FlutterSecureStorage>()),
  );

  // Dio instance (configured with interceptors)
  getIt.registerLazySingleton<Dio>(
    () => getIt<DioClient>().dio,
  );
}
