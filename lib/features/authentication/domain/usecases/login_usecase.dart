import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/entities/auth_entity.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/repositories/auth_repository.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/usecases/login_params.dart' show LoginParams;


class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthEntity> call(LoginParams params) {
    return repository.login(params);
  }
}
