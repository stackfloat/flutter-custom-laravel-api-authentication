import 'package:flutter_custom_laravel_api_authentication/core/services/secure_storage_service.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/data/data_sources/auth_data_source.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/data/models/login_request_model.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/entities/auth_entity.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/repositories/auth_repository.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/usecases/login_params.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/usecases/signup_params.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthRemoteDataSource authRemoteDataSource;
  final SecureStorageService secureStorageService;

  AuthRepositoryImpl({required this.authRemoteDataSource, required this.secureStorageService});

  @override
  Future<AuthEntity> login(LoginParams params) {
    authRemoteDataSource.login(LoginRequestModel(email: params.email, password: params.password));
    throw UnimplementedError();
  }

  @override
  Future<AuthEntity> signup(SignupParams params) {
    // TODO: implement signup
    throw UnimplementedError();
  }

}