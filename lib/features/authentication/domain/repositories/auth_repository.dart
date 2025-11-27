import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/usecases/login_params.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/usecases/signup_params.dart';

import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> login(LoginParams params);

  Future<AuthEntity> signup(SignupParams params);
}
