import 'package:ited_study/feature/auth/domain/repositories/user_repository.dart';

class ResendOTPUsecase {
  final UsersRepository usersRepository;

  ResendOTPUsecase(this.usersRepository);

  Future<String> call(String email) async {
    return await usersRepository.resendVerificationCode(email);
  }
}
