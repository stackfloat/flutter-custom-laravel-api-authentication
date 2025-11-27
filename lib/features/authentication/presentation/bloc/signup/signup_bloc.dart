import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/usecases/login_usecase.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/usecases/signup_params.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/usecases/signup_usecase.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {

final SignupUseCase signupUseCase;

  SignupBloc({
    required this.signupUseCase,
  }) : super(SignupState.initial()) {
    on<NameChanged>((event, emit) {
      // Validate name on change
      final nameError = _validateName(event.name);
      emit(
        state.copyWith(
          name: event.name,
          formErrors: {...state.formErrors, 'name': nameError},
          signupFailedMessage: null,
          clearSignupFailedMessage: true,
        ),
      );
    });

    on<EmailChanged>((event, emit) {
      // Validate email on change
      final emailError = _validateEmail(event.email);

      emit(
        state.copyWith(
          email: event.email,
          formErrors: {...state.formErrors, 'email': emailError},
          signupFailedMessage: null,
          clearSignupFailedMessage: true,
        ),
      );
    });

    on<PasswordChanged>((event, emit) {
      // Validate password on change
      final passwordError = _validatePassword(event.password);

      // Also validate confirm password if it's not empty
      String? confirmPasswordError;
      if (state.confirmPassword.isNotEmpty) {
        confirmPasswordError = _validateConfirmPassword(
          event.password,
          state.confirmPassword,
        );
      }

      emit(
        state.copyWith(
          password: event.password,
          formErrors: {
            ...state.formErrors,
            'password': passwordError,
            'confirmPassword': confirmPasswordError,
          },
          signupFailedMessage: null,
          clearSignupFailedMessage: true,
        ),
      );
    });

    on<ConfirmPasswordChanged>((event, emit) {
      // Validate confirm password on change
      final confirmPasswordError = _validateConfirmPassword(
        state.password,
        event.confirmPassword,
      );

      emit(
        state.copyWith(
          confirmPassword: event.confirmPassword,
          formErrors: {
            ...state.formErrors,
            'confirmPassword': confirmPasswordError,
          },
          signupFailedMessage: null,
          clearSignupFailedMessage: true,
        ),
      );
    });

    on<ShowPasswordChanged>((event, emit) {
      emit(state.copyWith(showPassword: event.showPassword));
    });

    on<ShowConfirmPasswordChanged>((event, emit) {
      emit(state.copyWith(showConfirmPassword: event.showConfirmPassword));
    });

    on<SignupSubmitted>((event, emit) async {
      // Validate all fields when form is submitted
      final nameError = _validateName(state.name);
      final emailError = _validateEmail(state.email);
      final passwordError = _validatePassword(state.password);
      final confirmPasswordError = _validateConfirmPassword(
        state.password,
        state.confirmPassword,
      );

      final errors = <String, String?>{};
      if (nameError != null) errors['name'] = nameError;
      if (emailError != null) errors['email'] = emailError;
      if (passwordError != null) errors['password'] = passwordError;
      if (confirmPasswordError != null) {
        errors['confirmPassword'] = confirmPasswordError;
      }

      if (errors.isEmpty) {
        // Form is valid - proceed with signup
        emit(
          state.copyWith(
            formSubmitted: true,
            isSubmitting: true,
            formErrors: {},
            clearFormErrors: true,
          ),
        );
        final result = await signupUseCase(SignupParams(
          name: state.name,
          email: state.email,
          password: state.password,
        ));
        emit(state.copyWith(isSubmitting: false, signupSuccessful: true));
      } else {
        // Form has errors
        emit(state.copyWith(formSubmitted: true, formErrors: errors));
      }
    });
  }

  // Validation helper methods
  String? _validateName(String name) {
    if (name.isEmpty) {
      return 'Please enter your name';
    }

    if (name.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null; // No error
  }

  String? _validateEmail(String email) {
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

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Please enter your password';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null; // No error
  }

  String? _validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null; // No error
  }
}
