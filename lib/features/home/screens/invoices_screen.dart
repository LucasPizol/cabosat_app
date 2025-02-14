import 'package:cabosat/features/home/widgets/blanks_slate.dart';
import 'package:cabosat/features/home/widgets/invoice_widget.dart';
import 'package:cabosat/provider/invoices_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  String filter = "all";

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, InvoiceModelProvider invoice, child) {
      if (invoice.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (invoice.invoices.isEmpty) {
        return const BlanksSlate();
      }

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                    child: Text("Filtros",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w900))),
                DropdownButton(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  value: filter,
                  onChanged: (value) => {
                    invoice.filterInvoices(value.toString()),
                    filter = value.toString(),
                    setState(() {})
                  },
                  items: const [
                    DropdownMenuItem(
                      value: "all",
                      child: Text("Todas"),
                    ),
                    DropdownMenuItem(
                      value: "paid",
                      child: Text("Pagas"),
                    ),
                    DropdownMenuItem(
                      value: "pending",
                      child: Text("Pendentes"),
                    ),
                    DropdownMenuItem(
                      value: "expired",
                      child: Text("Vencidas"),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          invoice.filteredInvoices.isEmpty
              ? const Expanded(flex: 1, child: BlanksSlate())
              : Expanded(
                  flex: 1,
                  child: ListView.builder(
                      itemCount: invoice.filteredInvoices.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        return InvoiceWidget(
                            invoice: invoice.filteredInvoices[index]);
                      }))
        ],
      );
    });
  }
}
