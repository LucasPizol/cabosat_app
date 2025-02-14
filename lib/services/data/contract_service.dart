import 'package:cabosat/models/contract_model.dart';
import 'package:cabosat/services/http_service.dart';

class ContractService {
  final HttpService _httpService = HttpService();

  Future<List<ContractModel>> loadContracts(
      String cpfcnpj, String senha) async {
    try {
      var response = await _httpService.post('/api/central/contratos', {
        'cpfcnpj': cpfcnpj,
        'senha': senha,
      });

      List<ContractModel> contracts = List<ContractModel>.from(
          response["contratos"]
          .map((json) => ContractModel.fromJson(json as Map<String, dynamic>)));

      return contracts;
    } catch (e) {
      return [];
    }
  }
}
