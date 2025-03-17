import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ited_study/core/providers/providers.dart';

import '../../domain/usecases/resend_verification_code_usecase.dart';

enum ResendVerificationCodeStatus { initial, loading, success, failure }

class ResendVerificationCodeState {
  final ResendVerificationCodeStatus status;
  final String? error;
  final String? message;

  ResendVerificationCodeState(
      {this.status = ResendVerificationCodeStatus.initial,
      this.error,
      this.message});

  ResendVerificationCodeState copyWith(
      {ResendVerificationCodeStatus? status, String? error, String? message}) {
    return ResendVerificationCodeState(
        status: status ?? this.status, error: error, message: message);
  }
}

class ResendVerificationCodeNotifier
    extends StateNotifier<ResendVerificationCodeState> {
  final SendVerificationCodeUsecase resendVerificationCodeUsecase;

  ResendVerificationCodeNotifier(this.resendVerificationCodeUsecase)
      : super(ResendVerificationCodeState());
  Future<void> resendVerificationCode(String email) async {
    state = state.copyWith(status: ResendVerificationCodeStatus.loading);
    try {
      final message = await resendVerificationCodeUsecase.call(email);
      state = state.copyWith(
          status: ResendVerificationCodeStatus.success, message: message);
    } catch (e) {
      state = state.copyWith(
          status: ResendVerificationCodeStatus.failure, error: e.toString());
    }
  }
}

final resendVerificationCodeNotifier = StateNotifierProvider<
    ResendVerificationCodeNotifier, ResendVerificationCodeState>(
  (ref) {
    return ResendVerificationCodeNotifier(
      ref.read(resendVerificationUsecaseProvider),
    );
  },
);
