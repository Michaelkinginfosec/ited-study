import '../repositories/user_repository.dart';

class ResetPasswordUsecase {
  final UsersRepository usersRepository;

  ResetPasswordUsecase(this.usersRepository);

  Future<String?> call(String otp, String newPassword) async {
    return await usersRepository.resetPassword(otp, newPassword);
  }
}
