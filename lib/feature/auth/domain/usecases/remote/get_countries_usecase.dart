import 'package:ited_study/feature/auth/domain/repositories/user_repository.dart';

class GetCountriesUsecase {
  final UsersRepository usersRepository;

  GetCountriesUsecase(this.usersRepository);

  Future<void> countries() async {
    return await usersRepository.getCountries();
  }
}
