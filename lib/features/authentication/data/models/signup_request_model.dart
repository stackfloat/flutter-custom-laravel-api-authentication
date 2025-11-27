class SignupRequestModel {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  const SignupRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  // Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }

  @override
  String toString() {
    return 'SignupRequestModel(name: $name, email: $email, password: [REDACTED])';
  }
}
