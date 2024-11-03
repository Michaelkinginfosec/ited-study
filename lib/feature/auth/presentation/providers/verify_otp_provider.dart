import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ited_study/feature/auth/domain/usecases/verify_otp_usecase.dart';

import '../../../../core/providers/providers.dart';

enum VerifyOTPStatus { initail, loading, success, failure }

class VerifyOTPState {
  final VerifyOTPStatus status;
  final String? error;
  final String? message;

  VerifyOTPState({
    this.status = VerifyOTPStatus.initail,
    this.error,
    this.message,
  });

  VerifyOTPState copyWith(
      {VerifyOTPStatus? status, String? error, String? message}) {
    return VerifyOTPState(
      status: status ?? this.status,
      error: error,
      message: message,
    );
  }
}

class VerifyOTPNotifier extends StateNotifier<VerifyOTPState> {
  final VerifyOTPUsecase verifyOTPUsecase;

  VerifyOTPNotifier(this.verifyOTPUsecase) : super(VerifyOTPState());
  Future<void> verifyOTP(String otp) async {
    state = state.copyWith(status: VerifyOTPStatus.loading);
    try {
      final message = await verifyOTPUsecase(otp);
      state = state.copyWith(status: VerifyOTPStatus.success, message: message);
    } catch (e) {
      state =
          state.copyWith(status: VerifyOTPStatus.failure, error: e.toString());
    }
  }
}

final verifyOTPNotifierProvider =
    StateNotifierProvider<VerifyOTPNotifier, VerifyOTPState>((ref) {
  return VerifyOTPNotifier(ref.read(verifyOTPUsecaseProvider));
});
