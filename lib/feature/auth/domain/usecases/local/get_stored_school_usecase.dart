import 'package:ited_study/feature/auth/domain/repositories/user_repository.dart';

class GetStoredSchoolUsecase {
  final UsersRepository usersRepository;

  GetStoredSchoolUsecase(this.usersRepository);

  Future<List<String>> getStoredSchool(String country) async {
    return await usersRepository.getStoredSchools(country);
  }
}
