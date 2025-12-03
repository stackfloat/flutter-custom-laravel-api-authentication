import 'dart:convert';

import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../data_sources/auth_data_source.dart';
import '../models/login_request_model.dart';
import '../models/signup_request_model.dart';
import '../models/user_model.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_params.dart';
import '../../domain/usecases/signup_params.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final SecureStorageService secureStorageService;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.secureStorageService,
  });

  @override
  Future<Either<Failure, AuthEntity>> login(LoginParams params) async {
    final result = await authRemoteDataSource.login(
      LoginRequestModel(
        email: params.email,
        password: params.password,
      ),
    );

    return await result.fold<Future<Either<Failure, AuthEntity>>>(
      (failure) async => Left(failure),
      (userModel) async {
        await _persistUser(userModel);
        return Right(_mapToEntity(userModel));
      },
    );
  }

  @override
  Future<Either<Failure, AuthEntity>> signup(SignupParams params) async {
    final result = await authRemoteDataSource.signup(
      SignupRequestModel(
        name: params.name,
        email: params.email,
        password: params.password,
      ),
    );

    return await result.fold<Future<Either<Failure, AuthEntity>>>(
      (failure) async => Left(failure),
      (userModel) async {
        await _persistUser(userModel);
        return Right(_mapToEntity(userModel));
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _clearSession();
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<void> _persistUser(UserModel userModel) async {
    await secureStorageService.saveAccessToken(userModel.token);
    await secureStorageService.saveUser(jsonEncode(userModel.toJson()));
  }

  Future<void> _clearSession() async {
    await secureStorageService.deleteAccessToken();
    await secureStorageService.deleteRefreshToken();
    await secureStorageService.deleteUser();
  }

  AuthEntity _mapToEntity(UserModel user) {
    return AuthEntity(
      name: user.name,
      email: user.email,
      token: user.token,
    );
  }
}