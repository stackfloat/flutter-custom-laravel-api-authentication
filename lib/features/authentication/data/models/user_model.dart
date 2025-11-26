class UserModel {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
  });

  // Convert from JSON (API response)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      emailVerifiedAt: json['email_verified_at'] as String?,
    );
  }

  // Convert to JSON (for API requests if needed)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
    };
  }

  // Copy with method for immutability
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? emailVerifiedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email)';
  }
}