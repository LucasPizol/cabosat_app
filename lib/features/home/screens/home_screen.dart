import 'package:cabosat/features/home/widgets/expired_invoice_alert.dart';
import 'package:cabosat/features/home/widgets/invoice_card.dart';
import 'package:cabosat/features/home/widgets/plan_card.dart';
import 'package:cabosat/models/invoice_model.dart';
import 'package:cabosat/provider/contract_provider.dart';
import 'package:cabosat/provider/invoices_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget getInvoiceContent(InvoiceModel? lastInvoice, bool isLoading) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    bool isEmpty = lastInvoice == null;

    return isEmpty
        ? const Center(
            child: Text("Nenhuma fatura encontrada"),
          )
        : InvoiceCard(
            invoice: lastInvoice,
          );
  }

  String formatName(String name) {
    String firstName = name.split(" ")[0];

    return "${name.substring(0, 1).toUpperCase()}${firstName.substring(1).toLowerCase()}";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, InvoiceModelProvider invoice, child) {
      return Consumer(builder: (context, ContractProvider contract, child) {
        if (invoice.isLoading || contract.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<InvoiceModel> expiredInvoices = invoice.invoices
            .where((element) => element.status == InvoiceStatus.Vencido)
            .toList();

        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Olá, ${formatName(contract.currentContract?.razaoSocial ?? "Cliente ")}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(
                  height: 20,
                ),
                ExpiredInvoiceAlert(expiredInvoices: expiredInvoices),
                expiredInvoices.isNotEmpty
                    ? const SizedBox(
                        height: 20,
                      )
                    : Container(),
                getInvoiceContent(invoice.currentInvoice, invoice.isLoading),
                const SizedBox(
                  height: 20,
                ),
                const PlanCard(),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      });
    });
  }
}
