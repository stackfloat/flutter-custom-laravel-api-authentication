/// User entity - Pure business object representing a user
/// This is framework-independent and contains only business logic
class UserEntity {
  final int id;
  final String name;
  final String email;
  final DateTime? emailVerifiedAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
  });

  // Business logic methods
  bool get isEmailVerified => emailVerifiedAt != null;

  // Copy with method for immutability
  UserEntity copyWith({
    int? id,
    String? name,
    String? email,
    DateTime? emailVerifiedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.emailVerifiedAt == emailVerifiedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        emailVerifiedAt.hashCode;
  }

  @override
  String toString() {
    return 'UserEntity(id: $id, name: $name, email: $email, isEmailVerified: $isEmailVerified)';
  }
}