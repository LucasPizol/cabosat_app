import 'package:cabosat/models/invoice_model.dart';
import 'package:cabosat/services/http_service.dart';

class InvoiceService {
  final HttpService _httpService = HttpService();

  Future<List<InvoiceModel>> loadInvoices(String cpfcnpj, String senha) async {
    try {
      final httpRequest = await _httpService.post('/api/central/titulos', {
        'cpfcnpj': cpfcnpj,
        'senha': senha,
      });

      List<InvoiceModel> invoices = List<InvoiceModel>.from(httpRequest["faturas"]
          .map((json) => InvoiceModel.fromJson(json as Map<String, dynamic>)));

      invoices.sort((a, b) {
        List<String> splittedA = a.vencimentoAtualizado!.split('/');
        List<String> splittedB = b.vencimentoAtualizado!.split('/');

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
