import 'dart:async';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_laravel_api_authentication/core/logging/app_logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_custom_laravel_api_authentication/core/dependency_injection/injection_container.dart';
import 'package:flutter_custom_laravel_api_authentication/core/router/app_router.dart';
import 'package:flutter_custom_laravel_api_authentication/core/theme/app_theme.dart';
import 'package:flutter_custom_laravel_api_authentication/firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
 
      try {
        await dotenv.load(fileName: '.env');
      } catch (e) {
        debugPrint('ENV load failed: $e');
      }

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final crashlyticsEnabled =
          (dotenv.env['SEND_ERRORS_TO_CRASHLYTICS'] ?? 'false').toLowerCase() ==
          'true';

      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        crashlyticsEnabled,
      );

      if (crashlyticsEnabled) {
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      }

      try {
        await initDependencies();
      } catch (e, s) {
        FirebaseCrashlytics.instance.recordError(e, s, fatal: true);
        rethrow;
      }
      

      AppLogger().logInfo('App initialized');
      AppLogger().logError('App initialized');

      runApp(const MainApp());
    },
    (error, stack) {
      final crashlyticsEnabled =
          (dotenv.env['SEND_ERRORS_TO_CRASHLYTICS'] ?? 'false').toLowerCase() ==
          'true';
      if (crashlyticsEnabled) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
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
