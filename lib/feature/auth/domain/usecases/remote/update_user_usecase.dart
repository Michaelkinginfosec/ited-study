import 'package:ited_study/feature/auth/domain/repositories/user_repository.dart';

import '../../../data/models/update_data.dart';

class UpdateUserUsecase {
  final UsersRepository usersRepository;
  UpdateUserUsecase(this.usersRepository);
  Future<void> updateUser(UpdateUserData updateData) async {
    await usersRepository.updateUser(updateData);
  }
}
