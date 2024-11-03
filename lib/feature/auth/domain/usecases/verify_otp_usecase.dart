import '../repositories/user_repository.dart';

class VerifyOTPUsecase {
  final UsersRepository usersRepository;

  VerifyOTPUsecase(this.usersRepository);

  Future<String> call(String otp) async {
    return await usersRepository.verifyOTP(otp);
  }
}
