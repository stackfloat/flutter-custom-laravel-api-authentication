import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_laravel_api_authentication/features/authentication/presentation/bloc/login/login_bloc.dart';
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
  static final GoRouter router = GoRouter(
    initialLocation: '/signup',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => BlocProvider(
          create: (context) => LoginBloc(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => BlocProvider(
          create: (context) => SignupBloc(),
          child: const SignupScreen(),
        ),
      ),      
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => BlocProvider(
          create: (context) => LoginBloc(),
          child: DashboardScreen(),
        ),
      ),
    ],
  );
}
