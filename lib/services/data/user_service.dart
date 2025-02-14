import 'package:cabosat/models/user_model.dart';
import 'package:cabosat/services/storage/secure_storage_service.dart';
import 'package:cabosat/services/storage/sqflite_service.dart';

class UserService {
  final SecureStorageService _secureStorageService = SecureStorageService();

  Future<void> saveUser(UserModel user) async {
    await _secureStorageService.add('cpfcnpj', user.cpfcnpj);
    await _secureStorageService.add('senha', user.senha);
  }

  Future<UserModel?> getUser() async {
    String? cpfcnpj = await _secureStorageService.get("cpfcnpj");
    String? senha = await _secureStorageService.get("senha");

    if (cpfcnpj == null || senha == null) {
      return null;
    }

    return UserModel(cpfcnpj: cpfcnpj, senha: senha);
  }

  Future<void> removeUser() async {
    try {
      await _secureStorageService.remove('cpfcnpj');
      await _secureStorageService.remove('senha');

      await SqfliteService().deleteAllData("invoice");
      await SqfliteService().deleteAllData("contract");
      await SqfliteService().deleteAllData("notification");
    } finally {}
  }
}
