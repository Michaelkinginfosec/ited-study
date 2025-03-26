import 'package:ited_study/feature/auth/domain/repositories/user_repository.dart';

class LoginUsecase {
  final UsersRepository usersRepository;

  LoginUsecase(this.usersRepository);

  Future<String> login(String email, String password) async {
    return await usersRepository.login(email, password);
  }
}
