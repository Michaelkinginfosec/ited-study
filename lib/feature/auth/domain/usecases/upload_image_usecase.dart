import 'dart:typed_data';

import '../repositories/user_repository.dart';

class UploadImageUsecase {
  final UsersRepository repository;

  UploadImageUsecase(this.repository);
  Future<String> uploadImage(Uint8List? image) async {
    return await repository.uploadImage(image);
  }
}
