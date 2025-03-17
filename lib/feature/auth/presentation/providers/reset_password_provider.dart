import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ited_study/core/providers/providers.dart';
import 'package:ited_study/feature/auth/domain/usecases/reset_password_usecase.dart';

enum ResetPasswordStatus { initial, loading, success, failure }

class ResetPasswordState {
  final ResetPasswordStatus status;
  final String? error;
  final String? message;

  ResetPasswordState({
    this.status = ResetPasswordStatus.initial,
    this.error,
    this.message,
  });

  ResetPasswordState copyWith({
    ResetPasswordStatus? status,
    String? error,
    String? message,
  }) {
    return ResetPasswordState(
      status: status ?? this.status,
      error: error,
      message: message,
    );
  }
}

class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  final ResetPasswordUsecase _resetPasswordUsecase;

  ResetPasswordNotifier(this._resetPasswordUsecase)
      : super(ResetPasswordState());
  Future<void> resetPassword(String otp, String newPassword) async {
    state = state.copyWith(status: ResetPasswordStatus.loading);
    try {
      final message = await _resetPasswordUsecase.call(otp, newPassword);
      state =
          state.copyWith(status: ResetPasswordStatus.success, message: message);
    } catch (e) {
      state = state.copyWith(
          status: ResetPasswordStatus.failure, error: e.toString());
    }
  }
}

final resetPasswordNotifierProvider =
    StateNotifierProvider<ResetPasswordNotifier, ResetPasswordState>((ref) {
  return ResetPasswordNotifier(ref.read(resetPasswordUsecaseProvider));
});
