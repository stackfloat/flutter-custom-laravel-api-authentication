import 'package:dio/dio.dart';

import '../models/login_request_model.dart';
import '../models/signup_request_model.dart';
import '../models/user_model.dart';

class AuthApiService {
  final Dio dio;
  AuthApiService(this.dio);

  Future<UserModel> login(LoginRequestModel model) async {
    final response = await dio.post('/login', data: model.toJson());
    return UserModel.fromJson(response.data);
  }

  Future<UserModel> signup(SignupRequestModel model) async {
    final response = await dio.post('/signup', data: model.toJson());
    return UserModel.fromJson(response.data);
  }

  Future<UserModel> getProfile() async {
    final response = await dio.get('/me');
    return UserModel.fromJson(response.data);
  }
}
