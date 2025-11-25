part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends SignupEvent {
  final String name;
  const NameChanged({required this.name});

  @override
  List<Object> get props => [name];
}

class EmailChanged extends SignupEvent {
  final String email;
  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends SignupEvent {
  final String password;
  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}

class ConfirmPasswordChanged extends SignupEvent {
  final String confirmPassword;
  const ConfirmPasswordChanged({required this.confirmPassword});

  @override
  List<Object> get props => [confirmPassword];
}

class ShowPasswordChanged extends SignupEvent {
  final bool showPassword;
  const ShowPasswordChanged({required this.showPassword});

  @override
  List<Object> get props => [showPassword];
}

class ShowConfirmPasswordChanged extends SignupEvent {
  final bool showConfirmPassword;
  const ShowConfirmPasswordChanged({required this.showConfirmPassword});

  @override
  List<Object> get props => [showConfirmPassword];
}

class SignupSubmitted extends SignupEvent {
  const SignupSubmitted();

  @override
  List<Object> get props => [];
}
