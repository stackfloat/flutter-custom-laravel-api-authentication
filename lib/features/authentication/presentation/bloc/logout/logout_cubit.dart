import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/logout_usecase.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase logoutUseCase;

  LogoutCubit({required this.logoutUseCase})
      : super(const LogoutState.initial());

  Future<void> logout() async {
    emit(state.copyWith(status: LogoutStatus.inProgress, errorMessage: null));

    final result = await logoutUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LogoutStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: LogoutStatus.success,
          errorMessage: null,
        ),
      ),
    );
  }

  void reset() {
    emit(const LogoutState.initial());
  }
}

