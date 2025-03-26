import 'package:ited_study/feature/auth/domain/repositories/user_repository.dart';

class SendVerificationCodeUsecase {
  final UsersRepository usersRepository;

  SendVerificationCodeUsecase(this.usersRepository);

  Future<String> call(String email) async {
    return await usersRepository.resendVerificationCode(email);
  }
}
