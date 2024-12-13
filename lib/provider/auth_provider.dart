import 'package:cabosat/models/user_model.dart';
import 'package:cabosat/services/auth_service.dart';
import 'package:cabosat/services/secure_storage_service.dart';
import 'package:cabosat/services/sqflite_service.dart';
import 'package:cabosat/services/user_service.dart';
import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  UserModel? _auth;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  UserModel? get auth => _auth;

  UserService _userService() {
    return UserService(
      localStorageService: SecureStorageService(),
    );
  }

  void _setUser(UserModel user) async {
    await _userService().saveUser(user);
    _auth = user;
  }

  void _removeUser() {
    _userService().removeUser();
    _auth = null;
  }

  void _getUser() async {
    UserModel? user = await _userService().getUser();

    if (user != null) {
      _auth = UserModel(cpfcnpj: user.cpfcnpj, senha: user.senha);
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Usuário ou senha inválidos'),
          content: const Text('Por favor, tente novamente.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> login(
      {required String cpfcnpj,
      required String senha,
      required BuildContext context}) async {
    try {
      if (cpfcnpj.isEmpty || senha.isEmpty) {
        _showDialog(context);

        _isAuthenticated = false;
        notifyListeners();

        return false;
      }

      _isLoading = true;
      notifyListeners();

      _isAuthenticated = await AuthService().login(cpfcnpj, senha);

      if (!_isAuthenticated && context.mounted) {
        _showDialog(context);
      }

      if (_isAuthenticated) {
        _setUser(UserModel(cpfcnpj: cpfcnpj, senha: senha));
        notifyListeners();
      }

      notifyListeners();
    } catch (e) {
      _isAuthenticated = false;
      notifyListeners();

      if (context.mounted) _showDialog(context);
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _isAuthenticated;
  }

  void logout() async {
    _isAuthenticated = false;
    _removeUser();
    notifyListeners();
  }

  void getCurrentUser() {
    _getUser();
  }
}
