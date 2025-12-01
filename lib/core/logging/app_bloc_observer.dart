
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    Sentry.captureException(
      error,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('layer', 'bloc');
        scope.setContexts('bloc', {
          'type': bloc.runtimeType.toString(),
        });
      },
    );

    super.onError(bloc, error, stackTrace);
  }
}
