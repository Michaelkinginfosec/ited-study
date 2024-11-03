import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ited_study/core/providers/providers.dart';

import '../../domain/usecases/logout_usecase.dart';

enum LogoutStatus { initail, loading, success, failure }

class LogoutState {
  final LogoutStatus status;
  final String? error;
  final String? message;

  LogoutState({this.status = LogoutStatus.initail, this.error, this.message});

  LogoutState copyWith({LogoutStatus? status, String? error, String? message}) {
    return LogoutState(
        status: status ?? this.status, error: error, message: message);
  }
}

class LogoutNotifier extends StateNotifier<LogoutState> {
  final LogoutUsecase logoutUsecase;

  LogoutNotifier(this.logoutUsecase) : super(LogoutState());
  Future<void> logout() async {
    state = state.copyWith(status: LogoutStatus.loading);
    try {
      final message = await logoutUsecase();
      state = state.copyWith(status: LogoutStatus.success, message: message);
    } catch (e) {
      state = state.copyWith(status: LogoutStatus.failure, error: e.toString());
    }
  }
}

final logoutNotifierProvider =
    StateNotifierProvider<LogoutNotifier, LogoutState>((ref) {
  return LogoutNotifier(ref.read(logoutUsecaseProvider));
});
