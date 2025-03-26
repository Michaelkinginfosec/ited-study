import 'package:ited_study/feature/auth/domain/repositories/user_repository.dart';

class GetStoredCountriesUsecase {
  final UsersRepository usersRepository;

  GetStoredCountriesUsecase(this.usersRepository);

  Future<List<String>> getCountreis() async {
    return await usersRepository.getStoredCountries();
  }
}
