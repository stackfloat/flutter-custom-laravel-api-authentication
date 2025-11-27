class UserModel {
  final String name;
  final String email;
  final String token;

  const UserModel({
    required this.name,
    required this.email,
    required this.token,
  });

  // Convert from JSON (API response)
  factory UserModel.fromJson(Map<String, dynamic> json) {

    final payload = json.containsKey('data') ? json['data'] : json;
    
    final userJson = payload['user'] is Map<String, dynamic>
        ? payload['user'] as Map<String, dynamic>
        : payload;

    final token = payload['token'] ?? userJson['token'];

    return UserModel(
      name: userJson['name'] as String,
      email: userJson['email'] as String,
      token: token as String,
    );
  }

  // Convert to JSON (for API requests if needed)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'token': token,
    };
  }

  // Copy with method for immutability
  UserModel copyWith({
    String? name,
    String? email,
    String? token,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, token: [REDACTED])';
  }
}