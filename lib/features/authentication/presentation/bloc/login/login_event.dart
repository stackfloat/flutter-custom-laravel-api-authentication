part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}


class EmailChanged extends LoginEvent {
  final String email;
  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends LoginEvent {
  final String password;
  const PasswordChanged({required this.password});
}


class ShowPasswordChanged extends LoginEvent {
  final bool showPassword;
  const ShowPasswordChanged({required this.showPassword});

  @override
  List<Object> get props => [showPassword];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();

  @override
  List<Object> get props => [];
}