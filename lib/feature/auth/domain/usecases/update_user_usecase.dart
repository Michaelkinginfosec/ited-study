import 'package:ited_study/feature/auth/domain/repositories/user_repository.dart';

class UpdateUserUsecase {
  final UsersRepository usersRepository;
  UpdateUserUsecase(this.usersRepository);
  Future<void> updateUser(
      String fullName, String department, String level) async {
    await usersRepository.updateUser(fullName, department, level);
  }
}
