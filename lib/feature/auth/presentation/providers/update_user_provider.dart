import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ited_study/core/providers/providers.dart';
import 'package:ited_study/feature/auth/domain/usecases/update_user_usecase.dart';

enum UpdateuserStatus { initial, success, error, loading }

class UpdateUserState {
  final UpdateuserStatus status;
  final String? error;
  final String? message;
  UpdateUserState({
    this.status = UpdateuserStatus.initial,
    this.error,
    this.message,
  });
  UpdateUserState copyWith({
    UpdateuserStatus? status,
    String? error,
    String? message,
  }) {
    return UpdateUserState(
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }
}

class UpdateUserNotifier extends StateNotifier<UpdateUserState> {
  final UpdateUserUsecase updateUserUsecase;
  UpdateUserNotifier(this.updateUserUsecase) : super(UpdateUserState());

  Future<void> updateUser(
      String fullName, String department, String level) async {
    state = state.copyWith(status: UpdateuserStatus.loading);
    try {
      await updateUserUsecase.updateUser(fullName, department, level);

      state = state.copyWith(
        status: UpdateuserStatus.success,
      );
    } catch (e) {
      state =
          state.copyWith(status: UpdateuserStatus.error, error: e.toString());
    }
  }
}

final updateUserNotifierProvider =
    StateNotifierProvider<UpdateUserNotifier, UpdateUserState>(
  (ref) {
    return UpdateUserNotifier(
      ref.read(updateUserUsecaseProvidr),
    );
  },
);
