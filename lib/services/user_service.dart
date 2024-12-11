import 'package:cabosat/models/user_model.dart';
import 'package:cabosat/services/local_storage_service.dart';
import 'dart:convert';

class UserService {
  final LocalStorageService localStorageService;

  UserService({
    required this.localStorageService,
  });

  Future<void> saveUser(UserModel user) async {
    String encodedUser = json.encode({
      'cpfcnpj': user.cpfcnpj,
      'senha': user.senha,
    });

    localStorageService.add('user', encodedUser);
  }

  Future<UserModel?> getUser() async {
    var user = await localStorageService.get("user");

    if (user == null) return null;
    user = json.decode(user);

    return UserModel(
      cpfcnpj: user['cpfcnpj']!,
      senha: user['senha']!,
    );
  }

  Future<void> removeUser() async {
    localStorageService.remove('user');
  }
}
