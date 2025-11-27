import 'package:equatable/equatable.dart';

/// Auth entity - Represents authentication state with user name, email and token
class AuthEntity extends Equatable {
  final String name;
  final String email;
  final String token;

  const AuthEntity({
    required this.name,
    required this.email,
    required this.token,
  });

  @override
  List<Object> get props => [name, email, token];

  @override
  String toString() {
    return 'AuthEntity(name: $name, email: $email, token: [REDACTED])';
  }
}
