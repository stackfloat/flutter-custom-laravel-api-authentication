class SignupRequestModel {
  final String name;
  final String email;
  final String password;


  const SignupRequestModel({
    required this.name,
    required this.email,
    required this.password,

  });

  // Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'SignupRequestModel(name: $name, email: $email, password: [REDACTED])';
  }
}
