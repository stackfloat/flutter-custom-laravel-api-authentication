import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_laravel_api_authentication/core/logging/app_bloc_observer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:flutter_custom_laravel_api_authentication/core/dependency_injection/injection_container.dart';
import 'package:flutter_custom_laravel_api_authentication/core/router/app_router.dart';
import 'package:flutter_custom_laravel_api_authentication/core/theme/app_theme.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // ✅ Load ENV
      try {
        await dotenv.load(fileName: '.env');
      } catch (e) {
        debugPrint('ENV load failed: $e');
      }

      final sentryEnabled =
          (dotenv.env['SEND_ERRORS_TO_SENTRY'] ?? 'false').toLowerCase() ==
              'true';

      final sentryDsn = dotenv.env['SENTRY_DSN'];

      // ✅ Register BLoC observer FIRST (before DI)
      Bloc.observer = AppBlocObserver();

      // ✅ Flutter UI Errors (global)
      FlutterError.onError = (details) {
        if (sentryEnabled) {
          Sentry.captureException(
            details.exception,
            stackTrace: details.stack,
          );
        } else {
          FlutterError.dumpErrorToConsole(details);
        }
      };

      // ✅ Platform / Isolate Errors
      PlatformDispatcher.instance.onError = (error, stack) {
        if (sentryEnabled) {
          Sentry.captureException(error, stackTrace: stack);
          return true;
        }
        return false;
      };

      // ✅ Initialize Sentry ONLY if enabled
      if (sentryEnabled && sentryDsn != null && sentryDsn.isNotEmpty) {
        await SentryFlutter.init(
          (options) {
            options.dsn = sentryDsn;

            // ✅ ZERO-OVERHEAD PRODUCTION SETUP
            options.tracesSampleRate = 0.0;
            options.environment = dotenv.env['APP_ENV'] ?? 'production';
            options.enableAutoSessionTracking = true;
            options.attachStacktrace = true;
            options.sendDefaultPii = false;

            // ✅ Filter noise
            options.beforeSend = (event, hint) {
              if (options.environment != 'production') {
                return null;
              }

              final throwable = event.throwable.toString();

              if (throwable.contains('SocketException') ||
                  throwable.contains('HandshakeException')) {
                return null;
              }

              return event;
            };
          },
          appRunner: () async {
            try {
              await initDependencies();
            } catch (e, s) {
              Sentry.captureException(e, stackTrace: s);
              rethrow;
            }

            runApp(const MainApp());
          },
        );
      } else {
        // ✅ Sentry Disabled (DEV / LOCAL)
        try {
          await initDependencies();
        } catch (e, s) {
          FlutterError.dumpErrorToConsole(
            FlutterErrorDetails(exception: e, stack: s),
          );
          rethrow;
        }

        runApp(const MainApp());
      }
    },

    // ✅ Async Zone Errors (DO NOT await)
    (error, stack) {
      final sentryEnabled =
          (dotenv.env['SEND_ERRORS_TO_SENTRY'] ?? 'false').toLowerCase() ==
              'true';

      if (sentryEnabled) {
        Sentry.captureException(error, stackTrace: stack);
      } else {
        FlutterError.dumpErrorToConsole(
          FlutterErrorDetails(exception: error, stack: stack),
        );
      }
    },
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(400, 800),
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          theme: AppTheme.lightTheme,
          themeMode: ThemeMode.light,
        );
      },
    );
  }
}
