import 'package:ited_study/feature/auth/domain/repositories/user_repository.dart';

class LogoutUsecase {
  final UsersRepository usersRepository;

  LogoutUsecase(this.usersRepository);

  Future<String> call() async {
    return await usersRepository.logout();
  }
}
