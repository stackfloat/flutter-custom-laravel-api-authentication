import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/auth_entity.dart';
import '../usecases/login_params.dart';
import '../usecases/signup_params.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> login(LoginParams params);
  Future<Either<Failure, AuthEntity>> signup(SignupParams params);
}
