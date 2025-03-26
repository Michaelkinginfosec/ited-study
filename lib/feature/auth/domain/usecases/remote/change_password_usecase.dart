import 'package:ited_study/feature/auth/domain/repositories/user_repository.dart';

class ChangePasswordUsecase {
  final UsersRepository usersRepository;
  ChangePasswordUsecase(this.usersRepository);
  Future<String> changePassword(String oldPassword, String newPassword) async {
    return await usersRepository.changePassword(oldPassword, newPassword);
  }
}
