part of 'signup_bloc.dart';

class SignupState extends Equatable {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool showPassword;
  final bool showConfirmPassword;
  final bool formSubmitted;
  final bool signupSuccessful;
  final bool isSubmitting;
  final Map<String, String?> formErrors;
  final String? signupFailedMessage;

  const SignupState({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.showPassword,
    required this.showConfirmPassword,
    required this.formSubmitted,
    required this.signupSuccessful,
    required this.isSubmitting,
    required this.formErrors,
    required this.signupFailedMessage,
  });

  factory SignupState.initial() {
    return const SignupState(
      name: '',
      email: '',
      password: '',
      confirmPassword: '',
      showPassword: false,
      showConfirmPassword: false,
      formSubmitted: false,
      signupSuccessful: false,
      isSubmitting: false,
      formErrors: {},
      signupFailedMessage: null,
    );
  }

  SignupState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    bool? showPassword,
    bool? showConfirmPassword,
    bool? formSubmitted,
    bool? signupSuccessful,
    bool? isSubmitting,
    Map<String, String?>? formErrors,
    bool clearFormErrors = false,
    String? signupFailedMessage,
    bool clearSignupFailedMessage = false,
  }) {
    return SignupState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      showPassword: showPassword ?? this.showPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
      formSubmitted: formSubmitted ?? this.formSubmitted,
      signupSuccessful: signupSuccessful ?? this.signupSuccessful,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      formErrors: clearFormErrors 
          ? {} 
          : (formErrors ?? this.formErrors),
      signupFailedMessage: clearSignupFailedMessage 
          ? null 
          : (signupFailedMessage ?? this.signupFailedMessage),
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        confirmPassword,
        showPassword,
        showConfirmPassword,
        formSubmitted,
        signupSuccessful,
        isSubmitting,
        formErrors.entries,
        signupFailedMessage,
      ];

  @override
  String toString() {
    return 'SignupState('
        'name: $name, '
        'email: $email, '
        'password: [REDACTED], '
        'confirmPassword: [REDACTED], '
        'showPassword: $showPassword, '
        'showConfirmPassword: $showConfirmPassword, '
        'formSubmitted: $formSubmitted, '
        'signupSuccessful: $signupSuccessful, '
        'isSubmitting: $isSubmitting, '
        'formErrors: $formErrors, '
        'signupFailedMessage: $signupFailedMessage'
        ')';
  }
}
