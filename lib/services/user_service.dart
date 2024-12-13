import 'package:cabosat/models/user_model.dart';
import 'package:cabosat/services/implementations/local_storage.dart';

class UserService {
  final LocalStorage localStorageService;

  UserService({
    required this.localStorageService,
  });

  Future<void> saveUser(UserModel user) async {
    await localStorageService.add('cpfcnpj', user.cpfcnpj);
    await localStorageService.add('senha', user.senha);
  }

  Future<UserModel?> getUser() async {
    String? cpfcnpj = await localStorageService.get("cpfcnpj");
    String? senha = await localStorageService.get("senha");

    if (cpfcnpj == null || senha == null) {
      return null;
    }

    return UserModel(cpfcnpj: cpfcnpj, senha: senha);
  }

  Future<void> removeUser() async {
    localStorageService.remove('user');
  }
}
