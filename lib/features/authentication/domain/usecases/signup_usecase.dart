import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/entities/auth_entity.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/repositories/auth_repository.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/usecases/signup_params.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<AuthEntity> call(SignupParams params) {    

    return repository.signup(params);
  }
}
