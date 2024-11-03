import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ited_study/core/providers/providers.dart';
import 'package:ited_study/feature/auth/domain/usecases/create_school_usecase.dart';

enum CreateSchooStatus { initial, loading, success, error }

class CreateSchoolState {
  final CreateSchooStatus status;
  final String? message;
  final String? error;

  CreateSchoolState({
    this.status = CreateSchooStatus.initial,
    this.message,
    this.error,
  });

  CreateSchoolState copyWith({
    CreateSchooStatus? status,
    String? message,
    String? error,
  }) {
    return CreateSchoolState(
      status: status ?? this.status,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }
}

class CreateSchoolNotifier extends StateNotifier<CreateSchoolState> {
  final CreateSchoolUsecase createSchoolUsecase;
  CreateSchoolNotifier(this.createSchoolUsecase) : super(CreateSchoolState());

  Future<void> createSchool(String schoolName, String country) async {
    state = state.copyWith(status: CreateSchooStatus.loading);
    try {
      await createSchoolUsecase.createSchool(schoolName, country);
      state = state.copyWith(
        status: CreateSchooStatus.success,
      );
    } catch (e) {
      state = state.copyWith(
        status: CreateSchooStatus.error,
        error: e.toString(),
      );
    }
  }
}

final createSchoolNotifierProvider =
    StateNotifierProvider<CreateSchoolNotifier, CreateSchoolState>((ref) {
  return CreateSchoolNotifier(ref.watch(createSchoolUsecaseProvider));
});
