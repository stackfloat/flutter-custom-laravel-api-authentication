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
      return _handleAuthResponse(
        response,
        defaultErrorMessage: 'Unable to login. Please try again.',
      );
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
      return _handleAuthResponse(
        response,
        defaultErrorMessage: 'Unable to create account. Please try again.',
      );
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Either<Failure, UserModel> _handleAuthResponse(
    Response<dynamic> response, {
    required String defaultErrorMessage,
  }) {
    final data = response.data;

    if (data is! Map<String, dynamic>) {
      return Left(
        ServerFailure(
          'Invalid response format',
          code: response.statusCode,
        ),
      );
    }

    final mapData = Map<String, dynamic>.from(data);
    final status = mapData['status'];

    final bool isSuccessful = status == null ||
        status == true ||
        (status is String && status.toLowerCase() == 'true') ||
        (status is num && status != 0);

    if (!isSuccessful) {
      final message =
          mapData['message']?.toString() ?? defaultErrorMessage;
      return Left(
        ServerFailure(
          message,
          code: response.statusCode,
        ),
      );
    }

    final payload = mapData['data'];
    if (payload is! Map<String, dynamic>) {
      return Left(
        ServerFailure(
          'Missing user data in response',
          code: response.statusCode,
        ),
      );
    }

    return Right(UserModel.fromJson(mapData));
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