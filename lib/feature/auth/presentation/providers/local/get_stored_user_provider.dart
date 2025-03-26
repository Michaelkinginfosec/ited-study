import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ited_study/core/providers/providers.dart';
import 'package:ited_study/feature/auth/data/models/users.dart';
import 'package:ited_study/feature/auth/domain/usecases/remote/get_stored_user_usecase.dart';

enum StoredUserStatus { loading, success, initial, error }

class StoredUserState {
  final StoredUserStatus status;
  final Users? user;
  final String? error;
  StoredUserState({
    this.status = StoredUserStatus.initial,
    this.user,
    this.error,
  });

  StoredUserState copyWith({
    StoredUserStatus? status,
    String? error,
    Users? user,
  }) {
    return StoredUserState(
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }
}

class StoredUserNotifier extends StateNotifier<StoredUserState> {
  final GetStoredUserUsecase getStoredUserUsecase;
  StoredUserNotifier(this.getStoredUserUsecase) : super(StoredUserState());

  Future<void> getStored() async {
    state = state.copyWith(status: StoredUserStatus.loading);
    try {
      final user = await getStoredUserUsecase.getStoredUser();
      state = state.copyWith(status: StoredUserStatus.success, user: user);
    } catch (e) {
      state = state.copyWith(
        status: StoredUserStatus.error,
        error: e.toString(),
      );
    }
  }
}

final storedUserNotifierProvider =
    StateNotifierProvider<StoredUserNotifier, StoredUserState>(
  (ref) {
    return StoredUserNotifier(
      ref.read(getStoredUserUsecaseProvidr),
    );
  },
);
