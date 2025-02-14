import 'package:cabosat/services/http_service.dart';

class AuthService {
  final HttpService _httpService = HttpService();

  Future<bool> login(String cpfcnpj, String senha) async {
    try {
      await _httpService.post('/api/central/titulos', {
        'cpfcnpj': cpfcnpj,
        'senha': senha,
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}
