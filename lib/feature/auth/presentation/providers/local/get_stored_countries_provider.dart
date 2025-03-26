import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ited_study/core/providers/providers.dart';
import 'package:ited_study/feature/auth/domain/usecases/local/get_stored_countries_usecase.dart';

enum GetStoredCountriesStatus { loading, success, initial, error }

class GetStoredCountriesState {
  final GetStoredCountriesStatus status;
  final List<String>? data;
  final String? error;
  GetStoredCountriesState({
    this.status = GetStoredCountriesStatus.initial,
    this.data,
    this.error,
  });

  GetStoredCountriesState copyWith({
    GetStoredCountriesStatus? status,
    String? error,
    List<String>? data,
  }) {
    return GetStoredCountriesState(
      status: status ?? this.status,
      error: error ?? this.error,
      data: data ?? data,
    );
  }
}

class GetStoredCountriesNotifier
    extends StateNotifier<GetStoredCountriesState> {
  final GetStoredCountriesUsecase _getStoredCountriesUsecase;
  GetStoredCountriesNotifier(this._getStoredCountriesUsecase)
      : super(GetStoredCountriesState());

  Future<void> getStoredCountries() async {
    state = state.copyWith(status: GetStoredCountriesStatus.loading);
    try {
      final data = await _getStoredCountriesUsecase.getCountreis();
      state =
          state.copyWith(status: GetStoredCountriesStatus.success, data: data);
    } catch (e) {
      state = state.copyWith(
        status: GetStoredCountriesStatus.error,
        error: e.toString(),
      );
    }
  }
}

final getStoredCountriesNotifierProvider =
    StateNotifierProvider<GetStoredCountriesNotifier, GetStoredCountriesState>(
  (ref) {
    return GetStoredCountriesNotifier(
      ref.read(getStoredCountryUsecaseProvider),
    );
  },
);
