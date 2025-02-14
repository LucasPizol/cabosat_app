import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpService {
  final String _url = "https://cabosat.sgp.net.br";

  Future<T> post<T>(String path, Map<String, String> body) async {
    final httpRequest = await http.post(Uri.parse('$_url$path'), body: jsonEncode(body),
      headers: {'Content-Type': 'application/json; charset=utf-8'}
    );

    if (httpRequest.statusCode != 200) {
      throw Exception('HttpService.post: ${httpRequest.statusCode}');
    }

    var jsonBody = json.decode(utf8.decode(httpRequest.bodyBytes));

    return jsonBody as T;
  }

  Future<T> get<T>(String path) async {
    final httpRequest = await http.get(Uri.parse('$_url$path'),
      headers: {'Content-Type': 'application/json, charset=utf-8'}
    );

    if (httpRequest.statusCode != 200) {
      throw Exception('HttpService.get: ${httpRequest.statusCode}');
    }

    var jsonBody = json.decode(utf8.decode(httpRequest.bodyBytes));

    return jsonBody as T;
  }

  Future<void> delete(String path) async {
    final httpRequest = await http.delete(Uri.parse('$_url$path'),
      headers: {'Content-Type': 'application/json, charset=utf-8'}
    );

    if (httpRequest.statusCode != 200) {
      throw Exception('HttpService.delete: ${httpRequest.statusCode}');
    }
  }

  Future<T> put<T>(String path, Map<String, String> body) async {
    final httpRequest = await http.put(Uri.parse('$_url$path'), body: jsonEncode(body),
      headers: {'Content-Type': 'application/json, charset=utf-8'}
    );

    if (httpRequest.statusCode != 200) {
      throw Exception('HttpService.put: ${httpRequest.statusCode}');
    }

    var jsonBody = json.decode(utf8.decode(httpRequest.bodyBytes));

    return jsonBody as T;
  }
}
