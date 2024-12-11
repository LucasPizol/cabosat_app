import 'package:cabosat/models/invoice_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InvoiceService {
  final String _url = "https://cabosat.sgp.net.br";

  Future<List<InvoiceModel>> loadInvoices(String cpfcnpj, String senha) async {
    try {
      final httpRequest =
          await http.post(Uri.parse('$_url/api/central/titulos'), body: {
        'cpfcnpj': cpfcnpj,
        'senha': senha,
      });

      if (httpRequest.statusCode != 200) {
        return [];
      }

      var body = json.decode(httpRequest.body);

      List<InvoiceModel> invoices = List<InvoiceModel>.from(body["faturas"]
          .map((json) => InvoiceModel.fromJson(json as Map<String, dynamic>)));

      invoices.sort((a, b) {
        List<String> splittedA = a.vencimento!.split('/');
        List<String> splittedB = b.vencimento!.split('/');

        String dateA = "${splittedA[2]}-${splittedA[1]}-${splittedA[0]}";
        String dateB = "${splittedB[2]}-${splittedB[1]}-${splittedB[0]}";

        DateTime parsedDateA = DateTime.parse(dateA);
        DateTime parsedDateB = DateTime.parse(dateB);
        return parsedDateB.compareTo(parsedDateA);
      });

      return invoices;
    } catch (e) {
      return [];
    }
  }
}
