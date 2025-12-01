import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../core/widgets/text_field_widget.dart';
import '../bloc/login/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        // Handle side effects (navigation, snackbars, etc.)
        if (state.loginSuccessful) {
          // Navigate to home/dashboard
          // context.go('/home');
        }

        if (state.loginFailedMessage != null) {
          // Show error snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.loginFailedMessage!),
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
                      Icons.lock_outline,
                      size: 100,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.3),
                    ),
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    TextFieldWidget(
                      textFieldlabel: 'Email',
                      errorText: state.formSubmitted ? state.formErrors['email'] : null,
                      keyboardType: TextInputType.emailAddress,
                      onChangedFn: (value) {
                        context.read<LoginBloc>().add(
                          EmailChanged(email: value),
                        );
                      },
                    ),
                    TextFieldWidget(
                      textFieldlabel: 'Password',
                      errorText: state.formSubmitted
                          ? state.formErrors['password']
                          : null,
                      isPassword: true,
                      revealPassword: state.showPassword,
                      onRevealPasswordFn: () {
                        context.read<LoginBloc>().add(
                          ShowPasswordChanged(
                            showPassword: !state.showPassword,
                          ),
                        );
                      },
                      onChangedFn: (value) {
                        context.read<LoginBloc>().add(
                          PasswordChanged(password: value),
                        );
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.isSubmitting
                            ? null
                            : () {
                                context.read<LoginBloc>().add(
                                  const LoginSubmitted(),
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
                            : const Text("Login"),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to signup
                        context.go('/signup');
                      },
                      child: const Text("Don't have an account? Sign up"),
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
