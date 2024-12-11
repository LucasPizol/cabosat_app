import 'package:cabosat/models/invoice_model.dart';
import 'package:cabosat/models/user_model.dart';
import 'package:cabosat/services/invoice_service.dart';
import 'package:cabosat/services/local_storage_service.dart';
import 'package:cabosat/services/user_service.dart';
import 'package:flutter/material.dart';

class InvoiceModelProvider extends ChangeNotifier {
  bool _isLoading = true;
  InvoiceModel? _currentInvoice;
  List<InvoiceModel> _invoices = [];
  List<InvoiceModel> _filteredInvoices = [];

  bool get isLoading => _isLoading;
  List<InvoiceModel> get invoices => _invoices;
  InvoiceModel? get currentInvoice => _currentInvoice;
  List<InvoiceModel> get filteredInvoices => _filteredInvoices;

  Future<void> loadInvoices() async {
    try {
      _isLoading = true;
      notifyListeners();

      UserModel? user =
          await UserService(localStorageService: LocalStorageService())
              .getUser();

      if (user == null) {
        _isLoading = false;
        _invoices = [];
        _currentInvoice = null;
        notifyListeners();

        return;
      }

      _invoices = await InvoiceService().loadInvoices(user.cpfcnpj, user.senha);
      _filteredInvoices = _invoices;

      notifyListeners();

      if (_invoices.isEmpty) {
        _isLoading = false;
        notifyListeners();

        return;
      }

      _currentInvoice = _invoices.first;
      notifyListeners();

      _isLoading = false;
    } finally {}
  }

  void filterInvoices(String filter) {
    if (filter == "all") {
      _filteredInvoices = _invoices;
    } else if (filter == "paid") {
      _filteredInvoices = _invoices
          .where((element) => element.status == InvoiceStatus.Pago)
          .toList();
    } else if (filter == "pending") {
      _filteredInvoices = _invoices
          .where((element) => element.status != InvoiceStatus.Pago)
          .toList();
    } else {
      _filteredInvoices = _invoices
          .where((element) => element.status == InvoiceStatus.Vencido)
          .toList();
    }

    notifyListeners();
  }
}
