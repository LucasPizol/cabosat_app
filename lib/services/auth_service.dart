import 'package:http/http.dart' as http;

class AuthService {
  final String _url = "https://cabosat.sgp.net.br";

  Future<bool> login(String cpfcnpj, String senha) async {
    try {
      final httpRequest = await http.post(
        Uri.parse('$_url/accounts/central/login/'),
        body: {
          'cpfcnpj': cpfcnpj,
          'senha': senha,
        },
      );

      return httpRequest.headers['location'] == "/central/home";
    } catch (e) {
      return false;
    }
  }
}
