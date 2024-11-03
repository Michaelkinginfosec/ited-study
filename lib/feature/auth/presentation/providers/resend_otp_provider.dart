import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ited_study/core/providers/providers.dart';
import 'package:ited_study/feature/auth/domain/usecases/resend_otp_usecase.dart';

enum ResendOTPStatus {
  initial,
  loading,
  success,
  failure,
}

class ResendOTPState {
  final ResendOTPStatus status;
  final String? error;
  final String? message;

  ResendOTPState(
      {this.status = ResendOTPStatus.initial, this.error, this.message});

  ResendOTPState copyWith(
      {ResendOTPStatus? status, String? error, String? message}) {
    return ResendOTPState(
        status: status ?? this.status, error: error, message: message);
  }
}

class ResendOTPCodeNotifier extends StateNotifier<ResendOTPState> {
  final ResendOTPUsecase resendOTPUsecase;

  ResendOTPCodeNotifier(this.resendOTPUsecase) : super(ResendOTPState());
  Future<void> resendOTPCode(String email) async {
    state = state.copyWith(status: ResendOTPStatus.initial);
    try {
      final message = await resendOTPUsecase(email);
      state = state.copyWith(status: ResendOTPStatus.success, message: message);
    } catch (e) {
      state =
          state.copyWith(status: ResendOTPStatus.failure, error: e.toString());
    }
  }
}

final resendOTPNotifierProvider =
    StateNotifierProvider<ResendOTPCodeNotifier, ResendOTPState>((ref) {
  return ResendOTPCodeNotifier(ref.read(resendOTPUsecaseProvider));
});
