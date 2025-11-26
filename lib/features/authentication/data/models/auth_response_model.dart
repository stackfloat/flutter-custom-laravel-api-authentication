import 'user_model.dart';

class AuthResponseModel {
  final String token;
  final UserModel user;

  const AuthResponseModel({
    required this.token,
    required this.user,
  });

  // Convert from JSON (API response)
  // Laravel typically returns: { "token": "...", "user": {...} }
  // or: { "access_token": "...", "user": {...} }
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      // Handle both "token" and "access_token" keys
      token: json['token'] as String? ?? json['access_token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  // Convert to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }

  @override
  String toString() {
    return 'AuthResponseModel(token: [REDACTED], user: $user)';
  }
}

