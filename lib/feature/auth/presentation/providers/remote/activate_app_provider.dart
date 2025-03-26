import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/providers/providers.dart';
import '../../../domain/usecases/remote/activate_app_usecase.dart';

enum ActivateStatus { initial, loading, success, error }

class ActivateAppState {
  final ActivateStatus status;
  final String? message;
  final String? error;

  ActivateAppState({
    this.status = ActivateStatus.initial,
    this.message,
    this.error,
  });

  ActivateAppState copyWith({
    ActivateStatus? status,
    String? message,
    String? error,
  }) {
    return ActivateAppState(
      status: status ?? this.status,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }
}

class UploadUserImageNotifier extends StateNotifier<ActivateAppState> {
  final ActivateApp uploadUserImageUsecase;
  UploadUserImageNotifier(this.uploadUserImageUsecase)
      : super(ActivateAppState());
  Future<void> activateApp(String code, String device, String model,
      String osVersion, String uniqueId, String semester) async {
    state = state.copyWith(status: ActivateStatus.loading);
    try {
      await uploadUserImageUsecase.activateApp(
          code, device, model, osVersion, uniqueId, semester);
      state = state.copyWith(status: ActivateStatus.success);
    } catch (e) {
      state = state.copyWith(status: ActivateStatus.error, error: e.toString());
    }
  }
}

final activateAppNotifierProvider =
    StateNotifierProvider<UploadUserImageNotifier, ActivateAppState>((ref) {
  return UploadUserImageNotifier(ref.watch(activateAppUsecaseProvider));
});
