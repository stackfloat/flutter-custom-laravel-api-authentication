import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_laravel_api_authentication/core/logging/app_bloc_observer.dart';
import 'package:flutter_custom_laravel_api_authentication/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_custom_laravel_api_authentication/core/dependency_injection/injection_container.dart';
import 'package:flutter_custom_laravel_api_authentication/core/router/app_router.dart';
import 'package:flutter_custom_laravel_api_authentication/core/theme/app_theme.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await dotenv.load(fileName: ".env");

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      if (!kReleaseMode) {
        await FirebaseCrashlytics.instance.sendUnsentReports();
      }

      Bloc.observer = AppBlocObserver();

      final crashlyticsEnabled = dotenv.env['ENABLE_CRASHLYTICS'] == 'true';
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        crashlyticsEnabled,
      );

      FlutterError.onError = (details) {
        if (!kReleaseMode) FlutterError.dumpErrorToConsole(details);
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        if (!kReleaseMode) {
          FlutterError.dumpErrorToConsole(
            FlutterErrorDetails(exception: error, stack: stack),
          );
        }
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      try {
        await initDependencies();
      } catch (e, s) {
        if (!kReleaseMode) {
          FlutterError.dumpErrorToConsole(
            FlutterErrorDetails(exception: e, stack: s),
          );
        }
        FirebaseCrashlytics.instance.recordError(e, s, fatal: false);
        rethrow;
      }

      runApp(const MainApp());
    },
    (error, stack) {
      if (!kReleaseMode) {
        FlutterError.dumpErrorToConsole(
          FlutterErrorDetails(exception: error, stack: stack),
        );
      }
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
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
