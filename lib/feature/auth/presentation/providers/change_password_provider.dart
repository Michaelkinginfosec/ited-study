import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ited_study/feature/auth/domain/usecases/change_password_usecase.dart';

import '../../../../core/providers/providers.dart';

enum ChangePasswordStatus { initial, success, loading, error }

class ChangePasswordState {
  final ChangePasswordStatus status;
  final String message;
  final String error;

  ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.message = '',
    this.error = '',
  });

  ChangePasswordState copyWith({
    ChangePasswordStatus? status,
    String? message,
    String? error,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }
}

class ChangepasswordNotifier extends StateNotifier<ChangePasswordState> {
  final ChangePasswordUsecase changePasswordUsecase;

  ChangepasswordNotifier(this.changePasswordUsecase)
      : super(ChangePasswordState());

  Future<void> changePassword(String oldPassword, String newPassword) async {
    state = state.copyWith(status: ChangePasswordStatus.loading);
    try {
      await changePasswordUsecase.changePassword(oldPassword, newPassword);
      state = state.copyWith(status: ChangePasswordStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: ChangePasswordStatus.error,
        error: e.toString(),
      );
    }
  }
}

final changePasswordNotifierProvider =
    StateNotifierProvider<ChangepasswordNotifier, ChangePasswordState>(
  (ref) {
    return ChangepasswordNotifier(ref.read(changePasswordUsecaseProvider));
  },
);
