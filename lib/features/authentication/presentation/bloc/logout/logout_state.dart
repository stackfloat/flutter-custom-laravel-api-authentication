part of 'logout_cubit.dart';

enum LogoutStatus { initial, inProgress, success, failure }

class LogoutState extends Equatable {
  final LogoutStatus status;
  final String? errorMessage;

  const LogoutState({
    required this.status,
    required this.errorMessage,
  });

  const LogoutState.initial()
      : status = LogoutStatus.initial,
        errorMessage = null;

  LogoutState copyWith({
    LogoutStatus? status,
    String? errorMessage,
  }) {
    return LogoutState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

