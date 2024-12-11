import 'package:cabosat/models/contract_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContractService {
  final String _url = "https://cabosat.sgp.net.br";

  Future<List<ContractModel>> loadContracts(
      String cpfcnpj, String senha) async {
    try {
      final httpRequest =
          await http.post(Uri.parse('$_url/api/central/contratos'),
              body: jsonEncode({
                'cpfcnpj': cpfcnpj,
                'senha': senha,
              }),
              headers: {'Content-Type': 'application/json; charset=utf-8'});

      if (httpRequest.statusCode != 200) {
        return [];
      }

      var body = json.decode(utf8.decode(httpRequest.bodyBytes));

      List<ContractModel> contracts = List<ContractModel>.from(body["contratos"]
          .map((json) => ContractModel.fromJson(json as Map<String, dynamic>)));

      return contracts;
    } catch (e) {
      return [];
    }
  }
}
