/// Auth token entity - Represents an authentication token
class AuthTokenEntity {
  final String token;
  final DateTime? expiresAt;

  const AuthTokenEntity({
    required this.token,
    this.expiresAt,
  });

  // Business logic methods
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get isValid => token.isNotEmpty && !isExpired;

  // Copy with method for immutability
  AuthTokenEntity copyWith({
    String? token,
    DateTime? expiresAt,
  }) {
    return AuthTokenEntity(
      token: token ?? this.token,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthTokenEntity &&
        other.token == token &&
        other.expiresAt == expiresAt;
  }

  @override
  int get hashCode => token.hashCode ^ expiresAt.hashCode;

  @override
  String toString() {
    return 'AuthTokenEntity(token: [REDACTED], isExpired: $isExpired)';
  }
}