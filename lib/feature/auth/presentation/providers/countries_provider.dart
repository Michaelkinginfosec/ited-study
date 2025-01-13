import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ited_study/core/providers/providers.dart';
import 'package:ited_study/feature/auth/domain/usecases/get_countries_usecase.dart';

enum CountryStatus { initail, loading, success, failure }

class CountryState {
  final CountryStatus status;
  final String? error;
  final String? message;

  CountryState({this.status = CountryStatus.initail, this.error, this.message});

  CountryState copyWith(
      {CountryStatus? status, String? error, String? message}) {
    return CountryState(
        status: status ?? this.status, error: error, message: message);
  }
}

class CountryNotifier extends StateNotifier<CountryState> {
  final GetCountriesUsecase countryUsecase;

  CountryNotifier(this.countryUsecase) : super(CountryState());
  Future<void> country() async {
    state = state.copyWith(status: CountryStatus.loading);
    try {
      await countryUsecase.countries();
      state = state.copyWith(status: CountryStatus.success);
    } catch (e) {
      state =
          state.copyWith(status: CountryStatus.failure, error: e.toString());
    }
  }
}

final countryNotifierProvider =
    StateNotifierProvider<CountryNotifier, CountryState>((ref) {
  return CountryNotifier(ref.read(countryUsecaseProvider));
});
