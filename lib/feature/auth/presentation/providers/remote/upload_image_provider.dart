import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/providers/providers.dart';
import '../../../domain/usecases/remote/upload_image_usecase.dart';

enum UploadImageStatus { initial, loading, success, error }

class UploadImageState {
  final UploadImageStatus status;
  final String? message;
  final String? error;

  UploadImageState({
    this.status = UploadImageStatus.initial,
    this.message,
    this.error,
  });

  UploadImageState copyWith({
    UploadImageStatus? status,
    String? message,
    String? error,
  }) {
    return UploadImageState(
      status: status ?? this.status,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }
}

class UploadImageNotifier extends StateNotifier<UploadImageState> {
  final UploadImageUsecase uploadImageUsecase;
  UploadImageNotifier(this.uploadImageUsecase) : super(UploadImageState());

  Future<String> uploadImage(Uint8List? image) async {
    state = state.copyWith(status: UploadImageStatus.loading);
    try {
      final imageUrl = await uploadImageUsecase.uploadImage(image);
      state = state.copyWith(status: UploadImageStatus.success);
      return imageUrl;
    } catch (e) {
      state =
          state.copyWith(status: UploadImageStatus.error, error: e.toString());
      return e.toString();
    }
  }
}

final uploadImageNotifierProvider =
    StateNotifierProvider<UploadImageNotifier, UploadImageState>(
  (ref) {
    return UploadImageNotifier(ref.watch(uploadImageUsecaseProvider));
  },
);
