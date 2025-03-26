import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ited_study/core/providers/providers.dart';
import 'package:ited_study/feature/auth/domain/usecases/local/get_stored_school_usecase.dart';

enum GetStoredSchooStatus { loading, success, initial, error }

class GetStoredSchoolState {
  final GetStoredSchooStatus status;
  final List<String>? data;
  final String? error;
  GetStoredSchoolState({
    this.status = GetStoredSchooStatus.initial,
    this.data,
    this.error,
  });

  GetStoredSchoolState copyWith({
    GetStoredSchooStatus? status,
    String? error,
    List<String>? data,
  }) {
    return GetStoredSchoolState(
      status: status ?? this.status,
      error: error ?? this.error,
      data: data ?? data,
    );
  }
}

class GetStoredSchoolNotifier extends StateNotifier<GetStoredSchoolState> {
  final GetStoredSchoolUsecase _getStoredSchoolUsecase;
  GetStoredSchoolNotifier(this._getStoredSchoolUsecase)
      : super(GetStoredSchoolState());

  Future<void> getStoredSchool(String country) async {
    state = state.copyWith(status: GetStoredSchooStatus.loading);
    try {
      final data = await _getStoredSchoolUsecase.getStoredSchool(country);
      state = state.copyWith(status: GetStoredSchooStatus.success, data: data);
    } catch (e) {
      state = state.copyWith(
        status: GetStoredSchooStatus.error,
        error: e.toString(),
      );
    }
  }
}

final getStoredSchoolNotifierProvider =
    StateNotifierProvider<GetStoredSchoolNotifier, GetStoredSchoolState>(
  (ref) {
    return GetStoredSchoolNotifier(
      ref.read(getStoredSchoolUsecaseProvider),
    );
  },
);
