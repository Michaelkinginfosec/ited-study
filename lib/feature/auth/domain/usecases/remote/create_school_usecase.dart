import 'package:ited_study/feature/auth/domain/repositories/user_repository.dart';

class CreateSchoolUsecase {
  final UsersRepository usersRepository;

  CreateSchoolUsecase(this.usersRepository);
  Future<void> createSchool(String schoolName, String country) async {
    return usersRepository.createSchool(schoolName, country);
  }
}
