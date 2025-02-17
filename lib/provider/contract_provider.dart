import 'dart:convert';

import 'package:cabosat/models/contract_model.dart';
import 'package:cabosat/models/user_model.dart';
import 'package:cabosat/services/data/contract_service.dart';
import 'package:cabosat/services/storage/sqflite_service.dart';
import 'package:cabosat/services/data/user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ContractProvider extends ChangeNotifier {
  bool _isLoading = true;
  ContractModel? _currentContract;
  List<ContractModel> _contracts = [];
  String? _topic;

  bool get isLoading => _isLoading;
  List<ContractModel> get contracts => _contracts;
  ContractModel? get currentContract => _currentContract;

  String? get topic => _topic;

  Future<void> loadContracts() async {
    try {
      _isLoading = true;
      notifyListeners();

      ContractService contractService = ContractService();

      UserModel? user = await UserService().getUser();

      if (user == null) {
        _isLoading = false;
        _contracts = [];
        _currentContract = null;
        notifyListeners();

        return;
      }

      SqfliteService sqfliteService = SqfliteService();

      List<Map<String, dynamic>> cachedContracts =
          await sqfliteService.getData("contract");

      if (cachedContracts.isNotEmpty) {
        List<dynamic> parsedContract = json.decode(cachedContracts[0]['json']);

        _contracts =
            parsedContract.map((e) => ContractModel.fromJson(e)).toList();

        _currentContract = _contracts.first;

        _isLoading = false;
        notifyListeners();

        _contracts =
            await contractService.loadContracts(user.cpfcnpj, user.senha);

        await sqfliteService.updateData("contract", {
          "json": json.encode(_contracts.map((e) => e.toJson()).toList()),
          "id": '1'
        });
        notifyListeners();
      } else {
        _contracts =
            await contractService.loadContracts(user.cpfcnpj, user.senha);

        await sqfliteService.insertData("contract", {
          "json": json.encode(_contracts.map((e) => e.toJson()).toList()),
          "id": '1'
        });

        notifyListeners();
      }

      if (_contracts.isEmpty) {
        return;
      }

      _currentContract = _contracts.first;

      if (_currentContract != null) {
        String? city = _currentContract?.enderecoInstalacao?.cidade;

        if (city != null) {
          _topic = _getTopic(city);

          await FirebaseMessaging.instance.subscribeToTopic(_topic!);

          notifyListeners();
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  _getTopic(String city) {
    return city
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
  }
}
