import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/text_field_widget.dart';
import '../bloc/signup/signup_bloc.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, SignupState>(
      listener: (context, state) {
        // Handle side effects (navigation, snackbars, etc.)
        if (state.signupSuccessful) {
          // Navigate to login or dashboard
          context.go('/dashboard');
        }

        if (state.signupFailedMessage != null) {
          // Show error snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.signupFailedMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 25,
                  children: [
                    Icon(
                      Icons.person_add_outlined,
                      size: 100,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                    ),
                    Text(
                      'Sign Up',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    TextFieldWidget(
                      textFieldlabel: 'Name',
                      errorText: state.formSubmitted ? state.formErrors['name'] : null,
                      keyboardType: TextInputType.name,
                      onChangedFn: (value) {
                        context.read<SignupBloc>().add(
                          NameChanged(name: value),
                        );
                      },
                    ),
                    TextFieldWidget(
                      textFieldlabel: 'Email',
                      errorText: state.formSubmitted ? state.formErrors['email'] : null,
                      keyboardType: TextInputType.emailAddress,
                      onChangedFn: (value) {
                        context.read<SignupBloc>().add(
                          EmailChanged(email: value),
                        );
                      },
                    ),
                    TextFieldWidget(
                      textFieldlabel: 'Password',
                      errorText: state.formSubmitted ? state.formErrors['password'] : null,
                      isPassword: true,
                      revealPassword: state.showPassword,
                      onRevealPasswordFn: () {
                        context.read<SignupBloc>().add(
                          ShowPasswordChanged(
                            showPassword: !state.showPassword,
                          ),
                        );
                      },
                      onChangedFn: (value) {
                        context.read<SignupBloc>().add(
                          PasswordChanged(password: value),
                        );
                      },
                    ),
                    TextFieldWidget(
                      textFieldlabel: 'Confirm Password',
                      errorText: state.formSubmitted ? state.formErrors['confirmPassword'] : null,
                      isPassword: true,
                      revealPassword: state.showConfirmPassword,
                      onRevealPasswordFn: () {
                        context.read<SignupBloc>().add(
                          ShowConfirmPasswordChanged(
                            showConfirmPassword: !state.showConfirmPassword,
                          ),
                        );
                      },
                      onChangedFn: (value) {
                        context.read<SignupBloc>().add(
                          ConfirmPasswordChanged(confirmPassword: value),
                        );
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.isSubmitting
                            ? null
                            : () {
                                context.read<SignupBloc>().add(
                                  const SignupSubmitted(),
                                );
                              },
                        child: state.isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Sign Up"),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to login
                        context.go('/login');
                      },
                      child: const Text("Already have an account? Login"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
