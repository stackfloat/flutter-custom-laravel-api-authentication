part of 'login_bloc.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool showPassword;
  final bool formSubmitted;
  final bool loginSuccessful;
  final bool isSubmitting;     // Loading during login form submission
  final Map<String, String?> formErrors;
  final String? loginFailedMessage;

  const LoginState({
    required this.email,
    required this.password,
    required this.showPassword,
    required this.formSubmitted,
    required this.loginSuccessful,
    required this.isSubmitting,
    required this.formErrors,
    required this.loginFailedMessage,
  });

  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      showPassword: false,
      formSubmitted: false,
      loginSuccessful: false,
      isSubmitting: false,    // Not submitting initially
      formErrors: {},
      loginFailedMessage: null,
    );
  }

  LoginState copyWith({
    String? email,
    String? password,
    bool? showPassword,
    bool? formSubmitted,
    bool? loginSuccessful,
    bool? isSubmitting,
    Map<String, String?>? formErrors,
    bool clearFormErrors = false,
    String? loginFailedMessage,
    bool clearLoginFailedMessage = false,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      showPassword: showPassword ?? this.showPassword,
      formSubmitted: formSubmitted ?? this.formSubmitted,
      loginSuccessful: loginSuccessful ?? this.loginSuccessful,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      formErrors: clearFormErrors 
          ? {} 
          : (formErrors ?? this.formErrors),
      loginFailedMessage: clearLoginFailedMessage 
          ? null 
          : (loginFailedMessage ?? this.loginFailedMessage),
    );
  }

  @override
  List<Object?> get props => [
        email,  // ← Add this for validation-driven rebuilds
        password, // Optional: add if you want password validation too
        showPassword,
        formSubmitted,
        loginSuccessful,
        isSubmitting,
        formErrors.entries,
        loginFailedMessage,
      ];

  @override
  String toString() {
    return 'LoginState('
        'email: $email, '
        'password: [REDACTED], '
        'showPassword: $showPassword, '
        'formSubmitted: $formSubmitted, '
        'loginSuccessful: $loginSuccessful, '
        'isSubmitting: $isSubmitting, '
        'formErrors: $formErrors, '
        'loginFailedMessage: $loginFailedMessage'
        ')';
  }
}
