import 'package:flutter/material.dart';
import 'package:flutter_custom_laravel_api_authentication/core/dependency_injection/injection_container.dart';
import 'package:flutter_custom_laravel_api_authentication/core/router/app_router.dart';
import 'package:flutter_custom_laravel_api_authentication/core/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await initDependencies();

  // Run the app
  runApp(const MainApp());
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
