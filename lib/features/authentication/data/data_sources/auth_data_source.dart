import 'package:dio/dio.dart';

import '../models/login_request_model.dart';
import '../models/signup_request_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(LoginRequestModel model);
  Future<UserModel> signup(SignupRequestModel model);
  Future<UserModel> getProfile();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> login(LoginRequestModel model) async { 
    final response = await dio.post('/login', data: model.toJson());
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> signup(SignupRequestModel model) async { 
    final response = await dio.post('/signup', data: model.toJson());
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> getProfile() async { 
    final response = await dio.get('/me');
    return UserModel.fromJson(response.data);
  }
}