// lib/feature/auth/presentation/providers/sign_up_notifier_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ited_study/feature/auth/data/models/users.dart';
import 'package:ited_study/feature/auth/domain/usecases/sign_up_usecase.dart';

import '../../../../core/providers/providers.dart';

enum SignUpStatus { initial, loading, success, failure }

class SignUpState {
  final SignUpStatus status;
  final String? error;
  final String? message; // Change user to message to store the response

  SignUpState({this.status = SignUpStatus.initial, this.error, this.message});

  SignUpState copyWith({SignUpStatus? status, String? error, String? message}) {
    return SignUpState(
      status: status ?? this.status,
      error: error,
      message: message,
    );
  }
}

class SignUpNotifier extends StateNotifier<SignUpState> {
  final SignUpUseCase signUpUseCase;

  SignUpNotifier(this.signUpUseCase) : super(SignUpState());

  Future<void> signUp(Users user) async {
    state = state.copyWith(status: SignUpStatus.loading);
    try {
      final message =
          await signUpUseCase.signUp(user); // Receive the message from use case
      state = state.copyWith(status: SignUpStatus.success, message: message);
    } catch (e) {
      state = state.copyWith(status: SignUpStatus.failure, error: e.toString());
    }
  }
}

final signUpNotifierProvider =
    StateNotifierProvider<SignUpNotifier, SignUpState>(
  (ref) {
    return SignUpNotifier(ref.read(signUpUseCaseProvider));
  },
);
