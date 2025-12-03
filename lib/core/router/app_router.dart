import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_laravel_api_authentication/core/dependency_injection/injection_container.dart';
import 'package:flutter_custom_laravel_api_authentication/core/services/secure_storage_service.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/usecases/login_usecase.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/domain/usecases/signup_usecase.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/presentation/bloc/login/login_bloc.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/presentation/bloc/logout/logout_cubit.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/presentation/bloc/signup/signup_bloc.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/presentation/screens/login_screen.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/presentation/screens/signup_screen.dart';
import 'package:flutter_custom_laravel_api_authentication/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:go_router/go_router.dart';

/// Application router configuration
///
/// This file contains all route definitions for the application.
/// In clean architecture, routing belongs in the core layer as it's
/// shared infrastructure used across all features.
class AppRouter {
  static const Set<String> _protectedPaths = {'/'};
  static const Set<String> _authPaths = {'/login', '/signup'};

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final secureStorage = getIt<SecureStorageService>();
      final token = await secureStorage.getAccessToken();
      final isLoggedIn = token != null && token.isNotEmpty;

      final location = 
          state.matchedLocation.isEmpty ? '/signup' : state.matchedLocation;

      final onAuthRoute = _authPaths.contains(location);
      final headingToProtected = _protectedPaths.contains(location);

      if (isLoggedIn && onAuthRoute) {
        return '/';
      }

      if (!isLoggedIn && headingToProtected) {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => BlocProvider(
          create: (context) =>
              LoginBloc(loginUseCase: getIt.get<LoginUseCase>()),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => BlocProvider(
          create: (context) =>
              SignupBloc(signupUseCase: getIt<SignupUseCase>()),
          child: const SignupScreen(),
        ),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<LogoutCubit>(),
          child: const DashboardScreen(),
        ),
      ),
    ],
  );
}
