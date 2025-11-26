import 'auth_token_entity.dart';
import 'user_entity.dart';

/// Auth entity - Represents authentication state with user and token
class AuthEntity {
  final UserEntity user;
  final AuthTokenEntity token;

  const AuthEntity({
    required this.user,
    required this.token,
  });

  // Business logic methods
  bool get isAuthenticated => token.isValid;

  // Copy with method for immutability
  AuthEntity copyWith({
    UserEntity? user,
    AuthTokenEntity? token,
  }) {
    return AuthEntity(
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthEntity &&
        other.user == user &&
        other.token == token;
  }

  @override
  int get hashCode => user.hashCode ^ token.hashCode;

  @override
  String toString() {
    return 'AuthEntity(user: $user, isAuthenticated: $isAuthenticated)';
  }
}