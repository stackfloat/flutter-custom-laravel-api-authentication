import 'package:dio/dio.dart';
import 'package:flutter_custom_laravel_api_authentication/core/services/secure_storage_service.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/data/data_sources/auth_data_source.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/repositories/auth_repository.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/usecases/login_usecase.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/usecases/signup_usecase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {

  // Core: FlutterSecureStorage + wrapper service
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ),
    ),
  );

  final secureStorage = SecureStorageServiceImpl(getIt<FlutterSecureStorage>());
  await secureStorage.init();
  getIt.registerSingleton<SecureStorageService>(secureStorage);

  // Networking: Dio client + instance
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(getIt<FlutterSecureStorage>()),
  );
  getIt.registerLazySingleton<Dio>(() => getIt<DioClient>().dio);

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<Dio>()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: getIt<AuthRemoteDataSource>(),
      secureStorageService: getIt<SecureStorageService>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<SignupUseCase>(
    () => SignupUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );
}
