import 'package:cabosat/models/invoice_model.dart';
import 'package:cabosat/models/user_model.dart';
import 'package:cabosat/services/data/invoice_service.dart';
import 'package:cabosat/services/storage/secure_storage_service.dart';
import 'package:cabosat/services/storage/sqflite_service.dart';
import 'package:cabosat/services/data/user_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

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

      UserModel? user = await UserService().getUser();

      if (user == null) {
        _isLoading = false;
        _invoices = [];
        _currentInvoice = null;
        notifyListeners();

        return;
      }

      SqfliteService sqfliteService = SqfliteService();

      List<Map<String, dynamic>> invoices =
          await sqfliteService.getData("invoice");

      if (invoices.isNotEmpty) {
        List<dynamic> parsedInvoice = json.decode(invoices[0]['json']);

        _invoices = parsedInvoice.map((e) => InvoiceModel.fromJson(e)).toList();
        _filteredInvoices = _invoices;
        _currentInvoice = _invoices.first;

        _isLoading = false;
        notifyListeners();

        _invoices =
            await InvoiceService().loadInvoices(user.cpfcnpj, user.senha);

        _filteredInvoices = _invoices;

        await sqfliteService.updateData("invoice", {
          "json": json.encode(_invoices.map((e) => e.toJson()).toList()),
          "id": '1'
        });
        notifyListeners();
      } else {
        _invoices =
            await InvoiceService().loadInvoices(user.cpfcnpj, user.senha);
        _filteredInvoices = _invoices;

        await sqfliteService.insertData("invoice", {
          "json": json.encode(_invoices.map((e) => e.toJson()).toList()),
          "id": '1'
        });

        notifyListeners();
      }
    } finally {
      _currentInvoice = _invoices.first;
      _isLoading = false;
      notifyListeners();
    }
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
