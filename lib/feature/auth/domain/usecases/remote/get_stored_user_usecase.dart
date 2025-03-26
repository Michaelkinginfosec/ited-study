import 'package:ited_study/feature/auth/data/models/users.dart';

import '../../repositories/user_repository.dart';

class GetStoredUserUsecase {
  final UsersRepository usersRepository;

  GetStoredUserUsecase(this.usersRepository);

  Future<Users> getStoredUser() async {
    return await usersRepository.getStoredUser();
  }
}
