import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/usecases/login_params.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/usecases/login_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(LoginState.initial()) {
    on<EmailChanged>((event, emit) {
      // Validate email on change
      final emailError = _validateEmail(event.email, state.formSubmitted);
      
      emit(state.copyWith(
        email: event.email,
        formErrors: {
          ...state.formErrors,
          'email': emailError,
        },
        // Clear login failed message when user starts typing again
        loginFailedMessage: null,
        clearLoginFailedMessage: true,
      ));
    });
    
    on<PasswordChanged>((event, emit) {
      // Validate password on change
      final passwordError = _validatePassword(event.password, state.formSubmitted);
      
      emit(state.copyWith(
        password: event.password,
        formErrors: {
          ...state.formErrors,
          'password': passwordError,
        },
        // Clear login failed message when user starts typing again
        loginFailedMessage: null,
        clearLoginFailedMessage: true,
      ));
    });
    
    on<ShowPasswordChanged>((event, emit) {
      emit(state.copyWith(showPassword: event.showPassword));
    });
    
    on<LoginSubmitted>((event, emit) async {
      // Validate all fields when form is submitted
      final emailError = _validateEmail(state.email, true);
      final passwordError = _validatePassword(state.password, true);
      
      final errors = <String, String?>{};
      if (emailError != null) errors['email'] = emailError;
      if (passwordError != null) errors['password'] = passwordError;
      
      if (errors.isEmpty) {
        emit(state.copyWith(
          formSubmitted: true,
          isSubmitting: true,
          formErrors: {},
          clearFormErrors: true,
          loginFailedMessage: null,
          clearLoginFailedMessage: true,
        ));

        final result = await loginUseCase(
          LoginParams(email: state.email, password: state.password),
        );

        result.fold(
          (failure) => emit(
            state.copyWith(
              isSubmitting: false,
              loginFailedMessage: failure.message,
              loginSuccessful: false,
            ),
          ),
          (_) => emit(
            state.copyWith(
              isSubmitting: false,
              loginSuccessful: true,
              loginFailedMessage: null,
              clearLoginFailedMessage: true,
            ),
          ),
        );
      } else {
        // Form has errors
        emit(state.copyWith(
          formSubmitted: true,
          formErrors: errors,
        ));
      }
    });
  }

  // Validation helper methods
  String? _validateEmail(String email, bool showErrors) {
    if (!showErrors && email.isEmpty) {
      return null; // Don't show error if empty and form not submitted
    }
    
    if (email.isEmpty) {
      return 'Please enter your email';
    }
    
    if (!email.contains('@')) {
      return 'Please enter a valid email address';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    
    return null; // No error
  }

  String? _validatePassword(String password, bool showErrors) {
    if (!showErrors && password.isEmpty) {
      return null; // Don't show error if empty and form not submitted
    }
    
    if (password.isEmpty) {
      return 'Please enter your password';
    }
    
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null; // No error
  }
}
