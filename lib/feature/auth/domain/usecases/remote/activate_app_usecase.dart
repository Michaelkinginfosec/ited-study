import '../../repositories/user_repository.dart';

class ActivateApp {
  final UsersRepository repository;

  ActivateApp(this.repository);
  Future<String> activateApp(String code, String device, String model,
      String osVersion, String uniqueId, String semester) async {
    return await repository.activateApp(
        code, device, model, osVersion, uniqueId, semester);
  }
}
