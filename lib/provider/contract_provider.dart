import 'package:cabosat/models/contract_model.dart';
import 'package:cabosat/models/user_model.dart';
import 'package:cabosat/services/contract_service.dart';
import 'package:cabosat/services/local_storage_service.dart';
import 'package:cabosat/services/user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ContractProvider extends ChangeNotifier {
  bool _isLoading = true;
  ContractModel? _currentContract;
  List<ContractModel> _contracts = [];

  bool get isLoading => _isLoading;
  List<ContractModel> get contracts => _contracts;
  ContractModel? get currentContract => _currentContract;

  Future<void> loadContracts() async {
    try {
      _isLoading = true;
      notifyListeners();

      UserModel? user =
          await UserService(localStorageService: LocalStorageService())
              .getUser();

      if (user == null) {
        _isLoading = false;
        _contracts = [];
        _currentContract = null;
        notifyListeners();

        return;
      }

      _contracts =
          await ContractService().loadContracts(user.cpfcnpj, user.senha);
      notifyListeners();

      if (_contracts.isEmpty) {
        _isLoading = false;
        notifyListeners();

        return;
      }

      _currentContract = _contracts.first;
      _isLoading = false;
      notifyListeners();

      if (_currentContract != null) {
        String? city = _currentContract?.enderecoInstalacao?.cidade;

        if (city != null) {
          String cityNormalized = city
              .toLowerCase()
              .replaceAll(' ', '_')
              .replaceAll('á', 'a')
              .replaceAll('é', 'e')
              .replaceAll('í', 'i')
              .replaceAll('ó', 'o')
              .replaceAll('ú', 'u')
              .replaceAll('ã', 'a')
              .replaceAll('õ', 'o')
              .replaceAll('â', 'a')
              .replaceAll('ê', 'e')
              .replaceAll('î', 'i')
              .replaceAll('ô', 'o')
              .replaceAll('û', 'u')
              .replaceAll('ç', 'c');

          await FirebaseMessaging.instance.subscribeToTopic(cityNormalized);
        }
      }
    } finally {}
  }
}
