import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../models/login_request_model.dart';
import '../models/signup_request_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, UserModel>> login(LoginRequestModel model);
  Future<Either<Failure, UserModel>> signup(SignupRequestModel model);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<Either<Failure, UserModel>> login(LoginRequestModel model) async {
    try {
      final response = await dio.post('/login', data: model.toJson());
      return Right(UserModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signup(SignupRequestModel model) async {
    try {
      final response = await dio.post('/register', data: model.toJson());
      return Right(UserModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Failure _mapDioException(DioException exception) {
    if (exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.sendTimeout ||
        exception.type == DioExceptionType.connectionError) {
      return NetworkFailure(exception.message ?? 'Network error occurred');
    }

    final response = exception.response;
    final message = response?.data?['message']?.toString() ??
        exception.message ??
        'Server error';

    return ServerFailure(
      message,
      code: response?.statusCode,
    );
  }
}